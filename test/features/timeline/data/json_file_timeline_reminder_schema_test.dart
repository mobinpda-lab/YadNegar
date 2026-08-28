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
    expect(items.single.parentId, isNull);
    expect(items.single.reminderAt, isNull);
    expect(items.single.reminderRecurrence, TimelineReminderRecurrence.none);
    expect(await storageFile.readAsBytes(), legacyBytes);

    await repository.upsert(items.single);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final storedItem = (decoded['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(storedItem['parentId'], isNull);
    expect(storedItem['reminderAt'], isNull);
    expect(storedItem['reminderRecurrence'], 'none');
  });

  test('reads schema v2 unchanged and preserves reminderAt on current safe write', () async {
    const v2 = '''
{
  "schemaVersion": 2,
  "items": [
    {
      "id": "v2-reminder",
      "type": "call",
      "text": "تماس قدیمی",
      "createdAt": "2026-08-27T07:00:00.000Z",
      "occurredAt": null,
      "reminderAt": "2026-08-28T09:30:00.000Z"
    }
  ]
}
''';
    await storageFile.writeAsString(v2, flush: true);
    final before = await storageFile.readAsBytes();

    final item = (await repository.listNewestFirst()).single;

    expect(item.parentId, isNull);
    expect(item.reminderAt, DateTime.utc(2026, 8, 28, 9, 30));
    expect(item.reminderRecurrence, TimelineReminderRecurrence.none);
    expect(await storageFile.readAsBytes(), before);

    await repository.upsert(item);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final storedItem = (decoded['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(storedItem['parentId'], isNull);
    expect(storedItem['reminderAt'], '2026-08-28T09:30:00.000Z');
    expect(storedItem['reminderRecurrence'], 'none');
  });

  test('reads schema v3 recurrence as root and upgrades on safe write', () async {
    const v3 = '''
{
  "schemaVersion": 3,
  "items": [
    {
      "id": "daily-reminder",
      "type": "note",
      "text": "پیگیری روزانه",
      "createdAt": "2026-08-27T07:00:00.000Z",
      "occurredAt": null,
      "reminderAt": "2026-08-28T09:30:00.000Z",
      "reminderRecurrence": "daily"
    }
  ]
}
''';
    await storageFile.writeAsString(v3, flush: true);

    final item = (await repository.listNewestFirst()).single;
    expect(item.parentId, isNull);
    expect(item.reminderRecurrence, TimelineReminderRecurrence.daily);

    await repository.upsert(item);
    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
  });

  test('current schema round-trips daily reminder recurrence', () async {
    final createdAt = DateTime.utc(2026, 8, 27, 7);
    final reminderAt = DateTime.utc(2026, 8, 28, 9, 30);

    await repository.upsert(
      TimelineItem(
        id: 'daily-reminder',
        type: TimelineItemType.note,
        text: 'پیگیری روزانه',
        createdAt: createdAt,
        reminderAt: reminderAt,
        reminderRecurrence: TimelineReminderRecurrence.daily,
      ),
    );

    final reloaded = (await JsonFileTimelineRepository(storageFile).listNewestFirst()).single;
    expect(reloaded.parentId, isNull);
    expect(reloaded.reminderAt, reminderAt);
    expect(reloaded.reminderRecurrence, TimelineReminderRecurrence.daily);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final storedItem = (decoded['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(storedItem['reminderRecurrence'], 'daily');
  });

  test('restoring a valid v2 snapshot upgrades it through the current safe write path', () async {
    final v2Snapshot = utf8.encode('''
{
  "schemaVersion": 2,
  "items": [
    {
      "id": "legacy-restore",
      "type": "idea",
      "text": "از پشتیبان قدیمی",
      "createdAt": "2026-08-27T05:00:00.000Z",
      "occurredAt": null,
      "reminderAt": "2026-08-29T10:00:00.000Z"
    }
  ]
}
''');

    await repository.restoreValidatedSnapshotBytes(v2Snapshot);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final restored = (await repository.listNewestFirst()).single;
    expect(restored.id, 'legacy-restore');
    expect(restored.parentId, isNull);
    expect(restored.reminderAt, DateTime.utc(2026, 8, 29, 10));
    expect(restored.reminderRecurrence, TimelineReminderRecurrence.none);
  });

  test('backup snapshot preserves weekly recurrence in current schema', () async {
    final reminderAt = DateTime.utc(2026, 8, 28, 10);
    await repository.upsert(
      TimelineItem(
        id: 'backup-reminder',
        type: TimelineItemType.call,
        text: 'تماس هفتگی',
        createdAt: DateTime.utc(2026, 8, 27, 10),
        reminderAt: reminderAt,
        reminderRecurrence: TimelineReminderRecurrence.weekly,
      ),
    );

    final snapshot = utf8.decode(await repository.readValidatedSnapshotBytes());
    final decoded = jsonDecode(snapshot) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final storedItem = (decoded['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(storedItem['parentId'], isNull);
    expect(storedItem['reminderAt'], reminderAt.toIso8601String());
    expect(storedItem['reminderRecurrence'], 'weekly');
  });

  test('schema v3 rejects an invalid recurrence value', () async {
    await storageFile.writeAsString(
      '{"schemaVersion":3,"items":[{"id":"bad","type":"note","text":"bad","createdAt":"2026-08-27T06:00:00.000Z","occurredAt":null,"reminderAt":"2026-08-28T06:00:00.000Z","reminderRecurrence":"monthly"}]}',
      flush: true,
    );

    await expectLater(
      repository.listNewestFirst(),
      throwsA(isA<FormatException>()),
    );
  });
}
