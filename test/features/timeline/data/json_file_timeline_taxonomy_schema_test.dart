import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_taxonomy.dart';

void main() {
  test('schema v7 remains readable and upgrades to taxonomy schema on safe write', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-taxonomy-v7-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    await file.writeAsString(jsonEncode(<String, Object?>{
      'schemaVersion': 7,
      'projects': <Object?>[],
      'items': <Object?>[
        <String, Object?>{
          'id': 'root-1',
          'type': 'activity',
          'text': 'کار قدیمی',
          'description': null,
          'projectId': null,
          'nextActionAt': null,
          'createdAt': '2026-08-29T08:00:00.000',
          'parentId': null,
          'occurredAt': null,
          'reminderAt': null,
          'reminderRecurrence': 'none',
        },
      ],
    }));

    final repository = JsonFileTimelineRepository(file);
    final before = await repository.listNewestFirst();
    expect(before.single.categoryId, isNull);
    expect(before.single.tagIds, isEmpty);
    expect(await repository.listCategories(), isEmpty);
    expect(await repository.listTags(), isEmpty);

    await repository.upsert(before.single);
    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    expect(raw['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    expect(raw['categories'], isEmpty);
    expect(raw['tags'], isEmpty);
  });

  test('taxonomy round-trips category and multiple tags in same JSON file', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-taxonomy-v8-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    final repository = JsonFileTimelineRepository(file);

    await repository.upsertCategory(const YadNegarCategory(
      id: 'category-work',
      title: 'کاری',
      colorValue: 0xFF3176D5,
    ));
    await repository.upsertTag(const YadNegarTag(
      id: 'tag-important',
      title: 'مهم',
      colorValue: 0xFFE5484D,
    ));
    await repository.upsertTag(const YadNegarTag(
      id: 'tag-follow',
      title: 'پیگیری',
      colorValue: 0xFF27A6E5,
    ));
    await repository.upsert(TimelineItem(
      id: 'task-1',
      type: TimelineItemType.activity,
      text: 'کار چندتگی',
      categoryId: 'category-work',
      tagIds: const <String>['tag-important', 'tag-follow'],
      createdAt: DateTime(2026, 8, 29, 12),
    ));

    final task = (await repository.listNewestFirst()).single;
    expect(task.categoryId, 'category-work');
    expect(task.tagIds, <String>['tag-important', 'tag-follow']);
    expect((await repository.listCategories()).single.title, 'کاری');
    expect((await repository.listTags()).length, 2);

    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final item = (raw['items'] as List<dynamic>).single as Map<String, dynamic>;
    expect(item['categoryId'], 'category-work');
    expect(item['tagIds'], <dynamic>['tag-important', 'tag-follow']);
  });

  test('in-use category and tag cannot be deleted until root membership is cleared', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-taxonomy-delete-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    final repository = JsonFileTimelineRepository(file);

    await repository.upsertCategory(const YadNegarCategory(id: 'c1', title: 'کاری', colorValue: 1));
    await repository.upsertTag(const YadNegarTag(id: 't1', title: 'مهم', colorValue: 2));
    await repository.upsert(TimelineItem(
      id: 'task-1',
      type: TimelineItemType.note,
      text: 'کار',
      categoryId: 'c1',
      tagIds: const <String>['t1'],
      createdAt: DateTime(2026, 8, 29),
    ));

    expect(await repository.deleteCategoryById('c1'), isFalse);
    expect(await repository.deleteTagById('t1'), isFalse);

    await repository.upsert(TimelineItem(
      id: 'task-1',
      type: TimelineItemType.note,
      text: 'کار',
      createdAt: DateTime(2026, 8, 29),
    ));
    expect(await repository.deleteCategoryById('c1'), isTrue);
    expect(await repository.deleteTagById('t1'), isTrue);
  });

  test('follow-up taxonomy ownership fails closed when reading schema v8', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-taxonomy-followup-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    await file.writeAsString(jsonEncode(<String, Object?>{
      'schemaVersion': 8,
      'projects': <Object?>[],
      'categories': <Object?>[],
      'tags': <Object?>[],
      'items': <Object?>[
        <String, Object?>{
          'id': 'follow-1',
          'type': 'note',
          'text': 'پیگیری',
          'description': null,
          'projectId': null,
          'categoryId': 'c1',
          'tagIds': <String>[],
          'nextActionAt': null,
          'createdAt': '2026-08-29T08:00:00.000',
          'parentId': 'root-1',
          'occurredAt': null,
          'reminderAt': null,
          'reminderRecurrence': 'none',
        },
      ],
    }));

    final repository = JsonFileTimelineRepository(file);
    expect(repository.listNewestFirst(), throwsFormatException);
  });
}
