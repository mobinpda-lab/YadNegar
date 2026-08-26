import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('normalizes id and returns repository deletion result', () async {
    final repository = _RecordingTimelineRepository(existingId: 'item-1');
    final deleteTimelineItem = DeleteTimelineItem(repository: repository);

    final deleted = await deleteTimelineItem.delete(id: ' item-1 ');

    expect(deleted, isTrue);
    expect(repository.deleteRequests, <String>['item-1']);
  });

  test('returns false when repository has no matching item', () async {
    final repository = _RecordingTimelineRepository();
    final deleteTimelineItem = DeleteTimelineItem(repository: repository);

    final deleted = await deleteTimelineItem.delete(id: 'missing');

    expect(deleted, isFalse);
    expect(repository.deleteRequests, <String>['missing']);
  });

  test('rejects empty id before repository access', () async {
    final repository = _RecordingTimelineRepository();
    final deleteTimelineItem = DeleteTimelineItem(repository: repository);

    await expectLater(
      deleteTimelineItem.delete(id: '   '),
      throwsArgumentError,
    );

    expect(repository.deleteRequests, isEmpty);
  });
}

class _RecordingTimelineRepository implements TimelineRepository {
  _RecordingTimelineRepository({this.existingId});

  final String? existingId;
  final List<String> deleteRequests = <String>[];

  @override
  Future<bool> deleteById(String id) async {
    deleteRequests.add(id);
    return id == existingId;
  }

  @override
  Future<TimelineItem?> findById(String id) async => null;

  @override
  Future<List<TimelineItem>> listNewestFirst() async => <TimelineItem>[];

  @override
  Future<void> upsert(TimelineItem item) async {}
}
