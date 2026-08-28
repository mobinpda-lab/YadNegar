import 'package:flutter/widgets.dart';
import 'package:yadnegar/features/timeline/application/manage_projects.dart';

class ProjectScope extends InheritedWidget {
  const ProjectScope({
    super.key,
    required this.manageProjects,
    required super.child,
  });

  final ManageProjects manageProjects;

  static ProjectScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProjectScope>();
  }

  static ProjectScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'ProjectScope is missing above this context.');
    return scope!;
  }

  @override
  bool updateShouldNotify(ProjectScope oldWidget) =>
      manageProjects != oldWidget.manageProjects;
}
