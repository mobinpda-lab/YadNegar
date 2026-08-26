import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

void main() {
  testWidgets('delete requires confirmation and removes item after confirmation', (
    tester,
  ) async {
    final createdAt = DateTime(2026, 8, 27, 8);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'delete-me',
        type: TimelineItemType.note,
        text: 'برای حذف',
        createdAt: createdAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => createdAt,
              idGenerator: () => 'capture-unused',
            ),
            loadTimeline: LoadTimeline(repository: repository),
            editTimelineItem: EditTimelineItem(repository: repository),
            deleteTimelineItem: DeleteTimelineItem(repository: repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-delete-me')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();

    expect(find.text('حذف این مورد؟'), findsOneWidget);
    expect(await repository.findById('delete-me'), isNotNull);

    await tester.tap(find.byKey(const Key('timeline-delete-confirm')));
    await tester.pumpAndSettle();

    expect(await repository.findById('delete-me'), isNull);
    expect(find.text('برای حذف'), findsNothing);
    expect(find.byKey(const Key('timeline-empty-state')), findsOneWidget);
    expect(find.text('مورد حذف شد.'), findsOneWidget);
  });

  testWidgets('cancelling delete keeps the item', (tester) async {
    final createdAt = DateTime(2026, 8, 27, 8);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'keep-me',
        type: TimelineItemType.idea,
        text: 'باقی بماند',
        createdAt: createdAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => createdAt,
            idGenerator: () => 'capture-unused',
          ),
          loadTimeline: LoadTimeline(repository: repository),
          editTimelineItem: EditTimelineItem(repository: repository),
          deleteTimelineItem: DeleteTimelineItem(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-keep-me')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('انصراف').last);
    await tester.pumpAndSettle();

    expect(await repository.findById('keep-me'), isNotNull);
    expect(find.text('باقی بماند'), findsWidgets);
  });

  testWidgets('deletion reload preserves text type and date filters', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 27, 8);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'filtered-delete',
        type: TimelineItemType.event,
        text: 'جلسه حذف',
        createdAt: createdAt,
      ),
    );
    await repository.upsert(
      TimelineItem(
        id: 'outside-range',
        type: TimelineItemType.event,
        text: 'جلسه خارج بازه',
        createdAt: DateTime.utc(2026, 8, 29, 9),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => createdAt,
              idGenerator: () => 'capture-unused',
            ),
            loadTimeline: LoadTimeline(repository: repository),
            editTimelineItem: EditTimelineItem(repository: repository),
            deleteTimelineItem: DeleteTimelineItem(repository: repository),
            searchTimeline: SearchTimeline(repository: repository),
            filterTimelineByDateRange: FilterTimelineByDateRange(
              repository: repository,
            ),
            dateRangePicker: (context, initialRange) async => DateTimeRange(
              start: DateTime.utc(2026, 8, 27),
              end: DateTime.utc(2026, 8, 27),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('timeline-search-input')),
      'جلسه',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-type-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('رویداد').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-date-filter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-filtered-delete')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-outside-range')), findsNothing);

    await tester.tap(find.byKey(const Key('timeline-item-filtered-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-delete-confirm')));
    await tester.pumpAndSettle();

    expect(await repository.findById('filtered-delete'), isNull);
    expect(await repository.findById('outside-range'), isNotNull);
    expect(find.byKey(const Key('timeline-search-empty-state')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-outside-range')), findsNothing);
    expect(find.text('2026/08/27 تا 2026/08/27'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('timeline-search-input')))
          .controller!
          .text,
      'جلسه',
    );
    expect(
      tester
          .widget<DropdownButton<TimelineItemType>>(
            find.byKey(const Key('timeline-type-filter')),
          )
          .value,
      TimelineItemType.event,
    );
  });
}

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(TimelineItem seed) : _items = {seed.id: seed};

  final Map<String, TimelineItem> _items;

  @override
  Future<bool> deleteById(String id) async => _items.remove(id) != null;

  @override
  Future<TimelineItem?> findById(String id) async => _items[id];

  @override
  Future<List<TimelineItem>> listNewestFirst() async {
    final items = _items.values.toList();
    items.sort((left, right) => right.timelineAt.compareTo(left.timelineAt));
    return items;
  }

  @override
  Future<void> upsert(TimelineItem item) async {
    _items[item.id] = item;
  }
}
