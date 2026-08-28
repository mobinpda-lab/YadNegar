import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
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
    return items.length != before;
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
    if (index == -1) {
      items.add(item);
    } else {
      items[index] = item;
    }
  }
}

void main() {
  testWidgets('root opens its own persistent follow-up history', (tester) async {
    final root = TimelineItem(
      id: 'car',
      type: TimelineItemType.activity,
      text: 'سرویس خودرو',
      createdAt: DateTime(2026, 8, 27, 8),
    );
    final existingFollowUp = TimelineItem(
      id: 'car-f1',
      parentId: root.id,
      type: root.type,
      text: 'بررسی روغن انجام شد',
      createdAt: DateTime(2026, 8, 28, 9, 15),
    );
    final repository = _MemoryTimelineRepository([root, existingFollowUp]);
    var generatedId = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TrackedSubjectHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => DateTime(2026, 8, 28, 10),
              idGenerator: () => 'root-${generatedId++}',
            ),
            loadSubjects: LoadTrackedSubjects(repository: repository),
            loadFollowUps: LoadTimelineFollowUps(repository: repository),
            addFollowUp: AddTimelineFollowUp(
              repository: repository,
              clock: () => DateTime(2026, 8, 28, 11, 30),
              idGenerator: () => 'follow-${generatedId++}',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tracked-subject-car')), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-car-f1')), findsNothing);
    expect(find.text('1 پیگیری'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tracked-subject-car')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tracked-subject-detail-title')), findsOneWidget);
    expect(find.byKey(const Key('follow-up-car-f1')), findsOneWidget);
    expect(find.text('بررسی روغن انجام شد'), findsOneWidget);
    expect(find.text('1405/06/06 - 09:15'), findsWidgets);

    await tester.tap(find.byKey(const Key('tracked-subject-add-follow-up')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('follow-up-input')),
      'تماس با تعمیرگاه و تعیین نوبت',
    );
    await tester.tap(find.byKey(const Key('follow-up-save')));
    await tester.pumpAndSettle();

    expect(find.text('تماس با تعمیرگاه و تعیین نوبت'), findsOneWidget);
    expect(find.text('1405/06/06 - 11:30'), findsWidgets);
    expect(
      repository.items.where((item) => item.parentId == root.id),
      hasLength(2),
    );
  });
}
