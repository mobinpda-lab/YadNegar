import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class LoadTimeline {
  const LoadTimeline({required this.repository});

  final TimelineRepository repository;

  Future<List<TimelineItem>> load({int? limit}) async {
    if (limit != null && limit <= 0) {
      throw ArgumentError.value(
        limit,
        'limit',
        'Timeline limit must be greater than zero.',
      );
    }

    final items = await repository.listNewestFirst();
    final visibleItems = limit == null
        ? items
        : items.take(limit).toList(growable: false);

    return List<TimelineItem>.unmodifiable(visibleItems);
  }
}
