import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  final List<TimelineItem> items;

  @override
  Future<bool> deleteById(String id) async => false;

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
  Future<void> upsert(TimelineItem item) async {}
}

void main() {
  final newest = TimelineItem(
    id: 'newest',
    type: TimelineItemType.note,
    text: 'newest',
    createdAt: DateTime.utc(2026, 8, 26, 20),
  );
  final occurredEarlier = TimelineItem(
    id: 'occurred-earlier',
    type: TimelineItemType.event,
    text: 'event',
    createdAt: DateTime.utc(2026, 8, 26, 19),
    occurredAt: DateTime.utc(2026, 8, 25, 12),
  );
  final oldest = TimelineItem(
    id: 'oldest',
    type: TimelineItemType.idea,
    text: 'oldest',
    createdAt: DateTime.utc(2026, 8, 24, 10),
  );

  FilterTimelineByDateRange buildFilter() => FilterTimelineByDateRange(
        repository: _MemoryTimelineRepository([
          newest,
          occurredEarlier,
          oldest,
        ]),
      );

  test('uses inclusive start and exclusive end while preserving order', () async {
    final result = await buildFilter().filter(
      start: DateTime.utc(2026, 8, 25, 12),
      end: DateTime.utc(2026, 8, 26, 20),
    );

    expect(result, [occurredEarlier]);
  });

  test('uses timelineAt so occurredAt overrides createdAt for filtering', () async {
    final result = await buildFilter().filter(
      start: DateTime.utc(2026, 8, 26),
    );

    expect(result, [newest]);
  });

  test('supports start-only and end-only ranges', () async {
    final filter = buildFilter();

    expect(
      await filter.filter(start: DateTime.utc(2026, 8, 25)),
      [newest, occurredEarlier],
    );
    expect(
      await filter.filter(end: DateTime.utc(2026, 8, 25)),
      [oldest],
    );
  });

  test('rejects zero or reversed ranges', () async {
    final filter = buildFilter();
    final instant = DateTime.utc(2026, 8, 26);

    await expectLater(
      filter.filter(start: instant, end: instant),
      throwsArgumentError,
    );
    await expectLater(
      filter.filter(
        start: DateTime.utc(2026, 8, 27),
        end: DateTime.utc(2026, 8, 26),
      ),
      throwsArgumentError,
    );
  });

  test('no bounds returns an unmodifiable snapshot', () async {
    final result = await buildFilter().filter();

    expect(result, [newest, occurredEarlier, oldest]);
    expect(() => result.add(newest), throwsUnsupportedError);
  });
}
