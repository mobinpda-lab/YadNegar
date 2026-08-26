import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  late _RecordingTimelineRepository repository;
  late QuickCapture quickCapture;

  final now = DateTime.utc(2026, 8, 26, 16, 30);

  setUp(() {
    repository = _RecordingTimelineRepository();
    quickCapture = QuickCapture(
      repository: repository,
      clock: () => now,
      idGenerator: () => 'capture-1',
    );
  });

  test('creates and persists a normalized Timeline item', () async {
    final occurredAt = DateTime.utc(2026, 8, 26, 15);

    final item = await quickCapture.capture(
      type: TimelineItemType.idea,
      text: '  ایده جدید  ',
      occurredAt: occurredAt,
    );

    expect(item.id, 'capture-1');
    expect(item.type, TimelineItemType.idea);
    expect(item.text, 'ایده جدید');
    expect(item.createdAt, now);
    expect(item.occurredAt, occurredAt);
    expect(repository.upsertedItems, <TimelineItem>[item]);
  });

  test('defaults capture type to note for the fastest path', () async {
    final item = await quickCapture.capture(text: 'یادداشت سریع');

    expect(item.type, TimelineItemType.note);
    expect(item.text, 'یادداشت سریع');
    expect(repository.upsertedItems.single, same(item));
  });

  test('uses the injected clock when occurredAt is omitted', () async {
    final item = await quickCapture.capture(
      type: TimelineItemType.note,
      text: 'یادداشت',
    );

    expect(item.createdAt, now);
    expect(item.occurredAt, isNull);
    expect(item.timelineAt, now);
    expect(repository.upsertedItems.single, same(item));
  });

  test('rejects empty text without writing to the repository', () async {
    await expectLater(
      quickCapture.capture(
        type: TimelineItemType.note,
        text: '   ',
      ),
      throwsArgumentError,
    );

    expect(repository.upsertedItems, isEmpty);
  });

  test('rejects an empty generated id before persistence', () async {
    final invalidCapture = QuickCapture(
      repository: repository,
      clock: () => now,
      idGenerator: () => '   ',
    );

    await expectLater(
      invalidCapture.capture(
        type: TimelineItemType.activity,
        text: 'فعالیت',
      ),
      throwsStateError,
    );

    expect(repository.upsertedItems, isEmpty);
  });
}

class _RecordingTimelineRepository implements TimelineRepository {
  final List<TimelineItem> upsertedItems = <TimelineItem>[];

  @override
  Future<bool> deleteById(String id) async => false;

  @override
  Future<void> upsert(TimelineItem item) async {
    upsertedItems.add(item);
  }

  @override
  Future<TimelineItem?> findById(String id) async => null;

  @override
  Future<List<TimelineItem>> listNewestFirst() async => <TimelineItem>[];
}
