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
    tempDirectory = await Directory.systemTemp.createTemp('yadnegar_medication_persistence_');
    storageFile = File('${tempDirectory.path}/timeline.json');
    repository = JsonFileTimelineRepository(storageFile);
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  TimelineItem buildReminder() => TimelineItem(
        id: 'med-1',
        type: TimelineItemType.activity,
        text: 'یادآور مصرف',
        createdAt: DateTime.utc(2026, 9, 7, 8),
        reminderAt: DateTime.utc(2026, 9, 7, 8),
        reminderKind: TimelineReminderKind.medicationConsumption,
        medicationName: 'نمونه',
        medicationAmount: 1.5,
        medicationUnit: 'قرص',
        medicationInterval: const Duration(hours: 6),
        scheduledAt: DateTime.utc(2026, 9, 7, 8),
        actualTakenAt: DateTime.utc(2026, 9, 7, 9, 15),
      );

  test('round-trips medication fields through the real JSON repository', () async {
    final item = buildReminder();

    await repository.upsert(item);

    final reloaded = await JsonFileTimelineRepository(storageFile).findById(item.id);

    expect(reloaded, isNotNull);
    expect(reloaded!.reminderKind, TimelineReminderKind.medicationConsumption);
    expect(reloaded.medicationName, 'نمونه');
    expect(reloaded.medicationAmount, 1.5);
    expect(reloaded.medicationUnit, 'قرص');
    expect(reloaded.medicationInterval, const Duration(hours: 6));
    expect(reloaded.scheduledAt, item.scheduledAt);
    expect(reloaded.actualTakenAt, item.actualTakenAt);
    expect(reloaded.medicationNextDueAt, DateTime.utc(2026, 9, 7, 15, 15));
  });

  test('legacy schema 8 remains readable and upgrades to schema 9 on the next write', () async {
    await storageFile.writeAsString(
      jsonEncode({
        'schemaVersion': 8,
        'projects': <Object>[],
        'categories': <Object>[],
        'tags': <Object>[],
        'items': [
          {
            'id': 'legacy-1',
            'type': 'activity',
            'text': 'قدیمی',
            'description': null,
            'projectId': null,
            'categoryId': null,
            'tagIds': <String>[],
            'nextActionAt': null,
            'createdAt': '2026-09-07T08:00:00.000Z',
            'parentId': null,
            'occurredAt': null,
            'reminderAt': '2026-09-07T08:00:00.000Z',
            'reminderRecurrence': 'none',
          },
        ],
      }),
      flush: true,
    );

    final legacy = await repository.findById('legacy-1');
    expect(legacy, isNotNull);
    expect(legacy!.reminderKind, TimelineReminderKind.standard);

    await repository.upsert(legacy);

    final encoded = jsonDecode(await storageFile.readAsString()) as Map<String, dynamic>;
    expect(encoded['schemaVersion'], 9);
  });
}
