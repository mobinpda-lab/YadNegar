import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  testWidgets('global clear action is visibly labeled when filters are active',
      (tester) async {
    var cleared = false;
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineScreen(
            searchController: controller,
            onSearchChanged: (_) {},
            hasActiveSearch: true,
            onClearSearch: () => cleared = true,
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('timeline-search-clear')), findsOneWidget);
    expect(find.text('پاک کردن همه'), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-search-clear')));
    await tester.pump();

    expect(cleared, isTrue);
  });

  testWidgets('global clear action stays hidden without active filters',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineScreen(
            searchController: controller,
            onSearchChanged: (_) {},
            onClearSearch: () {},
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('timeline-search-clear')), findsNothing);
    expect(find.text('پاک کردن همه'), findsNothing);
  });
}
