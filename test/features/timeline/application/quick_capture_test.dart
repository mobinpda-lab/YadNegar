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
  Future<void> upsert(TimelineItem item) async {
    upsertedItems.add(item);
  }

  @override
  Future<TimelineItem?> findById(String id) async => null;

  @override
  Future<List<TimelineItem>> listNewestFirst() async => <TimelineItem>[];
}
