import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/record_medication_consumption.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  late Directory directory;
  late File file;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('yadnegar-medication-');
    file = File('${directory.path}/timeline.json');
  });

  tearDown(() async {
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  });

  TimelineItem buildReminder({
    required String id,
    required DateTime scheduled,
    required Duration interval,
    double amount = 1,
    String unit = 'قرص',
  }) =>
      TimelineItem(
        id: id,
        type: TimelineItemType.activity,
        text: 'مصرف دارو',
        createdAt: scheduled,
        reminderAt: scheduled,
        reminderKind: TimelineReminderKind.medicationConsumption,
        medicationName: 'نمونه',
        medicationAmount: amount,
        medicationUnit: unit,
        medicationInterval: interval,
        scheduledAt: scheduled,
      );

  test('keeps actual consumption state after repository re-open', () async {
    final scheduled = DateTime(2026, 9, 27, 8);
    final taken = DateTime(2026, 9, 27, 8, 42);
    final repository = JsonFileTimelineRepository(file);
    final reminder = buildReminder(
      id: 'med-persist-1',
      scheduled: scheduled,
      interval: const Duration(hours: 6),
    );

    await repository.upsert(reminder);
    await RecordMedicationConsumption(repository)(
      reminder: reminder,
      actualTakenAt: taken,
    );

    final reopened = JsonFileTimelineRepository(file);
    final restored = await reopened.findById(reminder.id);

    expect(restored, isNotNull);
    expect(restored!.scheduledAt, scheduled);
    expect(restored.actualTakenAt, taken);
    expect(restored.reminderAt, taken.add(const Duration(hours: 6)));
    expect(restored.medicationName, 'نمونه');
    expect(restored.medicationAmount, 1);
    expect(restored.medicationUnit, 'قرص');
    expect(restored.medicationInterval, const Duration(hours: 6));
  });

  test('preserves actual consumption state through validated snapshot restore', () async {
    final scheduled = DateTime(2026, 9, 27, 8);
    final taken = DateTime(2026, 9, 27, 8, 42);
    final source = JsonFileTimelineRepository(file);
    final reminder = buildReminder(
      id: 'med-backup-1',
      scheduled: scheduled,
      interval: const Duration(hours: 8),
      amount: 2,
      unit: 'کپسول',
    );

    await source.upsert(reminder);
    await RecordMedicationConsumption(source)(
      reminder: reminder,
      actualTakenAt: taken,
    );

    final snapshot = await source.readValidatedSnapshotBytes();
    final targetFile = File('${directory.path}/restored/timeline.json');
    final target = JsonFileTimelineRepository(targetFile);
    await target.restoreValidatedSnapshotBytes(snapshot);

    final restored = await target.findById(reminder.id);
    expect(restored, isNotNull);
    expect(restored!.scheduledAt, scheduled);
    expect(restored.actualTakenAt, taken);
    expect(restored.reminderAt, taken.add(const Duration(hours: 8)));
    expect(restored.medicationName, 'نمونه');
    expect(restored.medicationAmount, 2);
    expect(restored.medicationUnit, 'کپسول');
    expect(restored.medicationInterval, const Duration(hours: 8));
  });

  test('repeated consumption updates one reminder instead of creating duplicates', () async {
    final scheduled = DateTime(2026, 9, 27, 8);
    final repository = JsonFileTimelineRepository(file);
    final reminder = buildReminder(
      id: 'med-single-1',
      scheduled: scheduled,
      interval: const Duration(hours: 6),
    );

    await repository.upsert(reminder);
    final firstTaken = DateTime(2026, 9, 27, 8, 30);
    final first = await RecordMedicationConsumption(repository)(
      reminder: reminder,
      actualTakenAt: firstTaken,
    );
    final secondTaken = DateTime(2026, 9, 27, 9);
    await RecordMedicationConsumption(repository)(
      reminder: first,
      actualTakenAt: secondTaken,
    );

    final items = await repository.listNewestFirst();
    expect(items, hasLength(1));
    expect(items.single.id, reminder.id);
    expect(items.single.actualTakenAt, secondTaken);
    expect(items.single.reminderAt, secondTaken.add(const Duration(hours: 6)));
  });
}
