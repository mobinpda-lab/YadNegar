import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/main.dart';

void main() {
  testWidgets('YadNegar starts with Persian RTL shell', (tester) async {
    await tester.pumpWidget(const YadNegarApp());

    final title = find.text('یادنگار');
    expect(title, findsOneWidget);
    expect(
      Directionality.of(tester.element(title)),
      TextDirection.rtl,
    );
  });
}
