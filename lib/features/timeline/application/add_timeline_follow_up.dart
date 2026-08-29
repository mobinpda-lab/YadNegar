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
  }) async {
    if (!subject.isTrackedSubject) {
      throw ArgumentError.value(subject.id, 'subject', 'must be a root subject');
    }

    final normalized = text.trim();
    final now = clock();
    final followUp = TimelineItem(
      id: idGenerator(),
      parentId: subject.id,
      type: subject.type,
      text: normalized.isEmpty ? 'پیگیری' : normalized,
      createdAt: now,
      occurredAt: occurredAt ?? now,
      reminderAt: reminderAt,
      reminderRecurrence: reminderRecurrence,
    );
    await repository.upsert(followUp);
    return followUp;
  }
}
