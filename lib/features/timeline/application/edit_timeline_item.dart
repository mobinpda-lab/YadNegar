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

    final updated = TimelineItem(
      id: existing.id,
      type: existing.type,
      text: normalizedText,
      createdAt: existing.createdAt,
      occurredAt: replaceOccurredAt ? occurredAt : existing.occurredAt,
    );

    await repository.upsert(updated);
    return updated;
  }
}
