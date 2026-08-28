import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/build_tracked_subject_export.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('build all keeps roots and complete follow-up history separated', () async {
    final repository = _MemoryRepository(<TimelineItem>[
      _item('follow-b2', parentId: 'b', minute: 50),
      _item('follow-a2', parentId: 'a', minute: 40),
      _item('follow-a1', parentId: 'a', minute: 30),
      _item('b', minute: 20),
      _item('a', minute: 10),
    ]);

    final result = await BuildTrackedSubjectExport(repository: repository).build();

    expect(result.entries.map((entry) => entry.subject.id), <String>['b', 'a']);
    expect(result.entries[0].followUps.map((item) => item.id), <String>['follow-b2']);
    expect(
      result.entries[1].followUps.map((item) => item.id),
      <String>['follow-a2', 'follow-a1'],
    );
  });

  test('selected export contains only selected roots and their children', () async {
    final repository = _MemoryRepository(<TimelineItem>[
      _item('follow-b', parentId: 'b', minute: 40),
      _item('follow-a', parentId: 'a', minute: 30),
      _item('b', minute: 20),
      _item('a', minute: 10),
    ]);

    final result = await BuildTrackedSubjectExport(repository: repository).build(
      subjectIds: <String>{'a'},
    );

    expect(result.entries, hasLength(1));
    expect(result.entries.single.subject.id, 'a');
    expect(result.entries.single.followUps.map((item) => item.id), <String>['follow-a']);
  });

  test('empty selection exports no tracked subjects', () async {
    final repository = _MemoryRepository(<TimelineItem>[_item('a', minute: 10)]);

    final result = await BuildTrackedSubjectExport(repository: repository).build(
      subjectIds: <String>{},
    );

    expect(result.isEmpty, isTrue);
  });

  test('date report includes only roots with matching follow-ups', () async {
    final repository = _MemoryRepository(<TimelineItem>[
      _item('a', day: 20, minute: 10),
      _item('b', day: 20, minute: 20),
      _item('a-before', parentId: 'a', day: 27, minute: 50),
      _item('a-in', parentId: 'a', day: 28, minute: 15),
      _item('a-after', parentId: 'a', day: 29, minute: 5),
      _item('b-outside', parentId: 'b', day: 29, minute: 10),
    ]);

    final result = await BuildTrackedSubjectExport(repository: repository).build(
      subjectIds: TrackedSubjectDateRangeSelection(
        startInclusive: DateTime(2026, 8, 28),
        endInclusive: DateTime(2026, 8, 28, 23, 59, 59, 999),
      ),
    );

    expect(result.entries, hasLength(1));
    expect(result.entries.single.subject.id, 'a');
    expect(
      result.entries.single.followUps.map((item) => item.id),
      <String>['a-in'],
    );
  });

  test('date range boundaries are inclusive', () async {
    final repository = _MemoryRepository(<TimelineItem>[
      _item('a', day: 20, minute: 10),
      _itemAt('start', parentId: 'a', at: DateTime(2026, 8, 28)),
      _itemAt(
        'end',
        parentId: 'a',
        at: DateTime(2026, 8, 29, 23, 59, 59, 999),
      ),
    ]);

    final result = await BuildTrackedSubjectExport(repository: repository).build(
      subjectIds: TrackedSubjectDateRangeSelection(
        startInclusive: DateTime(2026, 8, 28),
        endInclusive: DateTime(2026, 8, 29, 23, 59, 59, 999),
      ),
    );

    expect(
      result.entries.single.followUps.map((item) => item.id),
      <String>['end', 'start'],
    );
  });
}

TimelineItem _item(
  String id, {
  String? parentId,
  int day = 28,
  required int minute,
}) {
  return _itemAt(
    id,
    parentId: parentId,
    at: DateTime(2026, 8, day, 12, minute),
  );
}

TimelineItem _itemAt(
  String id, {
  String? parentId,
  required DateTime at,
}) {
  return TimelineItem(
    id: id,
    type: TimelineItemType.activity,
    text: id,
    createdAt: at,
    occurredAt: at,
    parentId: parentId,
  );
}

class _MemoryRepository implements TimelineRepository {
  _MemoryRepository(this.items);

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
  Future<List<TimelineItem>> listNewestFirst() async => List<TimelineItem>.of(items);

  @override
  Future<void> upsert(TimelineItem item) async {}
}
