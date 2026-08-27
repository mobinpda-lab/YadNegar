import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

TimelineItem _item({
  required String id,
  DateTime? reminderAt,
  TimelineReminderRecurrence reminderRecurrence = TimelineReminderRecurrence.none,
}) {
  return TimelineItem(
    id: id,
    type: TimelineItemType.note,
    text: 'نمونه یادنگار',
    createdAt: DateTime(2026, 8, 27, 8, 15),
    reminderAt: reminderAt,
    reminderRecurrence: reminderRecurrence,
  );
}

Future<void> _pumpTimeline(WidgetTester tester, TimelineItem item) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: TimelineScreen(items: <TimelineItem>[item]),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('item without reminder keeps existing card content only', (tester) async {
    await _pumpTimeline(tester, _item(id: 'none'));

    expect(find.byKey(const Key('timeline-reminder-none')), findsNothing);
    expect(find.text('یادداشت'), findsOneWidget);
    expect(find.text('زمان ثبت: 2026/08/27 - 08:15'), findsOneWidget);
  });

  testWidgets('one-shot reminder shows its date and time', (tester) async {
    await _pumpTimeline(
      tester,
      _item(
        id: 'one-shot',
        reminderAt: DateTime(2026, 8, 28, 9, 30),
      ),
    );

    expect(
      find.byKey(const Key('timeline-reminder-one-shot')),
      findsOneWidget,
    );
    expect(find.text('یادآور: 2026/08/28 - 09:30'), findsOneWidget);
  });

  testWidgets('daily reminder shows recurrence and local clock time', (tester) async {
    await _pumpTimeline(
      tester,
      _item(
        id: 'daily',
        reminderAt: DateTime(2026, 8, 28, 10, 5),
        reminderRecurrence: TimelineReminderRecurrence.daily,
      ),
    );

    expect(find.text('یادآور: روزانه - 10:05'), findsOneWidget);
  });

  testWidgets('weekly reminder shows Persian weekday and clock time', (tester) async {
    await _pumpTimeline(
      tester,
      _item(
        id: 'weekly',
        reminderAt: DateTime(2026, 8, 28, 18, 45),
        reminderRecurrence: TimelineReminderRecurrence.weekly,
      ),
    );

    expect(find.text('یادآور: هفتگی - جمعه - 18:45'), findsOneWidget);
    expect(find.text('زمان ثبت: 2026/08/27 - 08:15'), findsOneWidget);
  });
}
