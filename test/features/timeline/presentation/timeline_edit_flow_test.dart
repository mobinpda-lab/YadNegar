import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(TimelineItem seed) : _items = {seed.id: seed};

  final Map<String, TimelineItem> _items;

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

void main() {
  testWidgets('item tap edits text and reloads Timeline', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'item-1',
        type: TimelineItemType.note,
        text: 'متن قبلی',
        createdAt: createdAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => createdAt,
              idGenerator: () => 'capture-unused',
            ),
            loadTimeline: LoadTimeline(repository: repository),
            editTimelineItem: EditTimelineItem(repository: repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('متن قبلی'), findsOneWidget);
    await tester.tap(find.byKey(const Key('timeline-item-item-1')));
    await tester.pumpAndSettle();

    expect(find.text('ویرایش یادداشت'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('timeline-edit-input')),
      '  متن جدید  ',
    );
    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    expect(find.text('متن جدید'), findsOneWidget);
    expect(find.text('متن قبلی'), findsNothing);

    final updated = await repository.findById('item-1');
    expect(updated, isNotNull);
    expect(updated!.text, 'متن جدید');
    expect(updated.id, 'item-1');
    expect(updated.type, TimelineItemType.note);
    expect(updated.createdAt, createdAt);
  });

  testWidgets('Event edit can replace occurredAt and reload Timeline', (tester) async {
    final createdAt = DateTime(2026, 8, 26, 18);
    final originalOccurredAt = DateTime(2026, 8, 27, 9);
    final replacementOccurredAt = DateTime(2026, 8, 28, 10, 30);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'جلسه تیم',
        createdAt: createdAt,
        occurredAt: originalOccurredAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => createdAt,
              idGenerator: () => 'capture-unused',
            ),
            loadTimeline: LoadTimeline(repository: repository),
            editTimelineItem: EditTimelineItem(repository: repository),
            occurredAtPicker: (context, initialDateTime) async {
              expect(initialDateTime, originalOccurredAt);
              return replacementOccurredAt;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-event-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('timeline-edit-occurred-at')), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-edit-occurred-at')));
    await tester.pumpAndSettle();
    expect(find.text('2026/08/28 - 10:30'), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    final updated = await repository.findById('event-1');
    expect(updated, isNotNull);
    expect(updated!.occurredAt, replacementOccurredAt);
    expect(updated.createdAt, createdAt);
    expect(updated.text, 'جلسه تیم');
    expect(find.textContaining('زمان رخداد: 2026/08/28 - 10:30'), findsOneWidget);
  });

  testWidgets('Activity edit can clear occurredAt', (tester) async {
    final createdAt = DateTime(2026, 8, 26, 18);
    final occurredAt = DateTime(2026, 8, 27, 7, 45);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'activity-1',
        type: TimelineItemType.activity,
        text: 'ورزش صبحگاهی',
        createdAt: createdAt,
        occurredAt: occurredAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => createdAt,
            idGenerator: () => 'capture-unused',
          ),
          loadTimeline: LoadTimeline(repository: repository),
          editTimelineItem: EditTimelineItem(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-activity-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('timeline-edit-occurred-at-clear')), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-edit-occurred-at-clear')));
    await tester.pumpAndSettle();
    expect(find.text('تاریخ و زمان (اختیاری)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    final updated = await repository.findById('activity-1');
    expect(updated, isNotNull);
    expect(updated!.occurredAt, isNull);
    expect(updated.createdAt, createdAt);
    expect(find.textContaining('زمان ثبت: 2026/08/26 - 18:00'), findsOneWidget);
  });

  testWidgets('Note can change to Event and select occurredAt', (tester) async {
    final createdAt = DateTime(2026, 8, 26, 18);
    final occurredAt = DateTime(2026, 8, 29, 14, 20);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'note-to-event',
        type: TimelineItemType.note,
        text: 'قرار مهم',
        createdAt: createdAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => createdAt,
              idGenerator: () => 'capture-unused',
            ),
            loadTimeline: LoadTimeline(repository: repository),
            editTimelineItem: EditTimelineItem(repository: repository),
            occurredAtPicker: (context, initialDateTime) async => occurredAt,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-note-to-event')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-type')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('رویداد').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-edit-occurred-at')), findsOneWidget);
    await tester.tap(find.byKey(const Key('timeline-edit-occurred-at')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    final updated = await repository.findById('note-to-event');
    expect(updated, isNotNull);
    expect(updated!.type, TimelineItemType.event);
    expect(updated.occurredAt, occurredAt);
    expect(find.text('رویداد'), findsOneWidget);
  });

  testWidgets('Event changing to Idea clears occurredAt', (tester) async {
    final createdAt = DateTime(2026, 8, 26, 18);
    final occurredAt = DateTime(2026, 8, 27, 9);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'event-to-idea',
        type: TimelineItemType.event,
        text: 'ایده محصول',
        createdAt: createdAt,
        occurredAt: occurredAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => createdAt,
            idGenerator: () => 'capture-unused',
          ),
          loadTimeline: LoadTimeline(repository: repository),
          editTimelineItem: EditTimelineItem(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-event-to-idea')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-type')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ایده').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-edit-occurred-at')), findsNothing);
    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    final updated = await repository.findById('event-to-idea');
    expect(updated, isNotNull);
    expect(updated!.type, TimelineItemType.idea);
    expect(updated.occurredAt, isNull);
    expect(find.textContaining('زمان ثبت: 2026/08/26 - 18:00'), findsOneWidget);
  });

  testWidgets('empty edit keeps item unchanged and shows feedback', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'item-1',
        type: TimelineItemType.note,
        text: 'متن قبلی',
        createdAt: createdAt,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => createdAt,
            idGenerator: () => 'capture-unused',
          ),
          loadTimeline: LoadTimeline(repository: repository),
          editTimelineItem: EditTimelineItem(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-item-1')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('timeline-edit-input')), '   ');
    await tester.tap(find.byKey(const Key('timeline-edit-save')));
    await tester.pumpAndSettle();

    expect(find.text('متن ویرایش نمی‌تواند خالی باشد.'), findsOneWidget);
    expect(find.text('متن قبلی'), findsOneWidget);
    final unchanged = await repository.findById('item-1');
    expect(unchanged!.text, 'متن قبلی');
  });
}
