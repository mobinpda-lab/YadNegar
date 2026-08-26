import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/restore_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  final item = TimelineItem(
    id: 'item-1',
    type: TimelineItemType.event,
    text: 'جلسه',
    createdAt: DateTime.utc(2026, 8, 27, 8),
    occurredAt: DateTime.utc(2026, 8, 27, 9),
  );

  test('restores a missing item through existing upsert', () async {
    final repository = _MemoryTimelineRepository();
    final restore = RestoreTimelineItem(repository: repository);

    final restored = await restore.restore(item);

    expect(restored, isTrue);
    expect(await repository.findById(item.id), same(item));
    expect(repository.upsertRequests, <TimelineItem>[item]);
  });

  test('does not overwrite an item that reclaimed the same id', () async {
    final replacement = TimelineItem(
      id: item.id,
      type: TimelineItemType.note,
      text: 'داده جدیدتر',
      createdAt: DateTime.utc(2026, 8, 27, 10),
    );
    final repository = _MemoryTimelineRepository(seed: replacement);
    final restore = RestoreTimelineItem(repository: repository);

    final restored = await restore.restore(item);

    expect(restored, isFalse);
    expect(await repository.findById(item.id), same(replacement));
    expect(repository.upsertRequests, isEmpty);
  });

  test('rejects an empty item id before repository access', () async {
    final repository = _MemoryTimelineRepository();
    final restore = RestoreTimelineItem(repository: repository);
    final invalid = TimelineItem(
      id: '   ',
      type: TimelineItemType.note,
      text: 'نامعتبر',
      createdAt: DateTime.utc(2026, 8, 27),
    );

    await expectLater(restore.restore(invalid), throwsArgumentError);

    expect(repository.findRequests, isEmpty);
    expect(repository.upsertRequests, isEmpty);
  });
}

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository({TimelineItem? seed}) {
    if (seed != null) {
      _items[seed.id] = seed;
    }
  }

  final Map<String, TimelineItem> _items = <String, TimelineItem>{};
  final List<String> findRequests = <String>[];
  final List<TimelineItem> upsertRequests = <TimelineItem>[];

  @override
  Future<bool> deleteById(String id) async => _items.remove(id) != null;

  @override
  Future<TimelineItem?> findById(String id) async {
    findRequests.add(id);
    return _items[id];
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async => _items.values.toList();

  @override
  Future<void> upsert(TimelineItem item) async {
    upsertRequests.add(item);
    _items[item.id] = item;
  }
}
