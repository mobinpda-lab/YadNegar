import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  testWidgets('home header shows Bismillah above the YadNegar title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineScreen(),
        ),
      ),
    );

    final bismillah = find.byKey(const Key('home-bismillah'));
    final title = find.text('یادنگار');

    expect(bismillah, findsOneWidget);
    expect(find.text('بسم الله الرحمن الرحیم'), findsOneWidget);
    expect(title, findsOneWidget);
    expect(tester.getCenter(bismillah).dy, lessThan(tester.getCenter(title).dy));
  });
}
