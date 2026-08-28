import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tracked-task Home backup action uses backup semantics', () async {
    final source = await File(
      'lib/features/timeline/presentation/tracked_subject_home.dart',
    ).readAsString();

    expect(source, contains("key: const Key('tracked-subject-backup')"));
    expect(source, contains("tooltip: 'پشتیبان‌گیری'"));
    expect(source, contains('onPressed: _runBackup'));
    expect(
      source,
      contains('icon: const Icon(Icons.backup_outlined, color: _primary)'),
    );
    expect(source, isNot(contains('Icons.notifications_none_rounded')));
  });
}
