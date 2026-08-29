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
    this.categoryId,
    this.tagIds = const <String>[],
    this.nextActionAt,
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
  final String? description;
  final String? projectId;
  final String? categoryId;
  final List<String> tagIds;
  final DateTime? nextActionAt;
  final String? parentId;
  final DateTime? occurredAt;
  final DateTime? reminderAt;
  final TimelineReminderRecurrence reminderRecurrence;

  bool get isTrackedSubject => parentId == null;
  bool get isFollowUp => parentId != null;
  DateTime get timelineAt => occurredAt ?? createdAt;
}
