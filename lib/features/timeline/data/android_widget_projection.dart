import 'package:flutter/services.dart';
import 'package:yadnegar/features/timeline/domain/project_repository.dart';
import 'package:yadnegar/features/timeline/domain/taxonomy_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class AndroidWidgetProjection {
  const AndroidWidgetProjection({
    required this.timelineRepository,
    required this.projectRepository,
    required this.taxonomyRepository,
  });

  static const MethodChannel _channel = MethodChannel(
    'com.mobinpda.lab.yadnegar/widget',
  );

  final TimelineRepository timelineRepository;
  final ProjectRepository projectRepository;
  final TaxonomyRepository taxonomyRepository;

  Future<void> refresh() async {
    final items = await timelineRepository.listNewestFirst();
    final projects = await projectRepository.listProjects();
    final categories = await taxonomyRepository.listCategories();
    final tags = await taxonomyRepository.listTags();

    final rootTasks = items
        .where((item) => item.isTrackedSubject)
        .map<Map<String, Object?>>(
          (item) => <String, Object?>{
            'id': item.id,
            'text': item.text,
            'createdAt': item.createdAt.toIso8601String(),
            'timelineAt': item.timelineAt.toIso8601String(),
            'nextActionAt': item.nextActionAt?.toIso8601String(),
            'projectId': item.projectId,
            'categoryId': item.categoryId,
            'tagIds': item.tagIds,
          },
        )
        .toList(growable: false);

    await _channel.invokeMethod<void>('writeProjection', <String, Object?>{
      'items': rootTasks,
      'projects': projects
          .map((value) => <String, Object?>{'id': value.id, 'title': value.title})
          .toList(growable: false),
      'categories': categories
          .map((value) => <String, Object?>{'id': value.id, 'title': value.title})
          .toList(growable: false),
      'tags': tags
          .map((value) => <String, Object?>{'id': value.id, 'title': value.title})
          .toList(growable: false),
    });
  }
}
