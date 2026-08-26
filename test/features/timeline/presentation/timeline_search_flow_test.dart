import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  final List<TimelineItem> items;

  @override
  Future<bool> deleteById(String id) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return false;
    }
    items.removeAt(index);
    return true;
  }

  @override
  Future<TimelineItem?> findById(String id) async {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async => List.of(items);

  @override
  Future<void> upsert(TimelineItem item) async {
    final index = items.indexWhere((candidate) => candidate.id == item.id);
    if (index == -1) {
      items.insert(0, item);
    } else {
      items[index] = item;
    }
  }
}

TimelineItem _item({
  required String id,
  required TimelineItemType type,
  required String text,
  int day = 26,
  required int hour,
}) {
  return TimelineItem(
    id: id,
    type: type,
    text: text,
    createdAt: DateTime.utc(2026, 8, day, hour),
  );
}

Widget _buildApp(
  _MemoryTimelineRepository repository, {
  TimelineDateRangePicker? dateRangePicker,
}) {
  return MaterialApp(
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: TimelineHome(
        quickCapture: QuickCapture(
          repository: repository,
          clock: () => DateTime.utc(2026, 8, 26, 20),
          idGenerator: () => 'new-item',
        ),
        loadTimeline: LoadTimeline(repository: repository),
        searchTimeline: SearchTimeline(repository: repository),
        filterTimelineByDateRange: FilterTimelineByDateRange(
          repository: repository,
        ),
        dateRangePicker: dateRangePicker,
      ),
    ),
  );
}

TimelineDateRangePicker _pickRange(int startDay, int endDay) {
  return (context, initialRange) async => DateTimeRange(
        start: DateTime.utc(2026, 8, startDay),
        end: DateTime.utc(2026, 8, endDay),
      );
}

void main() {
  testWidgets('search filters Timeline and clear restores all items', (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'جلسه فردا',
        hour: 19,
      ),
      _item(
        id: 'idea-1',
        type: TimelineItemType.idea,
        text: 'ایده سفر شمال',
        hour: 18,
      ),
      _item(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'خرید شیر',
        hour: 17,
      ),
    ]);

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-event-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-idea-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-note-1')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('timeline-search-input')),
      '  سفر  ',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-idea-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-event-1')), findsNothing);
    expect(find.byKey(const Key('timeline-item-note-1')), findsNothing);
    expect(find.byKey(const Key('timeline-search-clear')), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-search-clear')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-event-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-idea-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-note-1')), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('timeline-search-input')))
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets('type filter uses SearchTimeline and can be cleared', (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'جلسه فردا',
        hour: 19,
      ),
      _item(
        id: 'idea-1',
        type: TimelineItemType.idea,
        text: 'ایده سفر شمال',
        hour: 18,
      ),
    ]);

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-type-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('رویداد').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-event-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-idea-1')), findsNothing);
    expect(find.byKey(const Key('timeline-search-clear')), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-search-clear')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-event-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-idea-1')), findsOneWidget);
  });

  testWidgets('search shows a distinct empty result state', (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'خرید شیر',
        hour: 17,
      ),
    ]);

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('timeline-search-input')),
      'چیزی که وجود ندارد',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-search-empty-state')), findsOneWidget);
    expect(find.byKey(const Key('timeline-empty-state')), findsNothing);
  });

  testWidgets('date range filters by day and includes the selected end date',
      (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'day-24',
        type: TimelineItemType.note,
        text: 'روز بیست و چهار',
        day: 24,
        hour: 10,
      ),
      _item(
        id: 'day-25',
        type: TimelineItemType.event,
        text: 'روز بیست و پنج',
        day: 25,
        hour: 11,
      ),
      _item(
        id: 'day-26',
        type: TimelineItemType.idea,
        text: 'روز بیست و شش',
        day: 26,
        hour: 23,
      ),
      _item(
        id: 'day-27',
        type: TimelineItemType.call,
        text: 'روز بیست و هفت',
        day: 27,
        hour: 0,
      ),
    ]);

    await tester.pumpWidget(
      _buildApp(repository, dateRangePicker: _pickRange(25, 26)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-date-filter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-day-24')), findsNothing);
    expect(find.byKey(const Key('timeline-item-day-25')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-day-26')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-day-27')), findsNothing);
    expect(find.text('2026/08/25 تا 2026/08/26'), findsOneWidget);
  });

  testWidgets('date range composes with text search', (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'inside-match',
        type: TimelineItemType.note,
        text: 'جلسه پروژه',
        day: 25,
        hour: 9,
      ),
      _item(
        id: 'inside-other',
        type: TimelineItemType.note,
        text: 'خرید شیر',
        day: 26,
        hour: 9,
      ),
      _item(
        id: 'outside-match',
        type: TimelineItemType.note,
        text: 'جلسه پروژه بیرون بازه',
        day: 27,
        hour: 9,
      ),
    ]);

    await tester.pumpWidget(
      _buildApp(repository, dateRangePicker: _pickRange(25, 26)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-date-filter')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('timeline-search-input')),
      'جلسه',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-inside-match')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-inside-other')), findsNothing);
    expect(find.byKey(const Key('timeline-item-outside-match')), findsNothing);
  });

  testWidgets('date range composes with type filter', (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'inside-event',
        type: TimelineItemType.event,
        text: 'جلسه داخل بازه',
        day: 25,
        hour: 9,
      ),
      _item(
        id: 'inside-note',
        type: TimelineItemType.note,
        text: 'یادداشت داخل بازه',
        day: 26,
        hour: 9,
      ),
      _item(
        id: 'outside-event',
        type: TimelineItemType.event,
        text: 'جلسه بیرون بازه',
        day: 27,
        hour: 9,
      ),
    ]);

    await tester.pumpWidget(
      _buildApp(repository, dateRangePicker: _pickRange(25, 26)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-date-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-type-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('رویداد').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-inside-event')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-inside-note')), findsNothing);
    expect(find.byKey(const Key('timeline-item-outside-event')), findsNothing);
  });

  testWidgets('clear resets date range together with other filters', (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'inside',
        type: TimelineItemType.event,
        text: 'جلسه داخل بازه',
        day: 25,
        hour: 9,
      ),
      _item(
        id: 'outside',
        type: TimelineItemType.note,
        text: 'یادداشت بیرون بازه',
        day: 27,
        hour: 9,
      ),
    ]);

    await tester.pumpWidget(
      _buildApp(repository, dateRangePicker: _pickRange(25, 26)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-date-filter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-inside')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-outside')), findsNothing);
    expect(find.byKey(const Key('timeline-search-clear')), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-search-clear')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-inside')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-outside')), findsOneWidget);
    expect(find.text('فیلتر بازه زمانی'), findsOneWidget);
  });

  testWidgets('date-only empty result uses filtered empty state', (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'only-item',
        type: TimelineItemType.note,
        text: 'فقط روز بیست و چهار',
        day: 24,
        hour: 9,
      ),
    ]);

    await tester.pumpWidget(
      _buildApp(repository, dateRangePicker: _pickRange(25, 26)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-date-filter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-search-empty-state')), findsOneWidget);
    expect(find.byKey(const Key('timeline-empty-state')), findsNothing);
  });
}
