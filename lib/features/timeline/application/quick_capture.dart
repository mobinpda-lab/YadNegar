import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

typedef TimelineClock = DateTime Function();
typedef TimelineIdGenerator = String Function();

class QuickCapture {
  const QuickCapture({
    required this.repository,
    required this.clock,
    required this.idGenerator,
  });

  final TimelineRepository repository;
  final TimelineClock clock;
  final TimelineIdGenerator idGenerator;

  Future<TimelineItem> capture({
    required String text,
    String? description,
    String? projectId,
    DateTime? nextActionAt,
    TimelineItemType type = TimelineItemType.note,
    DateTime? occurredAt,
    DateTime? reminderAt,
    TimelineReminderRecurrence reminderRecurrence = TimelineReminderRecurrence.none,
  }) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      throw ArgumentError.value(text, 'text', 'Quick Capture text cannot be empty.');
    }

    final normalizedDescription = description?.trim();
    final targetDescription = normalizedDescription == null || normalizedDescription.isEmpty
        ? null
        : normalizedDescription;
    final normalizedProjectId = projectId?.trim();
    final targetProjectId = normalizedProjectId == null || normalizedProjectId.isEmpty
        ? null
        : normalizedProjectId;

    final id = idGenerator().trim();
    if (id.isEmpty) {
      throw StateError('Quick Capture id generator returned an empty id.');
    }

    final item = TimelineItem(
      id: id,
      type: type,
      text: normalizedText,
      description: targetDescription,
      projectId: targetProjectId,
      nextActionAt: nextActionAt,
      createdAt: clock(),
      occurredAt: occurredAt,
      reminderAt: reminderAt,
      reminderRecurrence: reminderRecurrence,
    );

    await repository.upsert(item);
    return item;
  }
}
