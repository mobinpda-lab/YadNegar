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
    required String text,
    DateTime? occurredAt,
  }) async {
    if (!subject.isTrackedSubject) {
      throw ArgumentError.value(subject.id, 'subject', 'must be a root subject');
    }

    final normalized = text.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(text, 'text', 'follow-up text cannot be empty');
    }

    final followUp = TimelineItem(
      id: idGenerator(),
      parentId: subject.id,
      type: subject.type,
      text: normalized,
      createdAt: clock(),
      occurredAt: occurredAt,
    );
    await repository.upsert(followUp);
    return followUp;
  }
}
