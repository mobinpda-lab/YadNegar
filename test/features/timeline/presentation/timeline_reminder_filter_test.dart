import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  final withReminder = TimelineItem(
    id: 'with-reminder',
    type: TimelineItemType.note,
    text: 'دارای یادآور',
    createdAt: DateTime(2026, 8, 27, 10),
    reminderAt: DateTime(2026, 8, 28, 9),
  );
  final withoutReminder = TimelineItem(
    id: 'without-reminder',
    type: TimelineItemType.idea,
    text: 'بدون یادآور',
    createdAt: DateTime(2026, 8, 27, 11),
  );

  testWidgets('filters Timeline to items with reminders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(items: [withReminder, withoutReminder]),
      ),
    );

    await _selectReminderFilter(tester, 'دارای یادآور');

    expect(find.byKey(const Key('timeline-item-with-reminder')), findsOneWidget);
    expect(
      find.byKey(const Key('timeline-item-without-reminder')),
      findsNothing,
    );
  });

  testWidgets('filters Timeline to items without reminders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(items: [withReminder, withoutReminder]),
      ),
    );

    await _selectReminderFilter(tester, 'بدون یادآور');

    expect(find.byKey(const Key('timeline-item-with-reminder')), findsNothing);
    expect(
      find.byKey(const Key('timeline-item-without-reminder')),
      findsOneWidget,
    );
  });

  testWidgets('composes with items already narrowed by existing filters',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(
          items: [withReminder, withoutReminder],
          searchController: controller,
          onSearchChanged: (_) {},
        ),
      ),
    );

    await _selectReminderFilter(tester, 'دارای یادآور');

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(
          items: [withoutReminder],
          searchController: controller,
          hasActiveSearch: true,
          onSearchChanged: (_) {},
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('timeline-search-empty-state')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-without-reminder')), findsNothing);
  });

  testWidgets('clear action resets reminder filter with existing filters',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var parentClearCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(
          items: [withReminder, withoutReminder],
          searchController: controller,
          onSearchChanged: (_) {},
          onClearSearch: () => parentClearCalled = true,
        ),
      ),
    );

    await _selectReminderFilter(tester, 'دارای یادآور');
    expect(find.byKey(const Key('timeline-search-clear')), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-search-clear')));
    await tester.pump();

    expect(parentClearCalled, isTrue);
    expect(find.byKey(const Key('timeline-item-with-reminder')), findsOneWidget);
    expect(
      find.byKey(const Key('timeline-item-without-reminder')),
      findsOneWidget,
    );
  });
}

Future<void> _selectReminderFilter(
  WidgetTester tester,
  String label,
) async {
  await tester.tap(find.byKey(const Key('timeline-reminder-filter')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}
