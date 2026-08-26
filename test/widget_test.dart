import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/main.dart';

void main() {
  testWidgets('YadNegar starts with RTL timeline empty state', (tester) async {
    await tester.pumpWidget(const YadNegarApp());

    final emptyState = find.byKey(const Key('timeline-empty-state'));
    final quickCaptureAction = find.byKey(const Key('quick-capture-action'));

    expect(find.text('یادنگار'), findsOneWidget);
    expect(emptyState, findsOneWidget);
    expect(find.byIcon(Icons.timeline), findsOneWidget);
    expect(find.text('ثبت سریع'), findsOneWidget);
    expect(find.byTooltip('ثبت سریع'), findsOneWidget);
    expect(quickCaptureAction, findsOneWidget);
    expect(
      Directionality.of(tester.element(emptyState)),
      TextDirection.rtl,
    );

    final quickCapture = tester.widget<FloatingActionButton>(
      quickCaptureAction,
    );
    expect(quickCapture.onPressed, isNull);
  });
}
