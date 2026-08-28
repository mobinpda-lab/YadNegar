import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class EditTimelineItem {
  const EditTimelineItem({required this.repository});

  final TimelineRepository repository;

  Future<TimelineItem> updateText({
    required String id,
    required String text,
  }) {
    return update(id: id, text: text);
  }

  Future<TimelineItem> update({
    required String id,
    required String text,
    TimelineItemType? type,
    bool replaceDescription = false,
    String? description,
    bool replaceProjectId = false,
    String? projectId,
    bool replaceNextActionAt = false,
    DateTime? nextActionAt,
    bool replaceOccurredAt = false,
    DateTime? occurredAt,
    bool replaceReminderAt = false,
    DateTime? reminderAt,
    bool replaceReminderRecurrence = false,
    TimelineReminderRecurrence? reminderRecurrence,
  }) async {
    final normalizedId = id.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(id, 'id', 'Timeline item id cannot be empty.');
    }

    final existing = await repository.findById(normalizedId);
    if (existing == null) {
      throw StateError('Timeline item "$normalizedId" was not found.');
    }

    final normalizedText = text.trim();
    final targetText = existing.isFollowUp && normalizedText.isEmpty
        ? 'پیگیری'
        : normalizedText;
    if (targetText.isEmpty) {
      throw ArgumentError.value(text, 'text', 'Timeline item text cannot be empty.');
    }

    final normalizedDescription = description?.trim();
    final replacementDescription =
        normalizedDescription == null || normalizedDescription.isEmpty
            ? null
            : normalizedDescription;
    final targetDescription = existing.isFollowUp
        ? existing.description
        : replaceDescription
            ? replacementDescription
            : existing.description;

    final normalizedProjectId = projectId?.trim();
    final replacementProjectId =
        normalizedProjectId == null || normalizedProjectId.isEmpty
            ? null
            : normalizedProjectId;
    final targetProjectId = existing.isFollowUp
        ? null
        : replaceProjectId
            ? replacementProjectId
            : existing.projectId;

    if (existing.isFollowUp && replaceNextActionAt && nextActionAt != null) {
      throw ArgumentError.value(
        nextActionAt,
        'nextActionAt',
        'FollowUps cannot own a next action.',
      );
    }
    final targetNextActionAt = existing.isFollowUp
        ? null
        : replaceNextActionAt
            ? nextActionAt
            : existing.nextActionAt;

    final targetType = type ?? existing.type;
    final changedToTypeWithoutOccurredAt =
        type != null && !_supportsOccurredAt(targetType) && !existing.isFollowUp;
    final targetReminderAt = replaceReminderAt ? reminderAt : existing.reminderAt;
    final targetReminderRecurrence = targetReminderAt == null
        ? TimelineReminderRecurrence.none
        : replaceReminderRecurrence
            ? (reminderRecurrence ?? TimelineReminderRecurrence.none)
            : existing.reminderRecurrence;

    final updated = TimelineItem(
      id: existing.id,
      parentId: existing.parentId,
      type: targetType,
      text: targetText,
      description: targetDescription,
      projectId: targetProjectId,
      nextActionAt: targetNextActionAt,
      createdAt: existing.createdAt,
      occurredAt: changedToTypeWithoutOccurredAt
          ? null
          : replaceOccurredAt
              ? occurredAt
              : existing.occurredAt,
      reminderAt: targetReminderAt,
      reminderRecurrence: targetReminderRecurrence,
    );

    await repository.upsert(updated);
    return updated;
  }

  bool _supportsOccurredAt(TimelineItemType type) {
    return type == TimelineItemType.event || type == TimelineItemType.activity;
  }
}
