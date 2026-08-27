import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_backup_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  testWidgets('backup action invokes scoped handler and reports readiness', (
    tester,
  ) async {
    var calls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineBackupScope(
          backupAction: () async => calls++,
          child: const TimelineScreen(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('timeline-backup-action')));
    await tester.pumpAndSettle();

    expect(calls, 1);
    expect(find.text('فایل پشتیبان برای اشتراک‌گذاری آماده شد.'), findsOneWidget);
  });

  testWidgets('backup action reports failure without changing screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TimelineBackupScope(
          backupAction: () async => throw StateError('share failed'),
          child: const TimelineScreen(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('timeline-backup-action')));
    await tester.pumpAndSettle();

    expect(find.text('پشتیبان‌گیری انجام نشد.'), findsOneWidget);
    expect(find.byKey(const Key('timeline-empty-state')), findsOneWidget);
  });

  testWidgets('backup action is hidden when no backup scope is configured', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TimelineScreen()));

    expect(find.byKey(const Key('timeline-backup-action')), findsNothing);
    expect(find.byKey(const Key('timeline-export-action')), findsOneWidget);
  });
}
