import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/record_medication_consumption.dart';
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_detail.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  final List<TimelineItem> items;

  @override
  Future<bool> deleteById(String id) async {
    final before = items.length;
    items.removeWhere((item) => item.id == id);
    return items.length != before;
  }

  @override
  Future<TimelineItem?> findById(String id) async {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async {
    final result = List<TimelineItem>.of(items)
      ..sort((left, right) => right.timelineAt.compareTo(left.timelineAt));
    return result;
  }

  @override
  Future<void> upsert(TimelineItem item) async {
    final index = items.indexWhere((candidate) => candidate.id == item.id);
    if (index == -1) {
      items.add(item);
    } else {
      items[index] = item;
    }
  }
}

class _FakeReminderScheduler implements TimelineReminderScheduler {
  TimelineItem? scheduledItem;
  String? cancelledId;

  @override
  Future<TimelineReminderScheduleResult> schedule(TimelineItem item) async {
    scheduledItem = item;
    return TimelineReminderScheduleResult.scheduled;
  }

  @override
  Future<void> cancel(String timelineItemId) async {
    cancelledId = timelineItemId;
  }

  @override
  Future<void> reconcile(Iterable<TimelineItem> items) async {}
}

class _FakeMedicationRecorder extends RecordMedicationConsumption {
  _FakeMedicationRecorder(this.result, TimelineRepository repository)
      : super(repository);

  final TimelineItem result;
  TimelineItem? receivedReminder;

  @override
  Future<TimelineItem> call({
    required TimelineItem reminder,
    DateTime? actualTakenAt,
  }) async {
    receivedReminder = reminder;
    return result;
  }
}

void main() {
  testWidgets('consumption action records the result and reschedules the same reminder', (
    tester,
  ) async {
    final scheduledAt = DateTime(2026, 9, 27, 8);
    final takenAt = DateTime(2026, 9, 27, 9, 17);
    final nextDueAt = takenAt.add(const Duration(hours: 8));
    final subject = TimelineItem(
      id: 'subject-1',
      type: TimelineItemType.activity,
      text: 'پیگیری درمان',
      createdAt: scheduledAt,
    );
    final medication = TimelineItem(
      id: 'med-1',
      parentId: subject.id,
      type: TimelineItemType.activity,
      text: 'یادآور مصرف',
      createdAt: scheduledAt,
      reminderAt: scheduledAt,
      reminderKind: TimelineReminderKind.medicationConsumption,
      medicationName: 'نمونه',
      medicationAmount: 1,
      medicationUnit: 'قرص',
      medicationInterval: const Duration(hours: 8),
      scheduledAt: scheduledAt,
    );
    final updated = TimelineItem(
      id: medication.id,
      parentId: medication.parentId,
      type: medication.type,
      text: medication.text,
      createdAt: medication.createdAt,
      reminderAt: nextDueAt,
      reminderKind: TimelineReminderKind.medicationConsumption,
      medicationName: medication.medicationName,
      medicationAmount: medication.medicationAmount,
      medicationUnit: medication.medicationUnit,
      medicationInterval: medication.medicationInterval,
      scheduledAt: medication.scheduledAt,
      actualTakenAt: takenAt,
    );
    final repository = _MemoryTimelineRepository([subject, medication]);
    final recorder = _FakeMedicationRecorder(updated, repository);
    final scheduler = _FakeReminderScheduler();

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TrackedSubjectDetail(
            subject: subject,
            loadFollowUps: LoadTimelineFollowUps(repository: repository),
            addFollowUp: AddTimelineFollowUp(
              repository: repository,
              clock: () => scheduledAt,
              idGenerator: () => 'unused',
            ),
            editTimelineItem: EditTimelineItem(repository: repository),
            reminderScheduler: scheduler,
            recordMedicationConsumption: recorder,
            clock: () => takenAt,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final action = find.byKey(const Key('follow-up-medication-take-med-1'));
    expect(action, findsOneWidget);

    await tester.tap(action);
    await tester.pumpAndSettle();

    expect(recorder.receivedReminder?.id, medication.id);
    expect(recorder.receivedReminder?.scheduledAt, scheduledAt);
    expect(repository.items.singleWhere((item) => item.id == medication.id).actualTakenAt, takenAt);
    expect(repository.items.singleWhere((item) => item.id == medication.id).reminderAt, nextDueAt);
    expect(scheduler.scheduledItem?.id, medication.id);
    expect(scheduler.scheduledItem?.reminderAt, nextDueAt);
    expect(find.text('مصرف ثبت شد و نوبت بعدی زمان‌بندی شد.'), findsOneWidget);
  });
}
