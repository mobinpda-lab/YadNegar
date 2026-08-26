import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class RestoreTimelineItem {
  const RestoreTimelineItem({required this.repository});

  final TimelineRepository repository;

  Future<bool> restore(TimelineItem item) async {
    if (item.id.trim().isEmpty) {
      throw ArgumentError.value(item.id, 'item.id', 'Timeline item id cannot be empty.');
    }

    final existing = await repository.findById(item.id);
    if (existing != null) {
      return false;
    }

    await repository.upsert(item);
    return true;
  }
}
