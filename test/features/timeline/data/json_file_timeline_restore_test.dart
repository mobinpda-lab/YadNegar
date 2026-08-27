import 'dart:convert';
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

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('yadnegar_restore_test_');
    storageFile = File('${tempDirectory.path}/timeline.json');
    temporaryFile = File('${storageFile.path}.tmp');
    backupFile = File('${storageFile.path}.bak');
    repository = JsonFileTimelineRepository(storageFile);

    await repository.upsert(
      TimelineItem(
        id: 'original',
        type: TimelineItemType.note,
        text: 'داده اصلی',
        createdAt: DateTime.utc(2026, 8, 27, 8),
      ),
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('valid snapshot replaces primary through the crash-safe write path', () async {
    final candidate = utf8.encode('''
{
  "schemaVersion": 1,
  "items": [
    {
      "id": "older",
      "type": "note",
      "text": "قدیمی‌تر",
      "createdAt": "2026-08-27T09:00:00.000Z",
      "occurredAt": null
    },
    {
      "id": "newer",
      "type": "event",
      "text": "جدیدتر",
      "createdAt": "2026-08-27T09:30:00.000Z",
      "occurredAt": "2026-08-27T11:00:00.000Z"
    }
  ]
}
''');

    await repository.restoreValidatedSnapshotBytes(candidate);

    final restored = await JsonFileTimelineRepository(storageFile).listNewestFirst();
    expect(restored.map((item) => item.id), <String>['newer', 'older']);
    expect(await repository.findById('original'), isNull);
    expect(await temporaryFile.exists(), isFalse);
    expect(await backupFile.exists(), isFalse);
  });

  test('malformed snapshot is rejected without changing primary bytes', () async {
    final before = await storageFile.readAsBytes();

    await expectLater(
      repository.restoreValidatedSnapshotBytes(utf8.encode('{broken')),
      throwsA(isA<FormatException>()),
    );

    expect(await storageFile.readAsBytes(), before);
    expect((await repository.listNewestFirst()).single.id, 'original');
    expect(await temporaryFile.exists(), isFalse);
    expect(await backupFile.exists(), isFalse);
  });

  test('unsupported schema is rejected without changing primary bytes', () async {
    final before = await storageFile.readAsBytes();

    await expectLater(
      repository.restoreValidatedSnapshotBytes(
        utf8.encode('{"schemaVersion":99,"items":[]}'),
      ),
      throwsA(isA<UnsupportedTimelineStorageSchemaException>()),
    );

    expect(await storageFile.readAsBytes(), before);
    expect((await repository.listNewestFirst()).single.id, 'original');
  });

  test('duplicate ids are rejected without changing primary bytes', () async {
    final before = await storageFile.readAsBytes();
    final duplicate = utf8.encode('''
{
  "schemaVersion": 1,
  "items": [
    {
      "id": "same",
      "type": "note",
      "text": "اول",
      "createdAt": "2026-08-27T09:00:00.000Z",
      "occurredAt": null
    },
    {
      "id": "same",
      "type": "idea",
      "text": "دوم",
      "createdAt": "2026-08-27T10:00:00.000Z",
      "occurredAt": null
    }
  ]
}
''');

    await expectLater(
      repository.restoreValidatedSnapshotBytes(duplicate),
      throwsA(isA<DuplicateTimelineItemIdException>()),
    );

    expect(await storageFile.readAsBytes(), before);
    expect((await repository.listNewestFirst()).single.id, 'original');
  });

  test('blank or invalid UTF-8 backup cannot erase existing Timeline', () async {
    final before = await storageFile.readAsBytes();

    await expectLater(
      repository.restoreValidatedSnapshotBytes(utf8.encode('   ')),
      throwsA(isA<FormatException>()),
    );
    await expectLater(
      repository.restoreValidatedSnapshotBytes(<int>[0xff]),
      throwsA(isA<FormatException>()),
    );

    expect(await storageFile.readAsBytes(), before);
    expect((await repository.listNewestFirst()).single.id, 'original');
  });
}
