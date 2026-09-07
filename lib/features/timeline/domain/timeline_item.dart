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

enum TimelineReminderKind {
  standard,
  medicationConsumption,
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
    this.reminderKind = TimelineReminderKind.standard,
    this.medicationName,
    this.medicationAmount,
    this.medicationUnit,
    this.medicationInterval,
    this.scheduledAt,
    this.actualTakenAt,
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
  final TimelineReminderKind reminderKind;
  final String? medicationName;
  final double? medicationAmount;
  final String? medicationUnit;
  final Duration? medicationInterval;
  final DateTime? scheduledAt;
  final DateTime? actualTakenAt;

  bool get isTrackedSubject => parentId == null;
  bool get isFollowUp => parentId != null;
  bool get isMedicationConsumptionReminder =>
      reminderKind == TimelineReminderKind.medicationConsumption;

  DateTime? get medicationNextDueAt =>
      actualTakenAt != null && medicationInterval != null
          ? actualTakenAt!.add(medicationInterval!)
          : reminderAt;

  DateTime get timelineAt => occurredAt ?? createdAt;
}
