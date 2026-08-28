import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/build_tracked_subject_export.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/load_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/application/manage_projects.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/restore_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/application/tracked_subject_pdf_document.dart';
import 'package:yadnegar/features/timeline/data/android_local_timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/data/json_timeline_backup_service.dart';
import 'package:yadnegar/features/timeline/presentation/project_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_backup_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_persian_pickers.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_snapshot_restore_action.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_home.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_pdf_scope.dart';
import 'package:yadnegar/theme/app_fonts.dart';

final Random _secureRandom = Random.secure();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();

  var localTimezoneReady = false;
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    localTimezoneReady = true;
  } catch (_) {
    // Recurring reminders fail closed if device timezone cannot be resolved.
  }

  final notifications = FlutterLocalNotificationsPlugin();
  await notifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  final hasLicensedIranSansX = await AppFonts.loadLicensedIranSansX();

  final supportDirectory = await getApplicationSupportDirectory();
  final repository = JsonFileTimelineRepository(
    File('${supportDirectory.path}/timeline.json'),
  );
  final backupService = JsonTimelineBackupService(
    repository: repository,
    clock: DateTime.now,
  );
  final reminderScheduler = AndroidLocalTimelineReminderScheduler(
    notifications: notifications,
    clock: DateTime.now,
    localTimezoneReady: localTimezoneReady,
  );

  try {
    await reminderScheduler.reconcile(await repository.listNewestFirst());
  } catch (_) {
    // Reminder reconciliation is best-effort and must never block app startup.
  }

  final quickCapture = QuickCapture(
    repository: repository,
    clock: DateTime.now,
    idGenerator: _generateTimelineId,
  );
  final loadTimeline = LoadTimeline(repository: repository);
  final editTimelineItem = EditTimelineItem(repository: repository);
  final deleteTimelineItem = DeleteTimelineItem(repository: repository);
  final restoreTimelineItem = RestoreTimelineItem(repository: repository);
  final searchTimeline = SearchTimeline(repository: repository);
  final dateFilter = FilterTimelineByDateRange(repository: repository);
  final loadSubjects = LoadTrackedSubjects(repository: repository);
  final loadFollowUps = LoadTimelineFollowUps(repository: repository);
  final addFollowUp = AddTimelineFollowUp(
    repository: repository,
    clock: DateTime.now,
    idGenerator: _generateTimelineId,
  );
  final manageProjects = ManageProjects(
    projectRepository: repository,
    timelineRepository: repository,
    idGenerator: _generateTimelineId,
  );
  final buildTrackedSubjectExport = BuildTrackedSubjectExport(
    repository: repository,
  );
  const trackedSubjectPdfDocument = TrackedSubjectPdfDocument();

  Future<Uint8List> buildTrackedSubjectPdf(Set<String>? subjectIds) async {
    final export = await buildTrackedSubjectExport.build(subjectIds: subjectIds);
    final regular = await rootBundle.load(
      'assets/fonts/vazirmatn/Vazirmatn-UI-FD-Regular.ttf',
    );
    final bold = await rootBundle.load(
      'assets/fonts/vazirmatn/Vazirmatn-UI-FD-Bold.ttf',
    );
    return trackedSubjectPdfDocument.build(
      export: export,
      regularFontBytes: regular.buffer.asUint8List(
        regular.offsetInBytes,
        regular.lengthInBytes,
      ),
      boldFontBytes: bold.buffer.asUint8List(
        bold.offsetInBytes,
        bold.lengthInBytes,
      ),
    );
  }

  Future<File> createTrackedSubjectPdfFile(Set<String>? subjectIds) async {
    final bytes = await buildTrackedSubjectPdf(subjectIds);
    final temporaryDirectory = await getTemporaryDirectory();
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final file = File('${temporaryDirectory.path}/yadnegar-report-$timestamp.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> shareTrackedSubjectPdf(Set<String>? subjectIds) async {
    final file = await createTrackedSubjectPdfFile(subjectIds);
    await Share.shareXFiles(
      <XFile>[XFile(file.path, mimeType: 'application/pdf')],
      subject: 'گزارش یادنگار',
      text: 'گزارش کارها و پیگیری‌های یادنگار',
    );
  }

  Future<void> printTrackedSubjectPdf(Set<String>? subjectIds) async {
    final bytes = await buildTrackedSubjectPdf(subjectIds);
    await Printing.layoutPdf(
      name: 'yadnegar-report.pdf',
      onLayout: (_) async => bytes,
    );
  }

  Future<TimelineSnapshotRestoreResult> restoreTimelineSnapshot() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return TimelineSnapshotRestoreResult.cancelled;
    }

    final selected = result.files.single;
    final bytes = selected.bytes ??
        (selected.path == null ? null : await File(selected.path!).readAsBytes());
    if (bytes == null) {
      return TimelineSnapshotRestoreResult.invalidBackup;
    }

    try {
      await repository.restoreValidatedSnapshotBytes(bytes);
      try {
        await reminderScheduler.reconcile(await repository.listNewestFirst());
      } catch (_) {
        // The restore is durable; reminder sync can retry at startup.
      }
      return TimelineSnapshotRestoreResult.restored;
    } on UnsupportedTimelineStorageSchemaException {
      return TimelineSnapshotRestoreResult.unsupportedSchema;
    } on DuplicateTimelineItemIdException {
      return TimelineSnapshotRestoreResult.duplicateId;
    } on DuplicateProjectIdException {
      return TimelineSnapshotRestoreResult.duplicateId;
    } on FormatException {
      return TimelineSnapshotRestoreResult.invalidBackup;
    }
  }

  final legacyTimeline = TimelineHome(
    quickCapture: quickCapture,
    loadTimeline: loadTimeline,
    editTimelineItem: editTimelineItem,
    deleteTimelineItem: deleteTimelineItem,
    restoreTimelineItem: restoreTimelineItem,
    reminderScheduler: reminderScheduler,
    restoreTimelineSnapshot: restoreTimelineSnapshot,
    searchTimeline: searchTimeline,
    filterTimelineByDateRange: dateFilter,
    dateRangePicker: pickPersianTimelineDateRange,
    occurredAtPicker: pickPersianTimelineDateTime,
    reminderAtPicker: pickPersianFutureReminderDateTime,
  );

  runApp(
    ProjectScope(
      manageProjects: manageProjects,
      child: TrackedSubjectPdfScope(
        sharePdf: shareTrackedSubjectPdf,
        printPdf: printTrackedSubjectPdf,
        loadSubjects: loadSubjects.load,
        child: YadNegarApp(
          fontFamily: hasLicensedIranSansX
              ? AppFonts.iranSansXFamily
              : AppFonts.vazirmatnFamily,
          home: TimelineBackupScope(
            backupAction: () async {
              final temporaryDirectory = await getTemporaryDirectory();
              final snapshot = await backupService.createSnapshot(temporaryDirectory);
              await Share.shareXFiles(
                <XFile>[XFile(snapshot.path)],
                subject: 'پشتیبان یادنگار',
                text: 'فایل پشتیبان یادنگار',
              );
            },
            child: TrackedSubjectHome(
              quickCapture: quickCapture,
              loadSubjects: loadSubjects,
              loadFollowUps: loadFollowUps,
              addFollowUp: addFollowUp,
              editTimelineItem: editTimelineItem,
              legacyTimeline: legacyTimeline,
            ),
          ),
        ),
      ),
    ),
  );
}

String _generateTimelineId() {
  final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
  final randomPart =
      _secureRandom.nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
  return '$timestamp-$randomPart';
}

class YadNegarApp extends StatelessWidget {
  const YadNegarApp({
    super.key,
    this.home = const TimelineScreen(),
    this.fontFamily = AppFonts.vazirmatnFamily,
  });

  final Widget home;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'یادنگار',
      locale: const Locale('fa'),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        dialogTheme: const DialogThemeData(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: home,
    );
  }
}
