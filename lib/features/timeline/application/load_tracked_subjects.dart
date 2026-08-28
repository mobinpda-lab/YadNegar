import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class TrackedSubjectHomeData {
  TrackedSubjectHomeData({
    required List<TimelineItem> subjects,
    required Map<String, List<TimelineItem>> followUpsBySubject,
  })  : subjects = List<TimelineItem>.unmodifiable(subjects),
        followUpsBySubject = Map<String, List<TimelineItem>>.unmodifiable(
          followUpsBySubject.map(
            (key, value) => MapEntry(
              key,
              List<TimelineItem>.unmodifiable(value),
            ),
          ),
        );

  final List<TimelineItem> subjects;
  final Map<String, List<TimelineItem>> followUpsBySubject;
}

class LoadTrackedSubjects {
  const LoadTrackedSubjects({required this.repository});

  final TimelineRepository repository;

  Future<List<TimelineItem>> load() async {
    final items = await repository.listNewestFirst();
    return List<TimelineItem>.unmodifiable(
      items.where((item) => item.isTrackedSubject),
    );
  }

  Future<TrackedSubjectHomeData> loadHomeData() async {
    final items = await repository.listNewestFirst();
    final subjects = items
        .where((item) => item.isTrackedSubject)
        .toList(growable: false);
    final followUpsBySubject = <String, List<TimelineItem>>{
      for (final subject in subjects) subject.id: <TimelineItem>[],
    };

    for (final item in items) {
      final parentId = item.parentId;
      if (parentId == null) {
        continue;
      }
      followUpsBySubject[parentId]?.add(item);
    }

    return TrackedSubjectHomeData(
      subjects: subjects,
      followUpsBySubject: followUpsBySubject,
    );
  }
}
