import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  test('schema v6 reads nextActionAt as null and upgrades on safe write', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-next-v6-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    await file.writeAsString(
      jsonEncode(<String, Object?>{
        'schemaVersion': 6,
        'projects': <Object?>[],
        'items': <Object?>[
          <String, Object?>{
            'id': 'root-1',
            'type': 'activity',
            'text': 'کار قدیمی',
            'description': 'شرح',
            'projectId': null,
            'createdAt': '2026-08-28T10:00:00.000',
            'parentId': null,
            'occurredAt': null,
            'reminderAt': null,
            'reminderRecurrence': 'none',
          },
        ],
      }),
    );

    final repository = JsonFileTimelineRepository(file);
    final before = await repository.listNewestFirst();
    expect(before.single.nextActionAt, isNull);

    await repository.upsert(before.single);
    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    expect(raw['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    expect(((raw['items'] as List<dynamic>).single as Map<String, dynamic>)['nextActionAt'], isNull);
  });

  test('current schema round-trips root nextActionAt independently from reminderAt', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-next-current-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    final repository = JsonFileTimelineRepository(file);
    final nextActionAt = DateTime(2026, 8, 29, 9, 30);
    final reminderAt = DateTime(2026, 8, 29, 9);

    await repository.upsert(
      TimelineItem(
        id: 'root-1',
        type: TimelineItemType.activity,
        text: 'کار امروز',
        createdAt: DateTime(2026, 8, 28),
        nextActionAt: nextActionAt,
        reminderAt: reminderAt,
      ),
    );

    final loaded = (await repository.listNewestFirst()).single;
    expect(loaded.nextActionAt, nextActionAt);
    expect(loaded.reminderAt, reminderAt);

    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    expect(raw['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final item = (raw['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(item['nextActionAt'], nextActionAt.toIso8601String());
    expect(item['reminderAt'], reminderAt.toIso8601String());
  });

  test('schema v7 rejects FollowUp owning nextActionAt', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-next-invalid-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    await file.writeAsString(
      jsonEncode(<String, Object?>{
        'schemaVersion': 7,
        'projects': <Object?>[],
        'items': <Object?>[
          <String, Object?>{
            'id': 'follow-1',
            'type': 'activity',
            'text': 'پیگیری',
            'description': null,
            'projectId': null,
            'nextActionAt': '2026-08-29T10:00:00.000',
            'createdAt': '2026-08-29T09:00:00.000',
            'parentId': 'root-1',
            'occurredAt': null,
            'reminderAt': null,
            'reminderRecurrence': 'none',
          },
        ],
      }),
    );

    final repository = JsonFileTimelineRepository(file);
    await expectLater(repository.listNewestFirst(), throwsFormatException);
  });
}
