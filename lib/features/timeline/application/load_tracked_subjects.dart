import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class LoadTrackedSubjects {
  const LoadTrackedSubjects({required this.repository});

  final TimelineRepository repository;

  Future<List<TimelineItem>> load() async {
    final items = await repository.listNewestFirst();
    return List<TimelineItem>.unmodifiable(
      items.where((item) => item.isTrackedSubject),
    );
  }
}
