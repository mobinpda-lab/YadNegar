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
    this.parentId,
    this.occurredAt,
    this.reminderAt,
    TimelineReminderRecurrence reminderRecurrence = TimelineReminderRecurrence.none,
  }) : reminderRecurrence = reminderAt == null
            ? TimelineReminderRecurrence.none
            : reminderRecurrence;

  final String id;
  final TimelineItemType type;
  final String text;
  final DateTime createdAt;

  /// Null means this item is a tracked subject/root item.
  /// A non-null value identifies the tracked subject this follow-up belongs to.
  final String? parentId;

  final DateTime? occurredAt;
  final DateTime? reminderAt;
  final TimelineReminderRecurrence reminderRecurrence;

  bool get isTrackedSubject => parentId == null;

  bool get isFollowUp => parentId != null;

  DateTime get timelineAt => occurredAt ?? createdAt;
}
