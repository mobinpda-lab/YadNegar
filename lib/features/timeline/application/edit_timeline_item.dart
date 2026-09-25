import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class EditTimelineItem {
  const EditTimelineItem({required this.repository});
  final TimelineRepository repository;

  Future<TimelineItem> updateText({required String id, required String text}) => update(id: id, text: text);

  Future<TimelineItem> update({
    required String id,
    required String text,
    TimelineItemType? type,
    bool replaceDescription = false,
    String? description,
    bool replaceProjectId = false,
    String? projectId,
    bool replaceCategoryId = false,
    String? categoryId,
    bool replaceTagIds = false,
    List<String>? tagIds,
    bool replaceNextActionAt = false,
    DateTime? nextActionAt,
    bool replaceOccurredAt = false,
    DateTime? occurredAt,
    bool replaceReminderAt = false,
    DateTime? reminderAt,
    bool replaceReminderRecurrence = false,
    TimelineReminderRecurrence? reminderRecurrence,
    bool replaceFollowUpStatus = false,
    TimelineFollowUpStatus? followUpStatus,
    bool replaceMedication = false,
    TimelineReminderKind? reminderKind,
    String? medicationName,
    double? medicationAmount,
    String? medicationUnit,
    Duration? medicationInterval,
    DateTime? scheduledAt,
    DateTime? actualTakenAt,
  }) async {
    final normalizedId = id.trim();
    if (normalizedId.isEmpty) throw ArgumentError.value(id, 'id', 'Timeline item id cannot be empty.');
    final existing = await repository.findById(normalizedId);
    if (existing == null) throw StateError('Timeline item "$normalizedId" was not found.');

    final normalizedText = text.trim();
    final targetText = existing.isFollowUp && normalizedText.isEmpty ? 'پیگیری' : normalizedText;
    if (targetText.isEmpty) throw ArgumentError.value(text, 'text', 'Timeline item text cannot be empty.');

    final normalizedDescription = description?.trim();
    final replacementDescription = normalizedDescription == null || normalizedDescription.isEmpty ? null : normalizedDescription;
    final targetDescription = existing.isFollowUp ? existing.description : replaceDescription ? replacementDescription : existing.description;

    final normalizedProjectId = projectId?.trim();
    final replacementProjectId = normalizedProjectId == null || normalizedProjectId.isEmpty ? null : normalizedProjectId;
    final targetProjectId = existing.isFollowUp ? null : replaceProjectId ? replacementProjectId : existing.projectId;

    final normalizedCategoryId = categoryId?.trim();
    final replacementCategoryId = normalizedCategoryId == null || normalizedCategoryId.isEmpty ? null : normalizedCategoryId;
    final targetCategoryId = existing.isFollowUp ? null : replaceCategoryId ? replacementCategoryId : existing.categoryId;

    final replacementTagIds = (tagIds ?? const <String>[]).map((value) => value.trim()).where((value) => value.isNotEmpty).toSet().toList(growable: false);
    final targetTagIds = existing.isFollowUp ? const <String>[] : replaceTagIds ? replacementTagIds : existing.tagIds;

    if (existing.isFollowUp && replaceNextActionAt && nextActionAt != null) {
      throw ArgumentError.value(nextActionAt, 'nextActionAt', 'FollowUps cannot own a next action.');
    }
    final targetNextActionAt = existing.isFollowUp ? null : replaceNextActionAt ? nextActionAt : existing.nextActionAt;

    final targetType = type ?? existing.type;
    final changedToTypeWithoutOccurredAt = type != null && !_supportsOccurredAt(targetType) && !existing.isFollowUp;
    final targetReminderAt = replaceReminderAt ? reminderAt : existing.reminderAt;
    final targetFollowUpStatus = existing.isFollowUp && replaceFollowUpStatus
        ? (followUpStatus ?? TimelineFollowUpStatus.open)
        : existing.followUpStatus;
    final targetReminderRecurrence = targetReminderAt == null
        ? TimelineReminderRecurrence.none
        : replaceReminderRecurrence
            ? (reminderRecurrence ?? TimelineReminderRecurrence.none)
            : existing.reminderRecurrence;
    final targetReminderKind =
        replaceMedication ? (reminderKind ?? TimelineReminderKind.standard) : existing.reminderKind;
    final targetMedicationName =
        replaceMedication ? medicationName?.trim() : existing.medicationName;
    final targetMedicationAmount =
        replaceMedication ? medicationAmount : existing.medicationAmount;
    final targetMedicationUnit =
        replaceMedication ? medicationUnit?.trim() : existing.medicationUnit;
    final targetMedicationInterval =
        replaceMedication ? medicationInterval : existing.medicationInterval;
    final targetScheduledAt =
        replaceMedication ? scheduledAt : existing.scheduledAt;
    final targetActualTakenAt =
        replaceMedication ? actualTakenAt : existing.actualTakenAt;
    if (targetReminderKind == TimelineReminderKind.medicationConsumption) {
      if (targetMedicationName == null || targetMedicationName.isEmpty ||
          targetMedicationAmount == null || !targetMedicationAmount.isFinite ||
          targetMedicationAmount <= 0 ||
          targetMedicationUnit == null || targetMedicationUnit.isEmpty ||
          targetMedicationInterval == null ||
          targetMedicationInterval <= Duration.zero ||
          targetReminderAt == null) {
        throw const FormatException('Medication reminder fields are incomplete.');
      }
    }

    final updated = TimelineItem(
      id: existing.id,
      parentId: existing.parentId,
      type: targetType,
      text: targetText,
      description: targetDescription,
      projectId: targetProjectId,
      categoryId: targetCategoryId,
      tagIds: targetTagIds,
      nextActionAt: targetNextActionAt,
      createdAt: existing.createdAt,
      occurredAt: changedToTypeWithoutOccurredAt ? null : replaceOccurredAt ? occurredAt : existing.occurredAt,
      reminderAt: targetReminderAt,
      reminderRecurrence: targetReminderKind == TimelineReminderKind.medicationConsumption
          ? TimelineReminderRecurrence.none
          : targetReminderRecurrence,
      reminderKind: targetReminderKind,
      medicationName: targetMedicationName,
      medicationAmount: targetMedicationAmount,
      medicationUnit: targetMedicationUnit,
      medicationInterval: targetMedicationInterval,
      scheduledAt: targetScheduledAt,
      actualTakenAt: targetActualTakenAt,
      followUpStatus: targetFollowUpStatus,
    );
    await repository.upsert(updated);
    return updated;
  }

  bool _supportsOccurredAt(TimelineItemType type) => type == TimelineItemType.event || type == TimelineItemType.activity;
}
