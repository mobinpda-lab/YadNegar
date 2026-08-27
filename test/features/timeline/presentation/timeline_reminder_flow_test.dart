import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/restore_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

void main() {
  testWidgets('Quick Capture persists before scheduling a Persian reminder',
      (tester) async {
    final repository = _MemoryTimelineRepository();
    final scheduler = _RecordingReminderScheduler(repository);
    final createdAt = DateTime(2026, 8, 27, 10);
    final reminderAt = DateTime(2030, 1, 2, 9, 30);

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        scheduler: scheduler,
        createdAt: createdAt,
        id: 'reminder-quick-1',
        reminderAtPicker: (context, initialDateTime) async => reminderAt,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    expect(find.text('یادآور (اختیاری)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('quick-capture-reminder-at')));
    await tester.pumpAndSettle();
    expect(find.text('2030/01/02 - 09:30'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'پیگیری قرارداد',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('reminder-quick-1');
    expect(stored, isNotNull);
    expect(stored!.reminderAt, reminderAt);
    expect(stored.reminderRecurrence, TimelineReminderRecurrence.none);
    expect(scheduler.scheduledIds, <String>['reminder-quick-1']);
    expect(scheduler.persistenceWasVisibleAtSchedule, isTrue);
    expect(scheduler.persistenceRecurrenceWasVisibleAtSchedule, isTrue);
  });

  testWidgets('Quick Capture persists daily recurrence before scheduling',
      (tester) async {
    final repository = _MemoryTimelineRepository();
    final scheduler = _RecordingReminderScheduler(repository);
    final reminderAt = DateTime(2030, 2, 3, 7, 45);

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        scheduler: scheduler,
        createdAt: DateTime(2026, 8, 27, 10),
        id: 'reminder-daily-1',
        reminderAtPicker: (context, initialDateTime) async => reminderAt,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick-capture-reminder-at')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('quick-capture-reminder-recurrence')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('روزانه').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'مرور روزانه',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('reminder-daily-1');
    expect(stored, isNotNull);
    expect(stored!.reminderAt, reminderAt);
    expect(stored.reminderRecurrence, TimelineReminderRecurrence.daily);
    expect(scheduler.lastScheduledRecurrence, TimelineReminderRecurrence.daily);
    expect(scheduler.persistenceWasVisibleAtSchedule, isTrue);
    expect(scheduler.persistenceRecurrenceWasVisibleAtSchedule, isTrue);
  });

  testWidgets('Edit can clear reminder and cancels only after durable save',
      (tester) async {
    final reminderAt = DateTime(2030, 1, 3, 8);
    final seed = TimelineItem(
      id: 'reminder-edit-1',
      type: TimelineItemType.note,
      text: 'کار دارای یادآور',
      createdAt: DateTime(2026, 8, 27, 10),
      reminderAt: reminderAt,
      reminderRecurrence: TimelineReminderRecurrence.daily,
    );
    final repository = _MemoryTimelineRepository(<TimelineItem>[seed]);
    final scheduler = _RecordingReminderScheduler(repository);

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        scheduler: scheduler,
        createdAt: seed.createdAt,
        id: 'unused',
        withEdit: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-reminder-edit-1')));
    await tester.pumpAndSettle();
    expect(find.text('2030/01/03 - 08:00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-edit-reminder-at-clear')));
    await tester.pumpAndSettle();
    expect(find.text('یادآور (اختیاری)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById(seed.id);
    expect(stored, isNotNull);
    expect(stored!.reminderAt, isNull);
    expect(stored.reminderRecurrence, TimelineReminderRecurrence.none);
    expect(scheduler.cancelledIds, <String>[seed.id]);
    expect(scheduler.persistenceWasVisibleAtCancel, isTrue);
  });

  testWidgets('Edit persists weekly recurrence before rescheduling',
      (tester) async {
    final seed = TimelineItem(
      id: 'reminder-edit-weekly',
      type: TimelineItemType.note,
      text: 'پیگیری دوره‌ای',
      createdAt: DateTime(2026, 8, 27, 10),
      reminderAt: DateTime(2030, 3, 4, 16, 15),
      reminderRecurrence: TimelineReminderRecurrence.daily,
    );
    final repository = _MemoryTimelineRepository(<TimelineItem>[seed]);
    final scheduler = _RecordingReminderScheduler(repository);

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        scheduler: scheduler,
        createdAt: seed.createdAt,
        id: 'unused',
        withEdit: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-reminder-edit-weekly')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-reminder-recurrence')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('هفتگی').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById(seed.id);
    expect(stored, isNotNull);
    expect(stored!.reminderRecurrence, TimelineReminderRecurrence.weekly);
    expect(scheduler.lastScheduledRecurrence, TimelineReminderRecurrence.weekly);
    expect(scheduler.persistenceRecurrenceWasVisibleAtSchedule, isTrue);
  });

  testWidgets('editing text reschedules existing reminder with fresh body data',
      (tester) async {
    final seed = TimelineItem(
      id: 'reminder-edit-text',
      type: TimelineItemType.note,
      text: 'متن قدیمی',
      createdAt: DateTime(2026, 8, 27, 10),
      reminderAt: DateTime(2030, 1, 4, 11),
    );
    final repository = _MemoryTimelineRepository(<TimelineItem>[seed]);
    final scheduler = _RecordingReminderScheduler(repository);

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        scheduler: scheduler,
        createdAt: seed.createdAt,
        id: 'unused',
        withEdit: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-reminder-edit-text')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('timeline-edit-input')),
      'متن جدید اعلان',
    );
    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    expect(scheduler.scheduledIds, <String>[seed.id]);
    expect(scheduler.lastScheduledText, 'متن جدید اعلان');
    expect(scheduler.persistenceWasVisibleAtSchedule, isTrue);
  });

  testWidgets('permission denial keeps saved reminder and shows Persian feedback',
      (tester) async {
    final repository = _MemoryTimelineRepository();
    final scheduler = _RecordingReminderScheduler(repository)
      ..scheduleResult = TimelineReminderScheduleResult.permissionDenied;
    final reminderAt = DateTime(2030, 1, 5, 12);

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        scheduler: scheduler,
        createdAt: DateTime(2026, 8, 27, 10),
        id: 'permission-denied-1',
        reminderAtPicker: (context, initialDateTime) async => reminderAt,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick-capture-reminder-at')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'ذخیره حتی بدون مجوز',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('permission-denied-1');
    expect(stored, isNotNull);
    expect(stored!.reminderAt, reminderAt);
    expect(
      find.text('مورد ذخیره شد، اما اجازه نمایش اعلان یادآور داده نشد.'),
      findsOneWidget,
    );
  });

  testWidgets('delete cancels reminder and Undo reschedules the restored item',
      (tester) async {
    final seed = TimelineItem(
      id: 'reminder-delete-1',
      type: TimelineItemType.note,
      text: 'کار قابل بازگردانی',
      createdAt: DateTime(2026, 8, 27, 10),
      reminderAt: DateTime(2030, 1, 6, 13),
      reminderRecurrence: TimelineReminderRecurrence.weekly,
    );
    final repository = _MemoryTimelineRepository(<TimelineItem>[seed]);
    final scheduler = _RecordingReminderScheduler(repository);

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        scheduler: scheduler,
        createdAt: seed.createdAt,
        id: 'unused',
        withEdit: true,
        withDeleteUndo: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-reminder-delete-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-delete-confirm')));
    await tester.pumpAndSettle();

    expect(await repository.findById(seed.id), isNull);
    expect(scheduler.cancelledIds, <String>[seed.id]);

    await tester.tap(find.text('بازگردانی'));
    await tester.pumpAndSettle();

    expect(await repository.findById(seed.id), isNotNull);
    expect(scheduler.scheduledIds, <String>[seed.id]);
    expect(scheduler.lastScheduledRecurrence, TimelineReminderRecurrence.weekly);
  });
}

Widget _buildApp({
  required _MemoryTimelineRepository repository,
  required _RecordingReminderScheduler scheduler,
  required DateTime createdAt,
  required String id,
  TimelineReminderAtPicker? reminderAtPicker,
  bool withEdit = false,
  bool withDeleteUndo = false,
}) {
  return MaterialApp(
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: TimelineHome(
        quickCapture: QuickCapture(
          repository: repository,
          clock: () => createdAt,
          idGenerator: () => id,
        ),
        loadTimeline: LoadTimeline(repository: repository),
        editTimelineItem: withEdit ? EditTimelineItem(repository: repository) : null,
        deleteTimelineItem:
            withDeleteUndo ? DeleteTimelineItem(repository: repository) : null,
        restoreTimelineItem:
            withDeleteUndo ? RestoreTimelineItem(repository: repository) : null,
        reminderAtPicker: reminderAtPicker,
        reminderScheduler: scheduler,
      ),
    ),
  );
}

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository([Iterable<TimelineItem> seed = const <TimelineItem>[]]) {
    for (final item in seed) {
      _items[item.id] = item;
    }
  }

  final Map<String, TimelineItem> _items = <String, TimelineItem>{};

  @override
  Future<bool> deleteById(String id) async => _items.remove(id) != null;

  @override
  Future<TimelineItem?> findById(String id) async => _items[id];

  @override
  Future<List<TimelineItem>> listNewestFirst() async {
    final items = _items.values.toList();
    items.sort((left, right) => right.timelineAt.compareTo(left.timelineAt));
    return items;
  }

  @override
  Future<void> upsert(TimelineItem item) async {
    _items[item.id] = item;
  }
}

class _RecordingReminderScheduler implements TimelineReminderScheduler {
  _RecordingReminderScheduler(this.repository);

  final TimelineRepository repository;
  TimelineReminderScheduleResult scheduleResult =
      TimelineReminderScheduleResult.scheduled;
  final List<String> scheduledIds = <String>[];
  final List<String> cancelledIds = <String>[];
  bool persistenceWasVisibleAtSchedule = false;
  bool persistenceRecurrenceWasVisibleAtSchedule = false;
  bool persistenceWasVisibleAtCancel = false;
  String? lastScheduledText;
  TimelineReminderRecurrence? lastScheduledRecurrence;

  @override
  Future<TimelineReminderScheduleResult> schedule(TimelineItem item) async {
    final persisted = await repository.findById(item.id);
    persistenceWasVisibleAtSchedule = persisted?.reminderAt == item.reminderAt;
    persistenceRecurrenceWasVisibleAtSchedule =
        persisted?.reminderRecurrence == item.reminderRecurrence;
    scheduledIds.add(item.id);
    lastScheduledText = item.text;
    lastScheduledRecurrence = item.reminderRecurrence;
    return scheduleResult;
  }

  @override
  Future<void> cancel(String timelineItemId) async {
    final persisted = await repository.findById(timelineItemId);
    persistenceWasVisibleAtCancel =
        persisted == null || persisted.reminderAt == null;
    cancelledIds.add(timelineItemId);
  }

  @override
  Future<void> reconcile(Iterable<TimelineItem> items) async {}
}
