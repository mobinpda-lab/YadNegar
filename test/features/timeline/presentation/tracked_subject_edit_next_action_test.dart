import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_edit_screen.dart';

void main() {
  testWidgets('task edit shows and clears next action', (tester) async {
    final original = TimelineItem(
      id: 'root-1',
      type: TimelineItemType.activity,
      text: 'کار امروز',
      createdAt: DateTime(2026, 8, 28),
      nextActionAt: DateTime(2026, 8, 29, 9, 30),
    );
    final repository = _MemoryRepository(original);

    await tester.pumpWidget(
      MaterialApp(
        home: TrackedSubjectEditScreen(
          subject: original,
          editTimelineItem: EditTimelineItem(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tracked-subject-edit-next-action')), findsOneWidget);
    expect(find.byKey(const Key('tracked-subject-edit-next-action-clear')), findsOneWidget);
    expect(find.textContaining('۱۴۰۵'), findsWidgets);

    await tester.tap(find.byKey(const Key('tracked-subject-edit-next-action-clear')));
    await tester.pump();
    expect(find.text('زمانی تعیین نشده است'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tracked-subject-edit-confirm')));
    await tester.pumpAndSettle();

    expect(repository.item.nextActionAt, isNull);
    expect(repository.item.id, original.id);
    expect(repository.item.text, original.text);
  });
}

class _MemoryRepository implements TimelineRepository {
  _MemoryRepository(this.item);

  TimelineItem item;

  @override
  Future<bool> deleteById(String id) async => false;

  @override
  Future<TimelineItem?> findById(String id) async => id == item.id ? item : null;

  @override
  Future<List<TimelineItem>> listNewestFirst() async => <TimelineItem>[item];

  @override
  Future<void> upsert(TimelineItem value) async {
    item = value;
  }
}
