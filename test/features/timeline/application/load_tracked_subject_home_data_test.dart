import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/load_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('home data uses one repository snapshot and groups children', () async {
    final repository = _CountingRepository(<TimelineItem>[
      _item('orphan', parentId: 'missing', minute: 55),
      _item('a2', parentId: 'a', minute: 50),
      _item('b1', parentId: 'b', minute: 45),
      _item('b', minute: 40, projectId: 'project-b'),
      _item('a1', parentId: 'a', minute: 30),
      _item('a', minute: 20, projectId: 'project-a'),
    ]);

    final result = await LoadTrackedSubjects(repository: repository).loadHomeData();

    expect(repository.listCalls, 1);
    expect(result.subjects.map((item) => item.id), <String>['b', 'a']);
    expect(result.subjects.map((item) => item.projectId), <String?>['project-b', 'project-a']);
    expect(result.followUpsBySubject.keys, <String>['b', 'a']);
    expect(
      result.followUpsBySubject['a']!.map((item) => item.id),
      <String>['a2', 'a1'],
    );
    expect(
      result.followUpsBySubject['b']!.map((item) => item.id),
      <String>['b1'],
    );
    expect(result.followUpsBySubject.containsKey('missing'), isFalse);
  });
}

TimelineItem _item(
  String id, {
  String? parentId,
  String? projectId,
  required int minute,
}) {
  return TimelineItem(
    id: id,
    type: TimelineItemType.activity,
    text: id,
    description: parentId == null ? 'شرح $id' : null,
    projectId: projectId,
    createdAt: DateTime(2026, 8, 28, 12, minute),
    occurredAt: DateTime(2026, 8, 28, 12, minute),
    parentId: parentId,
  );
}

class _CountingRepository implements TimelineRepository {
  _CountingRepository(this.items);

  final List<TimelineItem> items;
  int listCalls = 0;

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
  Future<List<TimelineItem>> listNewestFirst() async {
    listCalls += 1;
    return List<TimelineItem>.of(items);
  }

  @override
  Future<void> upsert(TimelineItem item) async {}
}
