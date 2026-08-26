import 'timeline_item.dart';

abstract interface class TimelineRepository {
  Future<void> upsert(TimelineItem item);

  Future<TimelineItem?> findById(String id);

  Future<List<TimelineItem>> listNewestFirst();
}
