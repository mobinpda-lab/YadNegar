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
  testWidgets(
    'tracked-task search covers title description and follow-up text',
    (tester) async {
      final titleRoot = TimelineItem(
        id: 'title-root',
        type: TimelineItemType.call,
        text: 'تماس با علی',
        description: 'هماهنگی عادی',
        createdAt: DateTime(2026, 8, 26, 9),
      );
      final descriptionRoot = TimelineItem(
        id: 'description-root',
        type: TimelineItemType.activity,
        text: 'پرونده قرارداد',
        description: 'تحویل نسخه نهایی به مدیریت',
        createdAt: DateTime(2026, 8, 25, 9),
      );
      final followUpRoot = TimelineItem(
        id: 'follow-up-root',
        type: TimelineItemType.activity,
        text: 'امور مالی',
        createdAt: DateTime(2026, 8, 24, 9),
      );
      final followUp = TimelineItem(
        id: 'follow-up-child',
        parentId: followUpRoot.id,
        type: followUpRoot.type,
        text: 'صحبت با حسابدار درباره فاکتور',
        createdAt: DateTime(2026, 8, 28, 10),
      );
      final unrelatedRoot = TimelineItem(
        id: 'unrelated-root',
        type: TimelineItemType.note,
        text: 'خرید لوازم دفتر',
        createdAt: DateTime(2026, 8, 23, 9),
      );
      final repository = _MemoryTimelineRepository([
        titleRoot,
        descriptionRoot,
        followUpRoot,
        followUp,
        unrelatedRoot,
      ]);
      DateTime clock() => DateTime(2026, 8, 28, 14);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: TrackedSubjectHome(
              quickCapture: QuickCapture(
                repository: repository,
                clock: clock,
                idGenerator: () => 'new-root',
              ),
              loadSubjects: LoadTrackedSubjects(repository: repository),
              loadFollowUps: LoadTimelineFollowUps(repository: repository),
              addFollowUp: AddTimelineFollowUp(
                repository: repository,
                clock: clock,
                idGenerator: () => 'new-follow-up',
              ),
              editTimelineItem: EditTimelineItem(repository: repository),
              clock: clock,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final search = find.byKey(const Key('tracked-subject-search'));
      expect(find.text('۴ مورد'), findsOneWidget);

      await tester.enterText(search, 'علی');
      await tester.pump();
      expect(find.text('۱ مورد'), findsOneWidget);
      expect(find.byKey(const Key('tracked-subject-title-root')), findsOneWidget);
      expect(find.byKey(const Key('tracked-subject-description-root')), findsNothing);
      expect(find.byKey(const Key('tracked-subject-follow-up-root')), findsNothing);

      await tester.enterText(search, 'نسخه نهایی');
      await tester.pump();
      expect(find.text('۱ مورد'), findsOneWidget);
      expect(find.byKey(const Key('tracked-subject-description-root')), findsOneWidget);
      expect(find.byKey(const Key('tracked-subject-title-root')), findsNothing);
      expect(find.byKey(const Key('tracked-subject-unrelated-root')), findsNothing);

      await tester.enterText(search, 'حسابدار');
      await tester.pump();
      expect(find.text('۱ مورد'), findsOneWidget);
      expect(find.byKey(const Key('tracked-subject-follow-up-root')), findsOneWidget);
      expect(find.byKey(const Key('tracked-subject-description-root')), findsNothing);
      expect(find.byKey(const Key('tracked-subject-unrelated-root')), findsNothing);

      await tester.tap(find.byKey(const Key('tracked-subject-search-clear')));
      await tester.pump();
      expect(find.text('۴ مورد'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
