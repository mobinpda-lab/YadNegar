import 'package:yadnegar/features/timeline/domain/project_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';

typedef ProjectIdGenerator = String Function();

class ProjectNotEmptyException implements Exception {
  const ProjectNotEmptyException(this.projectId);
  final String projectId;

  @override
  String toString() => 'Project $projectId contains tracked tasks.';
}

class ManageProjects {
  const ManageProjects({
    required this.projectRepository,
    required this.timelineRepository,
    required this.idGenerator,
  });

  final ProjectRepository projectRepository;
  final TimelineRepository timelineRepository;
  final ProjectIdGenerator idGenerator;

  Future<List<YadNegarProject>> list() => projectRepository.listProjects();

  Future<YadNegarProject> create({
    required String title,
    required int colorValue,
  }) async {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Project title cannot be empty.');
    }
    final id = idGenerator().trim();
    if (id.isEmpty) {
      throw StateError('Project id generator returned an empty id.');
    }
    final project = YadNegarProject(
      id: id,
      title: normalizedTitle,
      colorValue: colorValue,
    );
    await projectRepository.upsertProject(project);
    return project;
  }

  Future<YadNegarProject> update({
    required YadNegarProject project,
    required String title,
    required int colorValue,
  }) async {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Project title cannot be empty.');
    }
    final updated = project.copyWith(
      title: normalizedTitle,
      colorValue: colorValue,
    );
    await projectRepository.upsertProject(updated);
    return updated;
  }

  Future<void> delete(String projectId) async {
    final normalizedId = projectId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(projectId, 'projectId', 'Project id cannot be empty.');
    }
    final items = await timelineRepository.listNewestFirst();
    final hasTask = items.any(
      (item) => item.isTrackedSubject && item.projectId == normalizedId,
    );
    if (hasTask) {
      throw ProjectNotEmptyException(normalizedId);
    }
    await projectRepository.deleteProjectById(normalizedId);
  }
}
