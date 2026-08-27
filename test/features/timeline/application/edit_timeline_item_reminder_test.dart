import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('editing text preserves an existing reminderAt', () async {
    final reminderAt = DateTime.utc(2026, 8, 28, 8);
    final original = TimelineItem(
      id: 'note-1',
      type: TimelineItemType.note,
      text: 'قبل',
      createdAt: DateTime.utc(2026, 8, 27, 8),
      reminderAt: reminderAt,
    );
    final repository = _MemoryTimelineRepository(original);

    final updated = await EditTimelineItem(repository: repository).updateText(
      id: original.id,
      text: 'بعد',
    );

    expect(updated.text, 'بعد');
    expect(updated.reminderAt, reminderAt);
    expect(repository.item.reminderAt, reminderAt);
  });
}

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.item);

  TimelineItem item;

  @override
  Future<bool> deleteById(String id) async => false;

  @override
  Future<TimelineItem?> findById(String id) async => id == item.id ? item : null;

  @override
  Future<List<TimelineItem>> listNewestFirst() async => <TimelineItem>[item];

  @override
  Future<void> upsert(TimelineItem item) async {
    this.item = item;
  }
}
