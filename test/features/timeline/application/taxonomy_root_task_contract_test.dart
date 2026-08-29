import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('root task capture normalizes category and de-duplicates tags', () async {
    final repository = _MemoryTimelineRepository();
    final capture = QuickCapture(
      repository: repository,
      clock: () => DateTime(2026, 8, 29, 12),
      idGenerator: () => 'root-1',
    );

    final item = await capture.capture(
      text: 'کار نمونه',
      categoryId: ' personal ',
      tagIds: const <String>[' مهم ', 'پیگیری', 'مهم', '  '],
    );

    expect(item.categoryId, 'personal');
    expect(item.tagIds, <String>['مهم', 'پیگیری']);
  });

  test('editing root taxonomy preserves unrelated task fields', () async {
    final repository = _MemoryTimelineRepository();
    final original = TimelineItem(
      id: 'root-1',
      type: TimelineItemType.note,
      text: 'کار نمونه',
      description: 'شرح',
      projectId: 'project-1',
      categoryId: 'old-category',
      tagIds: const <String>['old-tag'],
      nextActionAt: DateTime(2026, 8, 30, 9),
      createdAt: DateTime(2026, 8, 29, 8),
      reminderAt: DateTime(2026, 8, 30, 8),
      reminderRecurrence: TimelineReminderRecurrence.daily,
    );
    await repository.upsert(original);

    final updated = await EditTimelineItem(repository: repository).update(
      id: original.id,
      text: original.text,
      replaceCategoryId: true,
      categoryId: 'new-category',
      replaceTagIds: true,
      tagIds: const <String>['الف', 'ب', 'الف'],
    );

    expect(updated.categoryId, 'new-category');
    expect(updated.tagIds, <String>['الف', 'ب']);
    expect(updated.projectId, original.projectId);
    expect(updated.description, original.description);
    expect(updated.nextActionAt, original.nextActionAt);
    expect(updated.reminderAt, original.reminderAt);
    expect(updated.reminderRecurrence, original.reminderRecurrence);
  });

  test('follow-up edit cannot acquire category or tags', () async {
    final repository = _MemoryTimelineRepository();
    final followUp = TimelineItem(
      id: 'follow-1',
      parentId: 'root-1',
      type: TimelineItemType.note,
      text: 'پیگیری',
      createdAt: DateTime(2026, 8, 29, 12),
    );
    await repository.upsert(followUp);

    final updated = await EditTimelineItem(repository: repository).update(
      id: followUp.id,
      text: followUp.text,
      replaceCategoryId: true,
      categoryId: 'category-1',
      replaceTagIds: true,
      tagIds: const <String>['tag-1'],
    );

    expect(updated.categoryId, isNull);
    expect(updated.tagIds, isEmpty);
  });
}

class _MemoryTimelineRepository implements TimelineRepository {
  final Map<String, TimelineItem> _items = <String, TimelineItem>{};

  @override
  Future<bool> deleteById(String id) async => _items.remove(id) != null;

  @override
  Future<TimelineItem?> findById(String id) async => _items[id];

  @override
  Future<List<TimelineItem>> listNewestFirst() async => _items.values.toList();

  @override
  Future<void> upsert(TimelineItem item) async {
    _items[item.id] = item;
  }
}
