import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/data/json_timeline_backup_service.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  late Directory tempDirectory;
  late Directory snapshotDirectory;
  late File storageFile;
  late JsonFileTimelineRepository repository;
  late JsonTimelineBackupService service;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('yadnegar_backup_test_');
    snapshotDirectory = Directory('${tempDirectory.path}/snapshots');
    storageFile = File('${tempDirectory.path}/timeline.json');
    repository = JsonFileTimelineRepository(storageFile);
    service = JsonTimelineBackupService(
      repository: repository,
      clock: () => DateTime.utc(2026, 8, 27, 1, 2, 3),
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('creates a valid snapshot without changing primary storage bytes', () async {
    await repository.upsert(
      TimelineItem(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'نسخه پشتیبان من',
        createdAt: DateTime.utc(2026, 8, 27, 1),
      ),
    );
    final before = await storageFile.readAsBytes();

    final snapshot = await service.createSnapshot(snapshotDirectory);

    expect(snapshot.path, endsWith('yadnegar-backup-2026-08-27T01-02-03.000Z.json'));
    expect(await snapshot.exists(), isTrue);
    expect(await storageFile.readAsBytes(), before);

    final items = await JsonFileTimelineRepository(snapshot).listNewestFirst();
    expect(items.single.id, 'note-1');
    expect(items.single.text, 'نسخه پشتیبان من');
  });

  test('runs recovery before creating a snapshot', () async {
    await repository.upsert(
      TimelineItem(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'نسخه قابل بازیابی',
        createdAt: DateTime.utc(2026, 8, 27),
      ),
    );
    final backupFile = File('${storageFile.path}.bak');
    await storageFile.rename(backupFile.path);

    final snapshot = await service.createSnapshot(snapshotDirectory);

    expect(await storageFile.exists(), isTrue);
    expect(await backupFile.exists(), isFalse);
    final items = await JsonFileTimelineRepository(snapshot).listNewestFirst();
    expect(items.single.text, 'نسخه قابل بازیابی');
  });

  test('creates a valid empty snapshot without creating primary storage', () async {
    expect(await storageFile.exists(), isFalse);

    final snapshot = await service.createSnapshot(snapshotDirectory);

    expect(await storageFile.exists(), isFalse);
    final items = await JsonFileTimelineRepository(snapshot).listNewestFirst();
    expect(items, isEmpty);
  });
}
