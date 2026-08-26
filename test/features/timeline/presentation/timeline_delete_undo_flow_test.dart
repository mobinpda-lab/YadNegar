import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/restore_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

void main() {
  testWidgets('undo restores deleted item metadata and keeps active filters', (
    tester,
  ) async {
    final original = TimelineItem(
      id: 'event-undo',
      type: TimelineItemType.event,
      text: 'جلسه قابل بازگردانی',
      createdAt: DateTime.utc(2026, 8, 26, 18),
      occurredAt: DateTime.utc(2026, 8, 27, 9, 30),
    );
    final outsideRange = TimelineItem(
      id: 'event-outside',
      type: TimelineItemType.event,
      text: 'جلسه خارج بازه',
      createdAt: DateTime.utc(2026, 8, 29, 10),
    );
    final repository = _MemoryTimelineRepository(<TimelineItem>[
      original,
      outsideRange,
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => DateTime.utc(2026, 8, 27, 12),
              idGenerator: () => 'capture-unused',
            ),
            loadTimeline: LoadTimeline(repository: repository),
            editTimelineItem: EditTimelineItem(repository: repository),
            deleteTimelineItem: DeleteTimelineItem(repository: repository),
            restoreTimelineItem: RestoreTimelineItem(repository: repository),
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

    expect(find.byKey(const Key('timeline-item-event-undo')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-event-outside')), findsNothing);

    await tester.tap(find.byKey(const Key('timeline-item-event-undo')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'این مورد از یادنگار حذف می‌شود. پس از حذف می‌توانید آن را بازگردانید.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('timeline-delete-confirm')));
    await tester.pumpAndSettle();

    expect(await repository.findById(original.id), isNull);
    expect(find.byKey(const Key('timeline-search-empty-state')), findsOneWidget);
    expect(find.text('بازگردانی'), findsOneWidget);

    await tester.tap(find.text('بازگردانی'));
    await tester.pumpAndSettle();

    final restored = await repository.findById(original.id);
    expect(restored, isNotNull);
    expect(restored!.id, original.id);
    expect(restored.type, original.type);
    expect(restored.text, original.text);
    expect(restored.createdAt, original.createdAt);
    expect(restored.occurredAt, original.occurredAt);
    expect(find.byKey(const Key('timeline-item-event-undo')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-event-outside')), findsNothing);
    expect(find.text('مورد بازگردانده شد.'), findsOneWidget);
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
  _MemoryTimelineRepository(List<TimelineItem> items)
      : _items = <String, TimelineItem>{
          for (final item in items) item.id: item,
        };

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
