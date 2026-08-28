import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class LoadTimelineFollowUps {
  const LoadTimelineFollowUps({required this.repository});

  final TimelineRepository repository;

  Future<List<TimelineItem>> load(String subjectId) async {
    final items = await repository.listNewestFirst();
    return List<TimelineItem>.unmodifiable(
      items.where((item) => item.parentId == subjectId),
    );
  }
}
