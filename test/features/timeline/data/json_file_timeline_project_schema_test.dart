import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';

void main() {
  test('schema v5 remains readable with no projects and upgrades on safe write', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-project-v5-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    await file.writeAsString(
      jsonEncode(<String, Object?>{
        'schemaVersion': 5,
        'items': <Object?>[
          <String, Object?>{
            'id': 'root-1',
            'type': 'activity',
            'text': 'کار قدیمی',
            'description': 'شرح قدیمی',
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
    expect(before.single.projectId, isNull);
    expect(await repository.listProjects(), isEmpty);

    await repository.upsert(before.single);
    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    expect(raw['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    expect(raw['projects'], isEmpty);
  });

  test('schema v6 round-trips project and root membership in one file', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar-project-v6-');
    addTearDown(() async => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    final repository = JsonFileTimelineRepository(file);

    await repository.upsertProject(
      const YadNegarProject(
        id: 'project-1',
        title: 'پروژه شخصی',
        colorValue: 0xFF3176D5,
      ),
    );
    await repository.upsert(
      TimelineItem(
        id: 'task-1',
        type: TimelineItemType.activity,
        text: 'کار داخل پروژه',
        description: 'توضیحات کار',
        projectId: 'project-1',
        createdAt: DateTime(2026, 8, 28, 12),
      ),
    );

    final projects = await repository.listProjects();
    final tasks = await repository.listNewestFirst();
    expect(projects.single.title, 'پروژه شخصی');
    expect(tasks.single.projectId, 'project-1');
    expect(tasks.single.description, 'توضیحات کار');

    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    expect((raw['projects'] as List<dynamic>).single, isA<Map<String, dynamic>>());
    expect(((raw['items'] as List<dynamic>).single as Map<String, dynamic>)['projectId'], 'project-1');
  });
}
