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
    this.description,
    this.projectId,
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

  /// Optional multi-line description/summary for every tracked task root.
  /// A tracked task may have FollowUps or no FollowUps; the description remains
  /// a property of the task itself. Follow-up records continue to use [text].
  final String? description;

  /// Optional Project membership for tracked task roots.
  /// FollowUps do not own project membership and inherit context from parent.
  final String? projectId;

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
