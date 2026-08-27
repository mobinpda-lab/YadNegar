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
  required String text,
  required int day,
}) {
  return TimelineItem(
    id: id,
    type: TimelineItemType.note,
    text: text,
    createdAt: DateTime.utc(2026, 8, day, 10),
  );
}

Widget _buildApp(_MemoryTimelineRepository repository) {
  return MaterialApp(
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: TimelineHome(
        quickCapture: QuickCapture(
          repository: repository,
          clock: () => DateTime.utc(2026, 8, 27, 20),
          idGenerator: () => 'new-item',
        ),
        loadTimeline: LoadTimeline(repository: repository),
        searchTimeline: SearchTimeline(repository: repository),
        filterTimelineByDateRange: FilterTimelineByDateRange(
          repository: repository,
        ),
        dateRangePicker: (context, initialRange) async => DateTimeRange(
          start: DateTime.utc(2026, 8, 25),
          end: DateTime.utc(2026, 8, 26),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('date range can be cleared without clearing active search',
      (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'inside-match',
        text: 'جلسه پروژه داخل بازه',
        day: 25,
      ),
      _item(
        id: 'outside-match',
        text: 'جلسه پروژه بیرون بازه',
        day: 27,
      ),
      _item(
        id: 'inside-other',
        text: 'خرید شیر داخل بازه',
        day: 26,
      ),
    ]);

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('timeline-search-input')),
      'جلسه',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-inside-match')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-outside-match')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-inside-other')), findsNothing);

    await tester.tap(find.byKey(const Key('timeline-date-filter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-inside-match')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-outside-match')), findsNothing);
    expect(find.byKey(const Key('timeline-date-filter-clear')), findsOneWidget);
    expect(find.text('2026/08/25 تا 2026/08/26'), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-date-filter-clear')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-inside-match')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-outside-match')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-inside-other')), findsNothing);
    expect(find.byKey(const Key('timeline-date-filter-clear')), findsNothing);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('timeline-search-input')))
          .controller!
          .text,
      'جلسه',
    );
  });
}
