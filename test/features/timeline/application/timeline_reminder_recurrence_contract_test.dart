import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('TimelineItem normalizes recurrence to none without reminderAt', () {
    final item = TimelineItem(
      id: 'normalized',
      type: TimelineItemType.note,
      text: 'بدون زمان یادآور',
      createdAt: DateTime.utc(2026, 8, 27, 10),
      reminderRecurrence: TimelineReminderRecurrence.daily,
    );

    expect(item.reminderAt, isNull);
    expect(item.reminderRecurrence, TimelineReminderRecurrence.none);
  });

  test('Quick Capture persists recurrence on the same Timeline item', () async {
    final repository = _MemoryTimelineRepository();
    final reminderAt = DateTime.utc(2030, 1, 2, 9, 30);
    final quickCapture = QuickCapture(
      repository: repository,
      clock: () => DateTime.utc(2026, 8, 27, 10),
      idGenerator: () => 'quick-weekly',
    );

    final item = await quickCapture.capture(
      text: 'پیگیری هفتگی',
      reminderAt: reminderAt,
      reminderRecurrence: TimelineReminderRecurrence.weekly,
    );

    final stored = await repository.findById(item.id);
    expect(stored, isNotNull);
    expect(stored!.reminderAt, reminderAt);
    expect(stored.reminderRecurrence, TimelineReminderRecurrence.weekly);
  });

  test('Edit can change recurrence while preserving reminderAt', () async {
    final reminderAt = DateTime.utc(2030, 1, 3, 11);
    final repository = _MemoryTimelineRepository(
      <TimelineItem>[
        TimelineItem(
          id: 'edit-recurrence',
          type: TimelineItemType.note,
          text: 'پیگیری',
          createdAt: DateTime.utc(2026, 8, 27, 10),
          reminderAt: reminderAt,
          reminderRecurrence: TimelineReminderRecurrence.daily,
        ),
      ],
    );

    final updated = await EditTimelineItem(repository: repository).update(
      id: 'edit-recurrence',
      text: 'پیگیری',
      replaceReminderRecurrence: true,
      reminderRecurrence: TimelineReminderRecurrence.weekly,
    );

    expect(updated.reminderAt, reminderAt);
    expect(updated.reminderRecurrence, TimelineReminderRecurrence.weekly);
    expect(
      (await repository.findById(updated.id))!.reminderRecurrence,
      TimelineReminderRecurrence.weekly,
    );
  });

  test('clearing reminder also clears persisted recurrence', () async {
    final repository = _MemoryTimelineRepository(
      <TimelineItem>[
        TimelineItem(
          id: 'clear-recurrence',
          type: TimelineItemType.note,
          text: 'پاک شود',
          createdAt: DateTime.utc(2026, 8, 27, 10),
          reminderAt: DateTime.utc(2030, 1, 4, 12),
          reminderRecurrence: TimelineReminderRecurrence.weekly,
        ),
      ],
    );

    final updated = await EditTimelineItem(repository: repository).update(
      id: 'clear-recurrence',
      text: 'پاک شود',
      replaceReminderAt: true,
      reminderAt: null,
    );

    expect(updated.reminderAt, isNull);
    expect(updated.reminderRecurrence, TimelineReminderRecurrence.none);
  });
}

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository([Iterable<TimelineItem> seed = const <TimelineItem>[]]) {
    for (final item in seed) {
      _items[item.id] = item;
    }
  }

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
