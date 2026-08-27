import 'package:flutter/widgets.dart';

typedef TimelineBackupAction = Future<void> Function();

class TimelineBackupScope extends InheritedWidget {
  const TimelineBackupScope({
    super.key,
    required this.backupAction,
    required super.child,
  });

  final TimelineBackupAction backupAction;

  static TimelineBackupScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimelineBackupScope>();
  }

  @override
  bool updateShouldNotify(TimelineBackupScope oldWidget) {
    return backupAction != oldWidget.backupAction;
  }
}
