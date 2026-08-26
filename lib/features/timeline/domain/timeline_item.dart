enum TimelineItemType {
  note,
  event,
  call,
  idea,
  activity,
}

class TimelineItem {
  const TimelineItem({
    required this.id,
    required this.type,
    required this.text,
    required this.createdAt,
    this.occurredAt,
  });

  final String id;
  final TimelineItemType type;
  final String text;
  final DateTime createdAt;
  final DateTime? occurredAt;

  DateTime get timelineAt => occurredAt ?? createdAt;
}
