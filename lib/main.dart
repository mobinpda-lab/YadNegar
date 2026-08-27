import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/restore_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/data/json_timeline_backup_service.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_backup_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_snapshot_restore_action.dart';
import 'package:yadnegar/theme/app_fonts.dart';

final Random _secureRandom = Random.secure();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasLicensedIranSansX = await AppFonts.loadLicensedIranSansX();

  final supportDirectory = await getApplicationSupportDirectory();
  final repository = JsonFileTimelineRepository(
    File('${supportDirectory.path}/timeline.json'),
  );
  final backupService = JsonTimelineBackupService(
    repository: repository,
    clock: DateTime.now,
  );

  runApp(
    YadNegarApp(
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
        child: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: DateTime.now,
            idGenerator: _generateTimelineId,
          ),
          loadTimeline: LoadTimeline(repository: repository),
          editTimelineItem: EditTimelineItem(repository: repository),
          deleteTimelineItem: DeleteTimelineItem(repository: repository),
          restoreTimelineItem: RestoreTimelineItem(repository: repository),
          restoreTimelineSnapshot: () async {
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
                (selected.path == null
                    ? null
                    : await File(selected.path!).readAsBytes());
            if (bytes == null) {
              return TimelineSnapshotRestoreResult.invalidBackup;
            }

            try {
              await repository.restoreValidatedSnapshotBytes(bytes);
              return TimelineSnapshotRestoreResult.restored;
            } on UnsupportedTimelineStorageSchemaException {
              return TimelineSnapshotRestoreResult.unsupportedSchema;
            } on DuplicateTimelineItemIdException {
              return TimelineSnapshotRestoreResult.duplicateId;
            } on FormatException {
              return TimelineSnapshotRestoreResult.invalidBackup;
            }
          },
          searchTimeline: SearchTimeline(repository: repository),
          filterTimelineByDateRange: FilterTimelineByDateRange(
            repository: repository,
          ),
        ),
      ),
    ),
  );
}

String _generateTimelineId() {
  final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
  final randomPart = _secureRandom.nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
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
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: home,
    );
  }
}
