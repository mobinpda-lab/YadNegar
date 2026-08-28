import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  test('schema 4 roots remain readable with no description', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-description-v4-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    await file.writeAsString(
      jsonEncode(<String, Object?>{
        'schemaVersion': 4,
        'items': <Object?>[
          <String, Object?>{
            'id': 'root-1',
            'type': 'activity',
            'text': 'کار قدیمی',
            'createdAt': '2026-08-28T10:00:00.000',
            'parentId': null,
            'occurredAt': null,
            'reminderAt': null,
            'reminderRecurrence': 'none',
          },
        ],
      }),
    );

    final items = await JsonFileTimelineRepository(file).listNewestFirst();

    expect(items, hasLength(1));
    expect(items.single.description, isNull);
    expect(items.single.text, 'کار قدیمی');
  });

  test('current schema round-trips optional tracked-task description', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-description-current-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    final repository = JsonFileTimelineRepository(file);

    await repository.upsert(
      TimelineItem(
        id: 'root-1',
        type: TimelineItemType.activity,
        text: 'پیگیری قرارداد',
        description: 'خلاصه چندخطی قرارداد و اقدام بعدی',
        createdAt: DateTime(2026, 8, 28, 10),
      ),
    );

    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final rawItems = raw['items'] as List<dynamic>;
    final rawItem = rawItems.single as Map<String, dynamic>;
    expect(raw['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    expect(raw['projects'], isA<List<dynamic>>());
    expect(rawItem['description'], 'خلاصه چندخطی قرارداد و اقدام بعدی');

    final reloaded = await JsonFileTimelineRepository(file).listNewestFirst();
    expect(reloaded.single.description, 'خلاصه چندخطی قرارداد و اقدام بعدی');
  });
}
