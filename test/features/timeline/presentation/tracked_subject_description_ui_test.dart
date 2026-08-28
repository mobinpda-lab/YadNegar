import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_detail.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_edit_screen.dart';

void main() {
  testWidgets('detail renders tracked-task description', (tester) async {
    final subject = _subject(description: 'خلاصه قرارداد و نکات تماس بعدی');
    final repository = _MemoryRepository(<TimelineItem>[subject]);

    await tester.pumpWidget(
      MaterialApp(
        home: TrackedSubjectDetail(
          subject: subject,
          loadFollowUps: LoadTimelineFollowUps(repository: repository),
          addFollowUp: AddTimelineFollowUp(
            repository: repository,
            clock: () => DateTime(2026, 8, 28, 12),
            idGenerator: () => 'follow-up',
          ),
          editTimelineItem: EditTimelineItem(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('tracked-subject-description')),
      findsOneWidget,
    );
    expect(find.text('خلاصه قرارداد و نکات تماس بعدی'), findsOneWidget);
  });

  testWidgets('edit screen exposes existing optional description', (tester) async {
    final subject = _subject(description: 'شرح قبلی');
    final repository = _MemoryRepository(<TimelineItem>[subject]);

    await tester.pumpWidget(
      MaterialApp(
        home: TrackedSubjectEditScreen(
          subject: subject,
          editTimelineItem: EditTimelineItem(repository: repository),
        ),
      ),
    );

    final field = tester.widget<TextField>(
      find.byKey(const Key('tracked-subject-edit-description')),
    );
    expect(field.controller!.text, 'شرح قبلی');
  });
}

TimelineItem _subject({String? description}) {
  return TimelineItem(
    id: 'subject',
    type: TimelineItemType.activity,
    text: 'پیگیری قرارداد',
    description: description,
    createdAt: DateTime(2026, 8, 28, 10),
  );
}

class _MemoryRepository implements TimelineRepository {
  _MemoryRepository(List<TimelineItem> items)
      : items = <TimelineItem>[...items];

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
  Future<List<TimelineItem>> listNewestFirst() async => <TimelineItem>[...items];

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
