import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  final List<TimelineItem> items;

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
      items.add(item);
    } else {
      items[index] = item;
    }
  }
}

void main() {
  final newest = TimelineItem(
    id: 'idea-1',
    type: TimelineItemType.idea,
    text: 'Idea for Search screen',
    createdAt: DateTime.utc(2026, 8, 26, 19),
  );
  final middle = TimelineItem(
    id: 'note-1',
    type: TimelineItemType.note,
    text: 'خرید شیر و نان',
    createdAt: DateTime.utc(2026, 8, 26, 18),
  );
  final oldest = TimelineItem(
    id: 'idea-2',
    type: TimelineItemType.idea,
    text: 'ایده برای سفر',
    createdAt: DateTime.utc(2026, 8, 26, 17),
  );

  test('filters text case-insensitively while preserving repository order', () async {
    final search = SearchTimeline(
      repository: _MemoryTimelineRepository([newest, middle, oldest]),
    );

    final result = await search.search(query: '  search  ');

    expect(result, [newest]);
  });

  test('filters by Timeline item type without changing order', () async {
    final search = SearchTimeline(
      repository: _MemoryTimelineRepository([newest, middle, oldest]),
    );

    final result = await search.search(type: TimelineItemType.idea);

    expect(result, [newest, oldest]);
  });

  test('combines text and type filters', () async {
    final search = SearchTimeline(
      repository: _MemoryTimelineRepository([newest, middle, oldest]),
    );

    final result = await search.search(
      query: 'سفر',
      type: TimelineItemType.idea,
    );

    expect(result, [oldest]);
  });

  test('empty query and no type returns an unmodifiable snapshot', () async {
    final search = SearchTimeline(
      repository: _MemoryTimelineRepository([newest, middle, oldest]),
    );

    final result = await search.search();

    expect(result, [newest, middle, oldest]);
    expect(() => result.add(newest), throwsUnsupportedError);
  });
}
