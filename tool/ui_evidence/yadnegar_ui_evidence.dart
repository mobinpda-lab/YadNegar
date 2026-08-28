import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/core/presentation/persian_date_range_picker.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/load_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_home.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  final List<TimelineItem> items;

  @override
  Future<bool> deleteById(String id) async {
    final before = items.length;
    items.removeWhere((item) => item.id == id);
    return before != items.length;
  }

  @override
  Future<TimelineItem?> findById(String id) async {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async {
    final result = List<TimelineItem>.of(items)
      ..sort((left, right) => right.timelineAt.compareTo(left.timelineAt));
    return result;
  }

  @override
  Future<void> upsert(TimelineItem item) async {
    final index = items.indexWhere((candidate) => candidate.id == item.id);
    if (index < 0) {
      items.add(item);
    } else {
      items[index] = item;
    }
  }
}

void main() {
  final now = DateTime(2026, 8, 28, 14, 30);

  setUpAll(() async {
    final fontLoader = FontLoader('Vazirmatn')
      ..addFont(rootBundle.load('assets/fonts/vazirmatn/Vazirmatn-UI-FD-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/vazirmatn/Vazirmatn-UI-FD-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/vazirmatn/Vazirmatn-UI-FD-SemiBold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/vazirmatn/Vazirmatn-UI-FD-Bold.ttf'));
    await fontLoader.load();
  });

  testWidgets('render Home and latest-follow-up card evidence', (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final roots = <TimelineItem>[
      TimelineItem(
        id: 'ali',
        type: TimelineItemType.call,
        text: 'تماس با علی',
        createdAt: DateTime(2026, 8, 10, 9),
      ),
      TimelineItem(
        id: 'report',
        type: TimelineItemType.activity,
        text: 'بررسی گزارش عملکرد',
        createdAt: DateTime(2026, 8, 18, 8),
      ),
      TimelineItem(
        id: 'invoice',
        type: TimelineItemType.note,
        text: 'ارسال فاکتور به مشتری',
        createdAt: DateTime(2026, 8, 24, 11),
      ),
      TimelineItem(
        id: 'team',
        type: TimelineItemType.event,
        text: 'جلسه هماهنگی تیم توسعه',
        createdAt: DateTime(2026, 8, 20, 10),
      ),
    ];
    final followUps = <TimelineItem>[
      TimelineItem(
        id: 'ali-f1',
        parentId: 'ali',
        type: TimelineItemType.call,
        text: 'هماهنگی انجام شد',
        createdAt: DateTime(2026, 8, 28, 12, 20),
      ),
      TimelineItem(
        id: 'ali-f0',
        parentId: 'ali',
        type: TimelineItemType.call,
        text: 'اولین تماس',
        createdAt: DateTime(2026, 8, 23, 9, 20),
      ),
      TimelineItem(
        id: 'report-f1',
        parentId: 'report',
        type: TimelineItemType.activity,
        text: 'نسخه اولیه بررسی شد',
        createdAt: DateTime(2026, 8, 26, 9, 15),
      ),
      TimelineItem(
        id: 'team-f1',
        parentId: 'team',
        type: TimelineItemType.event,
        text: 'جلسه برگزار شد',
        createdAt: DateTime(2026, 8, 25, 9, 30),
      ),
    ];
    final repository = _MemoryTimelineRepository([...roots, ...followUps]);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, fontFamily: 'Vazirmatn'),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TrackedSubjectHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => now,
              idGenerator: () => 'new-root',
            ),
            loadSubjects: LoadTrackedSubjects(repository: repository),
            loadFollowUps: LoadTimelineFollowUps(repository: repository),
            addFollowUp: AddTimelineFollowUp(
              repository: repository,
              clock: () => now,
              idGenerator: () => 'new-follow-up',
            ),
            editTimelineItem: EditTimelineItem(repository: repository),
            clock: () => now,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('tracked-subject-home-scroll')),
      matchesGoldenFile('goldens/yadnegar_home.png'),
    );
    await expectLater(
      find.byKey(const Key('tracked-subject-ali')),
      matchesGoldenFile('goldens/yadnegar_latest_followup_card.png'),
    );
  });

  testWidgets('render Persian Jalali range calendar evidence', (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, fontFamily: 'Vazirmatn'),
        home: Builder(
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () => showYadNegarPersianDateRangePicker(
                    context: context,
                    initialRange: DateTimeRange(
                      start: DateTime(2026, 8, 28),
                      end: DateTime(2026, 8, 31),
                    ),
                  ),
                  child: const Text('تقویم'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('تقویم'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('persian-date-range-dialog')),
      matchesGoldenFile('goldens/yadnegar_jalali_calendar.png'),
    );
  });
}
