import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

typedef TimelineFollowUpIdGenerator = String Function();
typedef TimelineFollowUpClock = DateTime Function();

class AddTimelineFollowUp {
  const AddTimelineFollowUp({
    required this.repository,
    required this.clock,
    required this.idGenerator,
  });

  final TimelineRepository repository;
  final TimelineFollowUpClock clock;
  final TimelineFollowUpIdGenerator idGenerator;

  Future<TimelineItem> add({
    required TimelineItem subject,
    String text = '',
    DateTime? occurredAt,
    DateTime? reminderAt,
    TimelineReminderRecurrence reminderRecurrence = TimelineReminderRecurrence.none,
    TimelineFollowUpStatus followUpStatus = TimelineFollowUpStatus.open,
    TimelineReminderKind reminderKind = TimelineReminderKind.standard,
    String? medicationName,
    double? medicationAmount,
    String? medicationUnit,
    Duration? medicationInterval,
    DateTime? scheduledAt,
  }) async {
    if (!subject.isTrackedSubject) {
      throw ArgumentError.value(subject.id, 'subject', 'must be a root subject');
    }

    final normalized = text.trim();
    final now = clock();
    if (reminderKind == TimelineReminderKind.medicationConsumption) {
      final normalizedMedicationName = medicationName?.trim();
      final normalizedMedicationUnit = medicationUnit?.trim();
      if (normalizedMedicationName == null || normalizedMedicationName.isEmpty) {
        throw ArgumentError.value(medicationName, 'medicationName', 'Medication name is required.');
      }
      if (medicationAmount == null || !medicationAmount.isFinite || medicationAmount <= 0) {
        throw ArgumentError.value(medicationAmount, 'medicationAmount', 'Medication amount must be positive.');
      }
      if (normalizedMedicationUnit == null || normalizedMedicationUnit.isEmpty) {
        throw ArgumentError.value(medicationUnit, 'medicationUnit', 'Medication unit is required.');
      }
      if (medicationInterval == null || medicationInterval <= Duration.zero) {
        throw ArgumentError.value(medicationInterval, 'medicationInterval', 'Medication interval must be positive.');
      }
      if (reminderAt == null) {
        throw ArgumentError.value(reminderAt, 'reminderAt', 'Medication reminder requires a first scheduled time.');
      }
    }

    final followUp = TimelineItem(
      id: idGenerator(),
      parentId: subject.id,
      type: subject.type,
      text: normalized.isEmpty ? 'پیگیری' : normalized,
      createdAt: now,
      occurredAt: occurredAt ?? now,
      reminderAt: reminderAt,
      reminderRecurrence: reminderKind == TimelineReminderKind.medicationConsumption
          ? TimelineReminderRecurrence.none
          : reminderRecurrence,
      reminderKind: reminderKind,
      medicationName: medicationName?.trim(),
      medicationAmount: medicationAmount,
      medicationUnit: medicationUnit?.trim(),
      medicationInterval: medicationInterval,
      scheduledAt: reminderKind == TimelineReminderKind.medicationConsumption
          ? (scheduledAt ?? reminderAt)
          : null,
      followUpStatus: followUpStatus,
    );
    await repository.upsert(followUp);
    return followUp;
  }
}
