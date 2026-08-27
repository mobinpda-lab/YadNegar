import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('Quick Capture persists optional reminderAt on the shared Timeline item', () async {
    final repository = _MemoryTimelineRepository();
    final reminderAt = DateTime.utc(2026, 8, 28, 7, 30);
    final capture = QuickCapture(
      repository: repository,
      clock: () => DateTime.utc(2026, 8, 27, 6),
      idGenerator: () => 'reminder-1',
    );

    final item = await capture.capture(
      text: 'پیگیری کار مهم',
      reminderAt: reminderAt,
    );

    expect(item.reminderAt, reminderAt);
    expect((await repository.findById(item.id))!.reminderAt, reminderAt);
  });

  test('Edit can replace and then clear reminderAt without changing identity', () async {
    final repository = _MemoryTimelineRepository();
    final original = TimelineItem(
      id: 'reminder-edit-1',
      type: TimelineItemType.note,
      text: 'کار',
      createdAt: DateTime.utc(2026, 8, 27, 6),
      reminderAt: DateTime.utc(2026, 8, 28, 7),
    );
    await repository.upsert(original);
    final edit = EditTimelineItem(repository: repository);
    final replacement = DateTime.utc(2026, 8, 29, 8, 15);

    final changed = await edit.update(
      id: original.id,
      text: original.text,
      replaceReminderAt: true,
      reminderAt: replacement,
    );

    expect(changed.id, original.id);
    expect(changed.createdAt, original.createdAt);
    expect(changed.reminderAt, replacement);

    final cleared = await edit.update(
      id: original.id,
      text: original.text,
      replaceReminderAt: true,
      reminderAt: null,
    );

    expect(cleared.reminderAt, isNull);
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
