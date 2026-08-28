import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';

abstract class ProjectRepository {
  Future<List<YadNegarProject>> listProjects();
  Future<YadNegarProject?> findProjectById(String id);
  Future<void> upsertProject(YadNegarProject project);
  Future<bool> deleteProjectById(String id);
}
