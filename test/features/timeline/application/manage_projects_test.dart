import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/manage_projects.dart';
import 'package:yadnegar/features/timeline/domain/project_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';

void main() {
  test('project can contain tasks with or without follow-ups', () async {
    final repository = _MemoryRepository();
    final manage = ManageProjects(
      projectRepository: repository,
      timelineRepository: repository,
      idGenerator: () => 'project-1',
    );

    final project = await manage.create(title: 'پروژه خانه', colorValue: 0xFF3176D5);
    repository.items.addAll(<TimelineItem>[
      _task('task-with', projectId: project.id),
      _followUp('follow-1', parentId: 'task-with'),
      _task('task-without', projectId: project.id),
    ]);

    expect(repository.items.where((item) => item.projectId == project.id), hasLength(2));
    expect(repository.items.where((item) => item.isFollowUp), hasLength(1));
  });

  test('non-empty project cannot be deleted', () async {
    final repository = _MemoryRepository();
    final project = const YadNegarProject(
      id: 'project-1',
      title: 'پروژه',
      colorValue: 0xFF5B4BDB,
    );
    repository.projects.add(project);
    repository.items.add(_task('task-1', projectId: project.id));
    final manage = ManageProjects(
      projectRepository: repository,
      timelineRepository: repository,
      idGenerator: () => 'unused',
    );

    expect(
      () => manage.delete(project.id),
      throwsA(isA<ProjectNotEmptyException>()),
    );
    expect(repository.projects.single.id, project.id);
  });

  test('empty project can be deleted', () async {
    final repository = _MemoryRepository();
    repository.projects.add(
      const YadNegarProject(
        id: 'project-1',
        title: 'پروژه',
        colorValue: 0xFF25A55A,
      ),
    );
    final manage = ManageProjects(
      projectRepository: repository,
      timelineRepository: repository,
      idGenerator: () => 'unused',
    );

    await manage.delete('project-1');
    expect(repository.projects, isEmpty);
  });
}

TimelineItem _task(String id, {String? projectId}) => TimelineItem(
      id: id,
      type: TimelineItemType.activity,
      text: id,
      description: 'شرح کار',
      projectId: projectId,
      createdAt: DateTime(2026, 8, 28, 12),
    );

TimelineItem _followUp(String id, {required String parentId}) => TimelineItem(
      id: id,
      type: TimelineItemType.activity,
      text: 'پیگیری',
      parentId: parentId,
      createdAt: DateTime(2026, 8, 28, 13),
    );

class _MemoryRepository implements TimelineRepository, ProjectRepository {
  final List<TimelineItem> items = <TimelineItem>[];
  final List<YadNegarProject> projects = <YadNegarProject>[];

  @override
  Future<bool> deleteById(String id) async => items.removeWhere((item) => item.id == id) > 0;

  @override
  Future<TimelineItem?> findById(String id) async {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async => List<TimelineItem>.of(items);

  @override
  Future<void> upsert(TimelineItem item) async {
    items.removeWhere((candidate) => candidate.id == item.id);
    items.add(item);
  }

  @override
  Future<bool> deleteProjectById(String id) async {
    final before = projects.length;
    projects.removeWhere((project) => project.id == id);
    return projects.length != before;
  }

  @override
  Future<YadNegarProject?> findProjectById(String id) async {
    for (final project in projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  @override
  Future<List<YadNegarProject>> listProjects() async => List<YadNegarProject>.of(projects);

  @override
  Future<void> upsertProject(YadNegarProject project) async {
    projects.removeWhere((candidate) => candidate.id == project.id);
    projects.add(project);
  }
}
