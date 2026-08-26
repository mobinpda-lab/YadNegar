import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  testWidgets('Timeline cards distinguish occurredAt from createdAt',
      (tester) async {
    final event = TimelineItem(
      id: 'event-1',
      type: TimelineItemType.event,
      text: 'جلسه پروژه',
      createdAt: DateTime.utc(2026, 8, 26, 18, 45),
      occurredAt: DateTime.utc(2026, 8, 28, 9, 30),
    );
    final note = TimelineItem(
      id: 'note-1',
      type: TimelineItemType.note,
      text: 'یادداشت سریع',
      createdAt: DateTime.utc(2026, 8, 26, 7, 5),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineScreen(items: [event, note]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('timeline-time-event-1')),
      findsOneWidget,
    );
    expect(
      find.text('زمان رخداد: 2026/08/28 - 09:30'),
      findsOneWidget,
    );

    expect(
      find.byKey(const Key('timeline-time-note-1')),
      findsOneWidget,
    );
    expect(
      find.text('زمان ثبت: 2026/08/26 - 07:05'),
      findsOneWidget,
    );
  });
}
