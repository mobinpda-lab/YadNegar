import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  testWidgets('renders a distinct icon for each Timeline item type', (tester) async {
    final items = <TimelineItem>[
      TimelineItem(
        id: 'note',
        type: TimelineItemType.note,
        text: 'یادداشت',
        createdAt: DateTime(2026, 8, 27, 9),
      ),
      TimelineItem(
        id: 'event',
        type: TimelineItemType.event,
        text: 'رویداد',
        createdAt: DateTime(2026, 8, 27, 10),
      ),
      TimelineItem(
        id: 'call',
        type: TimelineItemType.call,
        text: 'تماس',
        createdAt: DateTime(2026, 8, 27, 11),
      ),
      TimelineItem(
        id: 'idea',
        type: TimelineItemType.idea,
        text: 'ایده',
        createdAt: DateTime(2026, 8, 27, 12),
      ),
      TimelineItem(
        id: 'activity',
        type: TimelineItemType.activity,
        text: 'فعالیت',
        createdAt: DateTime(2026, 8, 27, 13),
      ),
    ];

    await tester.pumpWidget(MaterialApp(home: TimelineScreen(items: items)));

    final expected = <String, IconData>{
      'note': Icons.note_outlined,
      'event': Icons.event_outlined,
      'call': Icons.call_outlined,
      'idea': Icons.lightbulb_outline,
      'activity': Icons.check_circle_outline,
    };

    for (final entry in expected.entries) {
      final finder = find.byKey(Key('timeline-type-icon-${entry.key}'));
      expect(finder, findsOneWidget);
      expect(tester.widget<Icon>(finder).icon, entry.value);
    }

    expect(find.text('یادداشت'), findsWidgets);
    expect(find.text('رویداد'), findsWidgets);
    expect(find.text('تماس'), findsWidgets);
    expect(find.text('ایده'), findsWidgets);
    expect(find.text('فعالیت'), findsWidgets);
  });
}
