import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  late Directory tempDirectory;
  late File storageFile;
  late JsonFileTimelineRepository repository;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('yadnegar_timeline_test_');
    storageFile = File('${tempDirectory.path}/timeline.json');
    repository = JsonFileTimelineRepository(storageFile);
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('persists an item and reloads it from disk', () async {
    final item = TimelineItem(
      id: 'note-1',
      type: TimelineItemType.note,
      text: 'اولین یادداشت',
      createdAt: DateTime.utc(2026, 8, 26, 10),
    );

    await repository.upsert(item);

    final reloadedRepository = JsonFileTimelineRepository(storageFile);
    final stored = await reloadedRepository.findById('note-1');

    expect(stored, isNotNull);
    expect(stored!.id, item.id);
    expect(stored.type, TimelineItemType.note);
    expect(stored.text, 'اولین یادداشت');
    expect(stored.createdAt, item.createdAt);
    expect(stored.occurredAt, isNull);
  });

  test('upsert replaces an existing id without creating a duplicate', () async {
    final createdAt = DateTime.utc(2026, 8, 26, 10);

    await repository.upsert(
      TimelineItem(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'نسخه اول',
        createdAt: createdAt,
      ),
    );
    await repository.upsert(
      TimelineItem(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'نسخه ویرایش‌شده',
        createdAt: createdAt,
      ),
    );

    final items = await repository.listNewestFirst();

    expect(items, hasLength(1));
    expect(items.single.text, 'نسخه ویرایش‌شده');
  });

  test('lists items by effective timeline time newest first', () async {
    await repository.upsert(
      TimelineItem(
        id: 'created-later',
        type: TimelineItemType.activity,
        text: 'بر اساس زمان ایجاد',
        createdAt: DateTime.utc(2026, 8, 26, 12),
      ),
    );
    await repository.upsert(
      TimelineItem(
        id: 'occurred-later',
        type: TimelineItemType.event,
        text: 'بر اساس زمان وقوع',
        createdAt: DateTime.utc(2026, 8, 26, 9),
        occurredAt: DateTime.utc(2026, 8, 26, 13),
      ),
    );

    final items = await repository.listNewestFirst();

    expect(
      items.map((item) => item.id),
      <String>['occurred-later', 'created-later'],
    );
  });

  test('fails fast for an unsupported storage schema version', () async {
    await storageFile.writeAsString(
      '{"schemaVersion":99,"items":[]}',
      flush: true,
    );

    await expectLater(
      repository.listNewestFirst(),
      throwsA(isA<FormatException>()),
    );
  });
}
