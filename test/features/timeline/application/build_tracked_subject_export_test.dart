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
}

TimelineItem _item(
  String id, {
  String? parentId,
  required int minute,
}) {
  return TimelineItem(
    id: id,
    type: TimelineItemType.activity,
    text: id,
    createdAt: DateTime(2026, 8, 28, 12, minute),
    occurredAt: DateTime(2026, 8, 28, 12, minute),
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
