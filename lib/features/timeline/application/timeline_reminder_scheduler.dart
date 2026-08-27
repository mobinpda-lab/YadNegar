import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

enum TimelineReminderScheduleResult {
  scheduled,
  permissionDenied,
  skippedPast,
}

abstract interface class TimelineReminderScheduler {
  Future<TimelineReminderScheduleResult> schedule(TimelineItem item);

  Future<void> cancel(String timelineItemId);

  Future<void> reconcile(Iterable<TimelineItem> items);
}
