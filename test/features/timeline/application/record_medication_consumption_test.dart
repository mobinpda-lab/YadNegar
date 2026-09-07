import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/record_medication_consumption.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  TimelineItem? item;

  @override
  Future<bool> deleteById(String id) async {
    if (item?.id != id) return false;
    item = null;
    return true;
  }

  @override
  Future<TimelineItem?> findById(String id) async => item?.id == id ? item : null;

  @override
  Future<List<TimelineItem>> listNewestFirst() async => item == null ? const [] : [item!];

  @override
  Future<void> upsert(TimelineItem value) async => item = value;
}

void main() {
  test('anchors next due time to actual consumption and keeps scheduled time', () async {
    final repository = _MemoryTimelineRepository();
    final scheduled = DateTime(2026, 9, 7, 8);
    final taken = DateTime(2026, 9, 7, 9, 17);
    final reminder = TimelineItem(
      id: 'med-1',
      type: TimelineItemType.activity,
      text: 'مصرف دارو',
      createdAt: scheduled,
      reminderAt: scheduled,
      reminderKind: TimelineReminderKind.medicationConsumption,
      medicationName: 'نمونه',
      medicationAmount: 1,
      medicationUnit: 'قرص',
      medicationInterval: const Duration(hours: 8),
      scheduledAt: scheduled,
    );

    final updated = await RecordMedicationConsumption(repository)(
      reminder: reminder,
      actualTakenAt: taken,
    );

    expect(updated.scheduledAt, scheduled);
    expect(updated.actualTakenAt, taken);
    expect(updated.reminderAt, taken.add(const Duration(hours: 8)));
    expect(updated.medicationNextDueAt, taken.add(const Duration(hours: 8)));
    expect(repository.item?.id, 'med-1');
  });

  test('does not create a second timeline item', () async {
    final repository = _MemoryTimelineRepository();
    final reminder = TimelineItem(
      id: 'med-1',
      type: TimelineItemType.activity,
      text: 'مصرف دارو',
      createdAt: DateTime(2026, 9, 7, 8),
      reminderAt: DateTime(2026, 9, 7, 8),
      reminderKind: TimelineReminderKind.medicationConsumption,
      medicationInterval: const Duration(hours: 6),
    );

    await RecordMedicationConsumption(repository)(
      reminder: reminder,
      actualTakenAt: DateTime(2026, 9, 7, 8, 30),
    );

    await RecordMedicationConsumption(repository)(
      reminder: repository.item!,
      actualTakenAt: DateTime(2026, 9, 7, 9),
    );

    expect((await repository.listNewestFirst()).length, 1);
    expect(repository.item!.actualTakenAt, DateTime(2026, 9, 7, 9));
  });
}
