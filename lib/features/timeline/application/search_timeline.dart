import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class SearchTimeline {
  const SearchTimeline({required this.repository});

  final TimelineRepository repository;

  Future<List<TimelineItem>> search({
    String query = '',
    TimelineItemType? type,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    final items = await repository.listNewestFirst();

    final matches = items.where((item) {
      if (type != null && item.type != type) {
        return false;
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      return item.text.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);

    return List<TimelineItem>.unmodifiable(matches);
  }
}
