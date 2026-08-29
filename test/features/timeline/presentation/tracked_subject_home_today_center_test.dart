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

void main() {
  testWidgets('Today Center counts and filters already-loaded roots', (tester) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final items = <TimelineItem>[
      TimelineItem(
        id: 'today',
        type: TimelineItemType.activity,
        text: 'کار امروز',
        createdAt: DateTime(2026, 8, 20),
        nextActionAt: DateTime(2026, 8, 29, 8),
      ),
      TimelineItem(
        id: 'overdue',
        type: TimelineItemType.activity,
        text: 'کار عقب افتاده',
        createdAt: DateTime(2026, 8, 20),
        nextActionAt: DateTime(2026, 8, 28, 23, 59),
      ),
      TimelineItem(
        id: 'upcoming',
        type: TimelineItemType.activity,
        text: 'کار آینده',
        createdAt: DateTime(2026, 8, 20),
        nextActionAt: DateTime(2026, 8, 30, 9),
      ),
      TimelineItem(
        id: 'none',
        type: TimelineItemType.activity,
        text: 'کار بدون اقدام',
        createdAt: DateTime(2026, 8, 20),
      ),
    ];
    final repository = _MemoryTimelineRepository(items);

    await tester.pumpWidget(
      MaterialApp(
        home: TrackedSubjectHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => DateTime(2026, 8, 29, 14),
            idGenerator: () => 'new-root',
          ),
          loadSubjects: LoadTrackedSubjects(repository: repository),
          loadFollowUps: LoadTimelineFollowUps(repository: repository),
          addFollowUp: AddTimelineFollowUp(
            repository: repository,
            clock: () => DateTime(2026, 8, 29, 14),
            idGenerator: () => 'follow-new',
          ),
          editTimelineItem: EditTimelineItem(repository: repository),
          clock: () => DateTime(2026, 8, 29, 14),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('today-center')), findsOneWidget);
    expect(find.byKey(const Key('today-center-today')), findsOneWidget);
    expect(find.byKey(const Key('today-center-overdue')), findsOneWidget);
    expect(find.byKey(const Key('today-center-upcoming')), findsOneWidget);
    expect(find.byKey(const Key('today-center-noNextAction')), findsOneWidget);

    await tester.tap(find.byKey(const Key('today-center-today')));
    await tester.pump();
    expect(find.byKey(const Key('tracked-subject-today')), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-overdue')), findsNothing);
    expect(find.byKey(const Key('tracked-subject-upcoming')), findsNothing);
    expect(find.byKey(const Key('tracked-subject-none')), findsNothing);

    await tester.tap(find.byKey(const Key('today-center-clear-filter')));
    await tester.pump();
    expect(find.byKey(const Key('tracked-subject-today')), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-overdue')), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-upcoming')), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-none')), findsOneWidget);
  });
}

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
