import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  late Directory tempDirectory;
  late File storageFile;
  late File temporaryFile;
  late File backupFile;
  late JsonFileTimelineRepository repository;

  TimelineItem buildItem({String text = 'اولین یادداشت'}) => TimelineItem(
        id: 'note-1',
        type: TimelineItemType.note,
        text: text,
        createdAt: DateTime.utc(2026, 8, 26, 10),
      );

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('yadnegar_timeline_test_');
    storageFile = File('${tempDirectory.path}/timeline.json');
    temporaryFile = File('${storageFile.path}.tmp');
    backupFile = File('${storageFile.path}.bak');
    repository = JsonFileTimelineRepository(storageFile);
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('persists an item and reloads it from disk', () async {
    final item = buildItem();

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

  test('successful writes leave no staging files behind', () async {
    await repository.upsert(buildItem());

    expect(await storageFile.exists(), isTrue);
    expect(await temporaryFile.exists(), isFalse);
    expect(await backupFile.exists(), isFalse);
  });

  test('delete persists removal through the crash-safe write path', () async {
    await repository.upsert(buildItem());
    await repository.upsert(
      TimelineItem(
        id: 'idea-2',
        type: TimelineItemType.idea,
        text: 'باقی بماند',
        createdAt: DateTime.utc(2026, 8, 26, 11),
      ),
    );

    final deleted = await repository.deleteById('note-1');

    expect(deleted, isTrue);
    expect(await temporaryFile.exists(), isFalse);
    expect(await backupFile.exists(), isFalse);

    final reloadedRepository = JsonFileTimelineRepository(storageFile);
    final reloaded = await reloadedRepository.listNewestFirst();
    expect(reloaded.map((item) => item.id), <String>['idea-2']);
    expect(await reloadedRepository.findById('note-1'), isNull);
  });

  test('delete returns false when id does not exist', () async {
    await repository.upsert(buildItem());

    final deleted = await repository.deleteById('missing');

    expect(deleted, isFalse);
    final items = await repository.listNewestFirst();
    expect(items.single.id, 'note-1');
  });

  test('recovers previous primary when interruption leaves only backup', () async {
    await repository.upsert(buildItem(text: 'نسخه امن'));
    await storageFile.rename(backupFile.path);

    final recovered = await JsonFileTimelineRepository(storageFile).listNewestFirst();

    expect(recovered.single.text, 'نسخه امن');
    expect(await storageFile.exists(), isTrue);
    expect(await backupFile.exists(), isFalse);
    expect(await temporaryFile.exists(), isFalse);
  });

  test('falls back to valid backup when primary JSON is corrupted', () async {
    await repository.upsert(buildItem(text: 'نسخه پشتیبان'));
    await storageFile.copy(backupFile.path);
    await storageFile.writeAsString('{broken', flush: true);

    final recovered = await JsonFileTimelineRepository(storageFile).listNewestFirst();

    expect(recovered.single.text, 'نسخه پشتیبان');
    expect(await backupFile.exists(), isFalse);
    expect(await temporaryFile.exists(), isFalse);
  });

  test('promotes a valid staged first-write when primary is missing', () async {
    await temporaryFile.writeAsString(
      '{"schemaVersion":1,"items":[{"id":"note-1","type":"note","text":"staged","createdAt":"2026-08-26T10:00:00.000Z","occurredAt":null}]}',
      flush: true,
    );

    final recovered = await JsonFileTimelineRepository(storageFile).listNewestFirst();

    expect(recovered.single.text, 'staged');
    expect(await storageFile.exists(), isTrue);
    expect(await temporaryFile.exists(), isFalse);
  });

  test('discards invalid staged first-write instead of promoting it', () async {
    await temporaryFile.writeAsString('{broken', flush: true);

    final recovered = await JsonFileTimelineRepository(storageFile).listNewestFirst();

    expect(recovered, isEmpty);
    expect(await storageFile.exists(), isFalse);
    expect(await temporaryFile.exists(), isFalse);
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
