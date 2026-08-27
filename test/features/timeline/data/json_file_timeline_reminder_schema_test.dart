import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  late Directory tempDirectory;
  late File storageFile;
  late JsonFileTimelineRepository repository;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('yadnegar_reminder_schema_');
    storageFile = File('${tempDirectory.path}/timeline.json');
    repository = JsonFileTimelineRepository(storageFile);
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('reads schema v1 unchanged and upgrades it on the next safe write', () async {
    await storageFile.writeAsString(
      '''
{
  "schemaVersion": 1,
  "items": [
    {
      "id": "legacy-note",
      "type": "note",
      "text": "داده قدیمی",
      "createdAt": "2026-08-27T06:00:00.000Z",
      "occurredAt": null
    }
  ]
}
''',
      flush: true,
    );

    final legacyBytes = await storageFile.readAsBytes();
    final items = await repository.listNewestFirst();

    expect(items.single.id, 'legacy-note');
    expect(items.single.reminderAt, isNull);
    expect(await storageFile.readAsBytes(), legacyBytes);

    await repository.upsert(items.single);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final storedItem = (decoded['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(storedItem['reminderAt'], isNull);
  });

  test('schema v2 round-trips reminderAt without changing timelineAt', () async {
    final createdAt = DateTime.utc(2026, 8, 27, 7);
    final occurredAt = DateTime.utc(2026, 8, 27, 8);
    final reminderAt = DateTime.utc(2026, 8, 27, 9, 30);

    await repository.upsert(
      TimelineItem(
        id: 'event-reminder',
        type: TimelineItemType.event,
        text: 'جلسه',
        createdAt: createdAt,
        occurredAt: occurredAt,
        reminderAt: reminderAt,
      ),
    );

    final reloaded = (await JsonFileTimelineRepository(storageFile).listNewestFirst()).single;
    expect(reloaded.reminderAt, reminderAt);
    expect(reloaded.timelineAt, occurredAt);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], 2);
    final storedItem = (decoded['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(storedItem['reminderAt'], reminderAt.toIso8601String());
  });

  test('restoring a valid v1 snapshot upgrades it through the safe v2 write path', () async {
    final legacySnapshot = utf8.encode('''
{
  "schemaVersion": 1,
  "items": [
    {
      "id": "legacy-restore",
      "type": "idea",
      "text": "از پشتیبان قدیمی",
      "createdAt": "2026-08-27T05:00:00.000Z",
      "occurredAt": null
    }
  ]
}
''');

    await repository.restoreValidatedSnapshotBytes(legacySnapshot);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], 2);
    final restored = (await repository.listNewestFirst()).single;
    expect(restored.id, 'legacy-restore');
    expect(restored.reminderAt, isNull);
  });

  test('backup snapshot preserves reminderAt in schema v2', () async {
    final reminderAt = DateTime.utc(2026, 8, 28, 10);
    await repository.upsert(
      TimelineItem(
        id: 'backup-reminder',
        type: TimelineItemType.call,
        text: 'تماس فردا',
        createdAt: DateTime.utc(2026, 8, 27, 10),
        reminderAt: reminderAt,
      ),
    );

    final snapshot = utf8.decode(await repository.readValidatedSnapshotBytes());
    final decoded = jsonDecode(snapshot) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], 2);
    final storedItem = (decoded['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(storedItem['reminderAt'], reminderAt.toIso8601String());
  });

  test('schema v2 rejects an invalid reminderAt value', () async {
    await storageFile.writeAsString(
      '{"schemaVersion":2,"items":[{"id":"bad","type":"note","text":"bad","createdAt":"2026-08-27T06:00:00.000Z","occurredAt":null,"reminderAt":"not-a-date"}]}',
      flush: true,
    );

    await expectLater(
      repository.listNewestFirst(),
      throwsA(isA<FormatException>()),
    );
  });
}
