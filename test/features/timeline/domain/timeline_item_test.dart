import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  group('TimelineItem', () {
    test('uses createdAt when occurredAt is absent', () {
      final createdAt = DateTime(2026, 8, 26, 12, 30);
      final item = TimelineItem(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'یادداشت روزانه',
        createdAt: createdAt,
      );

      expect(item.timelineAt, createdAt);
    });

    test('uses occurredAt as the effective timeline time when present', () {
      final createdAt = DateTime(2026, 8, 26, 12, 30);
      final occurredAt = DateTime(2026, 8, 25, 9);
      final item = TimelineItem(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'رویداد',
        createdAt: createdAt,
        occurredAt: occurredAt,
      );

      expect(item.timelineAt, occurredAt);
    });

    test('supports the initial shared timeline item types', () {
      expect(
        TimelineItemType.values,
        containsAll(<TimelineItemType>[
          TimelineItemType.note,
          TimelineItemType.event,
          TimelineItemType.call,
          TimelineItemType.idea,
          TimelineItemType.activity,
        ]),
      );
    });
  });
}
