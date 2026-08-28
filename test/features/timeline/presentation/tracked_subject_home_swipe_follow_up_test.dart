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
  testWidgets('Home shows Bismillah and both swipe directions open FollowUp for same root', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final root = TimelineItem(
      id: 'root-1',
      type: TimelineItemType.activity,
      text: 'کار پروژه',
      description: 'شرح کار',
      projectId: 'project-1',
      createdAt: DateTime(2026, 8, 28, 9),
    );
    final repository = _MemoryTimelineRepository(<TimelineItem>[root]);

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

    expect(find.byKey(const Key('tracked-subject-bismillah')), findsOneWidget);
    expect(find.text('بسم الله الرحمن الرحیم'), findsOneWidget);

    final swipe = find.byKey(const Key('tracked-subject-swipe-root-1'));
    expect(swipe, findsOneWidget);

    final revealGesture = await tester.startGesture(tester.getCenter(swipe));
    await revealGesture.moveBy(const Offset(-80, 0));
    await tester.pump();
    expect(find.text('افزودن پیگیری'), findsOneWidget);
    await revealGesture.up();
    await tester.pumpAndSettle();

    await tester.drag(swipe, const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('follow-up-editor-subject')), findsOneWidget);
    expect(find.text('کار پروژه'), findsWidgets);
    await tester.tap(find.byKey(const Key('follow-up-editor-cancel')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tracked-subject-root-1')), findsOneWidget);
    expect(repository.items.where((item) => item.isTrackedSubject), hasLength(1));

    await tester.drag(find.byKey(const Key('tracked-subject-swipe-root-1')), const Offset(320, 0));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('follow-up-editor-subject')), findsOneWidget);
    expect(find.text('کار پروژه'), findsWidgets);
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
