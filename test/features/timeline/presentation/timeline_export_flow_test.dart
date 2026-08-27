import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  testWidgets('copies exactly the visible Timeline items', (tester) async {
    String? copiedText;
    final visibleItems = <TimelineItem>[
      TimelineItem(
        id: 'visible-event',
        type: TimelineItemType.event,
        text: 'جلسه فیلترشده',
        createdAt: DateTime.utc(2026, 8, 27, 9),
        occurredAt: DateTime.utc(2026, 8, 27, 10, 30),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(
          items: visibleItems,
          clipboardWriter: (text) async {
            copiedText = text;
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('timeline-export-action')));
    await tester.pumpAndSettle();

    expect(copiedText, isNotNull);
    expect(copiedText, contains('متن: جلسه فیلترشده'));
    expect(copiedText, contains('نوع: رویداد'));
    expect(copiedText, contains('زمان رخداد: 2026/08/27 - 10:30'));
    expect(find.text('خروجی Timeline کپی شد.'), findsOneWidget);
  });

  testWidgets('empty visible Timeline does not write clipboard', (tester) async {
    var writeCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(
          clipboardWriter: (text) async {
            writeCount++;
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('timeline-export-action')));
    await tester.pumpAndSettle();

    expect(writeCount, 0);
    expect(find.text('موردی برای کپی وجود ندارد.'), findsOneWidget);
  });

  testWidgets('clipboard failure reports an error without changing items', (
    tester,
  ) async {
    final item = TimelineItem(
      id: 'note-1',
      type: TimelineItemType.note,
      text: 'یادداشت باقی می‌ماند',
      createdAt: DateTime.utc(2026, 8, 27, 8),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineScreen(
          items: <TimelineItem>[item],
          clipboardWriter: (text) async {
            throw StateError('clipboard failed');
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('timeline-export-action')));
    await tester.pumpAndSettle();

    expect(find.text('کپی خروجی انجام نشد.'), findsOneWidget);
    expect(find.text('یادداشت باقی می‌ماند'), findsOneWidget);
  });
}
