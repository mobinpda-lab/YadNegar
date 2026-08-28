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
    tempDirectory = await Directory.systemTemp.createTemp('yadnegar_follow_up_schema_');
    storageFile = File('${tempDirectory.path}/timeline.json');
    repository = JsonFileTimelineRepository(storageFile);
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('schema v3 items remain root tracked subjects without read-time rewrite', () async {
    const v3 = '''
{
  "schemaVersion": 3,
  "items": [
    {
      "id": "legacy-root",
      "type": "activity",
      "text": "سرویس خودرو",
      "createdAt": "2026-08-27T08:00:00.000Z",
      "occurredAt": null,
      "reminderAt": null,
      "reminderRecurrence": "none"
    }
  ]
}
''';
    await storageFile.writeAsString(v3, flush: true);
    final before = await storageFile.readAsBytes();

    final item = (await repository.listNewestFirst()).single;

    expect(item.id, 'legacy-root');
    expect(item.parentId, isNull);
    expect(item.isTrackedSubject, isTrue);
    expect(await storageFile.readAsBytes(), before);
  });

  test('schema v4 persists and reloads a follow-up parent relation', () async {
    final root = TimelineItem(
      id: 'car-service',
      type: TimelineItemType.activity,
      text: 'سرویس خودرو',
      createdAt: DateTime.utc(2026, 8, 27, 8),
    );
    final followUp = TimelineItem(
      id: 'car-service-follow-up-1',
      parentId: root.id,
      type: root.type,
      text: 'روغن تعویض شد',
      createdAt: DateTime.utc(2026, 8, 28, 9),
    );

    await repository.upsert(root);
    await repository.upsert(followUp);

    final decoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], 4);
    final rawItems = decoded['items'] as List<dynamic>;
    final rawFollowUp = rawItems.cast<Map<String, dynamic>>().singleWhere(
          (item) => item['id'] == followUp.id,
        );
    expect(rawFollowUp['parentId'], root.id);

    final reloaded = await JsonFileTimelineRepository(storageFile).findById(followUp.id);
    expect(reloaded, isNotNull);
    expect(reloaded!.parentId, root.id);
    expect(reloaded.isFollowUp, isTrue);
  });
}
