import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

enum TrackedSubjectNextActionBucket {
  today,
  overdue,
  upcoming,
  noNextAction,
}

class ClassifyTrackedSubjectNextAction {
  const ClassifyTrackedSubjectNextAction();

  TrackedSubjectNextActionBucket call({
    required TimelineItem subject,
    required DateTime now,
  }) {
    if (!subject.isTrackedSubject) {
      throw ArgumentError.value(
        subject.id,
        'subject',
        'Next-action buckets can only classify tracked task roots.',
      );
    }

    final nextActionAt = subject.nextActionAt;
    if (nextActionAt == null) {
      return TrackedSubjectNextActionBucket.noNextAction;
    }

    final today = DateTime(now.year, now.month, now.day);
    final actionDay = DateTime(
      nextActionAt.year,
      nextActionAt.month,
      nextActionAt.day,
    );

    if (actionDay.isBefore(today)) {
      return TrackedSubjectNextActionBucket.overdue;
    }
    if (actionDay.isAfter(today)) {
      return TrackedSubjectNextActionBucket.upcoming;
    }
    return TrackedSubjectNextActionBucket.today;
  }
}
