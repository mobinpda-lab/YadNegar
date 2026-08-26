import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  late _RecordingTimelineRepository repository;
  late EditTimelineItem editTimelineItem;

  final original = TimelineItem(
    id: 'item-1',
    type: TimelineItemType.idea,
    text: 'متن قبلی',
    createdAt: DateTime.utc(2026, 8, 26, 12),
    occurredAt: DateTime.utc(2026, 8, 26, 11, 30),
  );

  setUp(() {
    repository = _RecordingTimelineRepository(<String, TimelineItem>{
      original.id: original,
    });
    editTimelineItem = EditTimelineItem(repository: repository);
  });

  test('updates normalized text while preserving Timeline metadata', () async {
    final updated = await editTimelineItem.updateText(
      id: ' item-1 ',
      text: '  متن جدید  ',
    );

    expect(updated.id, original.id);
    expect(updated.type, original.type);
    expect(updated.text, 'متن جدید');
    expect(updated.createdAt, original.createdAt);
    expect(updated.occurredAt, original.occurredAt);
    expect(repository.upsertedItems, <TimelineItem>[updated]);
  });

  test('can replace occurredAt without changing identity metadata', () async {
    final occurredAt = DateTime.utc(2026, 8, 27, 9, 15);

    final updated = await editTimelineItem.update(
      id: original.id,
      text: 'متن جدید',
      replaceOccurredAt: true,
      occurredAt: occurredAt,
    );

    expect(updated.id, original.id);
    expect(updated.type, original.type);
    expect(updated.createdAt, original.createdAt);
    expect(updated.occurredAt, occurredAt);
  });

  test('can explicitly clear occurredAt', () async {
    final updated = await editTimelineItem.update(
      id: original.id,
      text: original.text,
      replaceOccurredAt: true,
      occurredAt: null,
    );

    expect(updated.occurredAt, isNull);
    expect(updated.createdAt, original.createdAt);
    expect(updated.type, original.type);
  });

  test('can replace type while preserving id and createdAt', () async {
    final occurredAt = DateTime.utc(2026, 8, 28, 8, 45);

    final updated = await editTimelineItem.update(
      id: original.id,
      text: original.text,
      type: TimelineItemType.activity,
      replaceOccurredAt: true,
      occurredAt: occurredAt,
    );

    expect(updated.id, original.id);
    expect(updated.type, TimelineItemType.activity);
    expect(updated.createdAt, original.createdAt);
    expect(updated.occurredAt, occurredAt);
  });

  test('changing to a type without occurredAt clears hidden occurredAt', () async {
    final updated = await editTimelineItem.update(
      id: original.id,
      text: original.text,
      type: TimelineItemType.note,
    );

    expect(updated.type, TimelineItemType.note);
    expect(updated.occurredAt, isNull);
    expect(updated.createdAt, original.createdAt);
  });

  test('rejects empty text before writing', () async {
    await expectLater(
      editTimelineItem.updateText(id: original.id, text: '   '),
      throwsArgumentError,
    );

    expect(repository.upsertedItems, isEmpty);
  });

  test('rejects empty id before repository lookup', () async {
    await expectLater(
      editTimelineItem.updateText(id: '   ', text: 'متن'),
      throwsArgumentError,
    );

    expect(repository.findRequests, isEmpty);
    expect(repository.upsertedItems, isEmpty);
  });

  test('fails when the Timeline item does not exist', () async {
    await expectLater(
      editTimelineItem.updateText(id: 'missing', text: 'متن جدید'),
      throwsStateError,
    );

    expect(repository.findRequests, <String>['missing']);
    expect(repository.upsertedItems, isEmpty);
  });
}

class _RecordingTimelineRepository implements TimelineRepository {
  _RecordingTimelineRepository(this.items);

  final Map<String, TimelineItem> items;
  final List<String> findRequests = <String>[];
  final List<TimelineItem> upsertedItems = <TimelineItem>[];

  @override
  Future<TimelineItem?> findById(String id) async {
    findRequests.add(id);
    return items[id];
  }

  @override
  Future<void> upsert(TimelineItem item) async {
    upsertedItems.add(item);
    items[item.id] = item;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async => items.values.toList();
}
