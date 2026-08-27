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
    bool replaceOccurredAt = false,
    DateTime? occurredAt,
  }) async {
    final normalizedId = id.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(id, 'id', 'Timeline item id cannot be empty.');
    }

    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      throw ArgumentError.value(text, 'text', 'Timeline item text cannot be empty.');
    }

    final existing = await repository.findById(normalizedId);
    if (existing == null) {
      throw StateError('Timeline item "$normalizedId" was not found.');
    }

    final targetType = type ?? existing.type;
    final changedToTypeWithoutOccurredAt =
        type != null && !_supportsOccurredAt(targetType);

    final updated = TimelineItem(
      id: existing.id,
      type: targetType,
      text: normalizedText,
      createdAt: existing.createdAt,
      occurredAt: changedToTypeWithoutOccurredAt
          ? null
          : replaceOccurredAt
              ? occurredAt
              : existing.occurredAt,
      reminderAt: existing.reminderAt,
    );

    await repository.upsert(updated);
    return updated;
  }

  bool _supportsOccurredAt(TimelineItemType type) {
    return type == TimelineItemType.event || type == TimelineItemType.activity;
  }
}
