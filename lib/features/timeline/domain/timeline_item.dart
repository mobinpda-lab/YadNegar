enum TimelineItemType {
  note,
  event,
  call,
  idea,
  activity,
}

enum TimelineReminderRecurrence {
  none,
  daily,
  weekly,
}

class TimelineItem {
  const TimelineItem({
    required this.id,
    required this.type,
    required this.text,
    required this.createdAt,
    this.occurredAt,
    DateTime? reminderAt,
    TimelineReminderRecurrence reminderRecurrence = TimelineReminderRecurrence.none,
  })  : reminderAt = reminderAt,
        reminderRecurrence = reminderAt == null
            ? TimelineReminderRecurrence.none
            : reminderRecurrence;

  final String id;
  final TimelineItemType type;
  final String text;
  final DateTime createdAt;
  final DateTime? occurredAt;
  final DateTime? reminderAt;
  final TimelineReminderRecurrence reminderRecurrence;

  DateTime get timelineAt => occurredAt ?? createdAt;
}
