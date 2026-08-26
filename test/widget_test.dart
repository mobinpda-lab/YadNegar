import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/main.dart';

void main() {
  testWidgets('YadNegar starts with RTL timeline empty state', (tester) async {
    await tester.pumpWidget(const YadNegarApp());

    final emptyState = find.text('هنوز چیزی ثبت نشده');
    expect(find.text('یادنگار'), findsOneWidget);
    expect(emptyState, findsOneWidget);
    expect(find.text('ثبت سریع'), findsOneWidget);
    expect(
      Directionality.of(tester.element(emptyState)),
      TextDirection.rtl,
    );

    final quickCapture = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(quickCapture.onPressed, isNull);
  });
}
