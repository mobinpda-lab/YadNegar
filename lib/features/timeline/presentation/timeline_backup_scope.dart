import 'package:flutter/widgets.dart';

typedef TimelineBackupAction = Future<void> Function();
typedef TimelineEncryptedBackupAction = Future<bool> Function(BuildContext context);

class TimelineBackupScope extends InheritedWidget {
  const TimelineBackupScope({
    super.key,
    required this.backupAction,
    this.encryptedBackupAction,
    this.encryptedRestoreAction,
    required super.child,
  });

  final TimelineBackupAction backupAction;
  final TimelineEncryptedBackupAction? encryptedBackupAction;
  final TimelineEncryptedBackupAction? encryptedRestoreAction;

  static TimelineBackupScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimelineBackupScope>();
  }

  @override
  bool updateShouldNotify(TimelineBackupScope oldWidget) {
    return backupAction != oldWidget.backupAction ||
        encryptedBackupAction != oldWidget.encryptedBackupAction ||
        encryptedRestoreAction != oldWidget.encryptedRestoreAction;
  }
}
