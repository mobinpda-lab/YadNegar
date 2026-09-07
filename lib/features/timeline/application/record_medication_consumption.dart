import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

/// Records a user's actual medication consumption on the existing Timeline
/// aggregate. This is scheduling state only; it never changes dose or interval.
class RecordMedicationConsumption {
  const RecordMedicationConsumption(this.repository);

  final TimelineRepository repository;

  Future<TimelineItem> call({
    required TimelineItem reminder,
    DateTime? actualTakenAt,
  }) async {
    if (!reminder.isMedicationConsumptionReminder) {
      throw ArgumentError.value(reminder.id, 'reminder', 'Not a medication reminder.');
    }
    if (reminder.medicationInterval == null || reminder.medicationInterval! <= Duration.zero) {
      throw StateError('Medication reminder must have a positive interval.');
    }

    final takenAt = actualTakenAt ?? DateTime.now();
    final nextDueAt = takenAt.add(reminder.medicationInterval!);
    final updated = TimelineItem(
      id: reminder.id,
      type: reminder.type,
      text: reminder.text,
      description: reminder.description,
      projectId: reminder.projectId,
      categoryId: reminder.categoryId,
      tagIds: reminder.tagIds,
      nextActionAt: reminder.nextActionAt,
      parentId: reminder.parentId,
      occurredAt: reminder.occurredAt,
      createdAt: reminder.createdAt,
      reminderAt: nextDueAt,
      reminderRecurrence: TimelineReminderRecurrence.none,
      reminderKind: TimelineReminderKind.medicationConsumption,
      medicationName: reminder.medicationName,
      medicationAmount: reminder.medicationAmount,
      medicationUnit: reminder.medicationUnit,
      medicationInterval: reminder.medicationInterval,
      scheduledAt: reminder.scheduledAt ?? reminder.reminderAt,
      actualTakenAt: takenAt,
    );
    await repository.upsert(updated);
    return updated;
  }
}
