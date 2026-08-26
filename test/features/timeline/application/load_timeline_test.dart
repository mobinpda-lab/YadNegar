import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  final newest = TimelineItem(
    id: 'item-2',
    type: TimelineItemType.note,
    text: 'جدیدتر',
    createdAt: DateTime.utc(2026, 8, 26, 16),
  );
  final older = TimelineItem(
    id: 'item-1',
    type: TimelineItemType.idea,
    text: 'قدیمی‌تر',
    createdAt: DateTime.utc(2026, 8, 26, 15),
  );

  test('returns the repository newest-first snapshot', () async {
    final repository = _RecordingTimelineRepository(<TimelineItem>[newest, older]);
    final loadTimeline = LoadTimeline(repository: repository);

    final items = await loadTimeline.load();

    expect(items, <TimelineItem>[newest, older]);
    expect(repository.listRequests, 1);
    expect(() => items.add(older), throwsUnsupportedError);
  });

  test('applies an optional limit without changing order', () async {
    final repository = _RecordingTimelineRepository(<TimelineItem>[newest, older]);
    final loadTimeline = LoadTimeline(repository: repository);

    final items = await loadTimeline.load(limit: 1);

    expect(items, <TimelineItem>[newest]);
    expect(repository.listRequests, 1);
  });

  test('rejects a non-positive limit before repository access', () async {
    final repository = _RecordingTimelineRepository(<TimelineItem>[newest, older]);
    final loadTimeline = LoadTimeline(repository: repository);

    await expectLater(loadTimeline.load(limit: 0), throwsArgumentError);

    expect(repository.listRequests, 0);
  });
}

class _RecordingTimelineRepository implements TimelineRepository {
  _RecordingTimelineRepository(this.items);

  final List<TimelineItem> items;
  int listRequests = 0;

  @override
  Future<bool> deleteById(String id) async => false;

  @override
  Future<List<TimelineItem>> listNewestFirst() async {
    listRequests += 1;
    return List<TimelineItem>.of(items);
  }

  @override
  Future<TimelineItem?> findById(String id) async => null;

  @override
  Future<void> upsert(TimelineItem item) async {}
}
