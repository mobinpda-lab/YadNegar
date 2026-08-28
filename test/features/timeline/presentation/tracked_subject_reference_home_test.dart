import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      if (item.id == id) {
        return item;
      }
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
  testWidgets('reference Home stays usable at 320px and keeps latest date-time together', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final root = TimelineItem(
      id: 'ali',
      type: TimelineItemType.call,
      text: 'تماس با علی',
      createdAt: DateTime(2026, 8, 20, 9),
    );
    final followUp = TimelineItem(
      id: 'ali-follow-1',
      parentId: root.id,
      type: root.type,
      text: 'هماهنگی انجام شد',
      createdAt: DateTime(2026, 8, 28, 12, 20),
    );
    final repository = _MemoryTimelineRepository([root, followUp]);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TrackedSubjectHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => DateTime(2026, 8, 28, 14),
              idGenerator: () => 'new-root',
            ),
            loadSubjects: LoadTrackedSubjects(repository: repository),
            loadFollowUps: LoadTimelineFollowUps(repository: repository),
            addFollowUp: AddTimelineFollowUp(
              repository: repository,
              clock: () => DateTime(2026, 8, 28, 14),
              idGenerator: () => 'new-follow',
            ),
            editTimelineItem: EditTimelineItem(repository: repository),
            clock: () => DateTime(2026, 8, 28, 14),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('یادنگار'), findsOneWidget);
    expect(find.text('مدیریت کارها و پیگیری‌ها'), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-search')), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-stats')), findsOneWidget);
    expect(find.text('همه کارها'), findsOneWidget);
    expect(find.text('نیازمند پیگیری'), findsWidgets);
    expect(find.text('دارای پیگیری'), findsOneWidget);
    expect(find.text('پیگیری امروز'), findsOneWidget);
    expect(find.text('خانه'), findsOneWidget);
    expect(find.text('کارها'), findsOneWidget);
    expect(find.text('تقویم'), findsOneWidget);
    expect(find.text('بیشتر'), findsOneWidget);

    expect(
      find.text('آخرین پیگیری: ۱۴۰۵/۰۶/۰۶ ۱۲:۲۰'),
      findsOneWidget,
    );
    expect(find.textContaining('۱۴۰۵/۰۶/۰۶ - ۱۲:۲۰'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
