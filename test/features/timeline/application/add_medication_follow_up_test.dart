import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  final Map<String, TimelineItem> items = <String, TimelineItem>{};

  @override
  Future<bool> deleteById(String id) async => items.remove(id) != null;

  @override
  Future<TimelineItem?> findById(String id) async => items[id];

  @override
  Future<List<TimelineItem>> listNewestFirst() async => items.values.toList();

  @override
  Future<void> upsert(TimelineItem item) async => items[item.id] = item;
}

void main() {
  test('creates a medication follow-up on the existing Timeline aggregate', () async {
    final repository = _MemoryTimelineRepository();
    final scheduled = DateTime(2026, 9, 25, 8);
    final subject = TimelineItem(
      id: 'subject-1',
      type: TimelineItemType.activity,
      text: 'پیگیری درمان',
      createdAt: scheduled,
    );

    final created = await AddTimelineFollowUp(
      repository: repository,
      clock: () => scheduled,
      idGenerator: () => 'med-1',
    ).add(
      subject: subject,
      reminderAt: scheduled,
      reminderKind: TimelineReminderKind.medicationConsumption,
      medicationName: 'نمونه',
      medicationAmount: 1,
      medicationUnit: 'قرص',
      medicationInterval: const Duration(hours: 8),
    );

    expect(created.parentId, subject.id);
    expect(created.isMedicationConsumptionReminder, isTrue);
    expect(created.medicationName, 'نمونه');
    expect(created.medicationAmount, 1);
    expect(created.medicationUnit, 'قرص');
    expect(created.medicationInterval, const Duration(hours: 8));
    expect(created.scheduledAt, scheduled);
    expect(created.actualTakenAt, isNull);
    expect(created.reminderRecurrence, TimelineReminderRecurrence.none);
    expect(repository.items, contains('med-1'));
  });
}
