import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class FilterTimelineByDateRange {
  const FilterTimelineByDateRange({required this.repository});

  final TimelineRepository repository;

  Future<List<TimelineItem>> filter({
    DateTime? start,
    DateTime? end,
  }) async {
    if (start != null && end != null && !start.isBefore(end)) {
      throw ArgumentError('end must be after start');
    }

    final items = await repository.listNewestFirst();
    final matches = items.where((item) {
      final timelineAt = item.timelineAt;

      if (start != null && timelineAt.isBefore(start)) {
        return false;
      }

      if (end != null && !timelineAt.isBefore(end)) {
        return false;
      }

      return true;
    }).toList(growable: false);

    return List<TimelineItem>.unmodifiable(matches);
  }
}
