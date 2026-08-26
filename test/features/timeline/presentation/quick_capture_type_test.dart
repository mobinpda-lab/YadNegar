import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  final Map<String, TimelineItem> _items = <String, TimelineItem>{};

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

Widget _buildApp({
  required _MemoryTimelineRepository repository,
  required DateTime createdAt,
  required String id,
  TimelineOccurredAtPicker? occurredAtPicker,
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
        occurredAtPicker: occurredAtPicker,
      ),
    ),
  );
}

Future<void> _selectType(
  WidgetTester tester,
  String label,
) async {
  await tester.tap(find.byKey(const Key('quick-capture-type')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Quick Capture can persist and render an Idea item', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18, 45);
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        createdAt: createdAt,
        id: 'idea-1',
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();

    expect(find.text('یادداشت'), findsOneWidget);
    expect(find.byKey(const Key('quick-capture-occurred-at')), findsNothing);

    await _selectType(tester, 'ایده');

    expect(find.byKey(const Key('quick-capture-occurred-at')), findsNothing);

    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      '  ایده برای صفحه جستجو  ',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    expect(find.text('ایده برای صفحه جستجو'), findsOneWidget);
    expect(find.text('ایده'), findsOneWidget);

    final stored = await repository.findById('idea-1');
    expect(stored, isNotNull);
    expect(stored!.type, TimelineItemType.idea);
    expect(stored.text, 'ایده برای صفحه جستجو');
    expect(stored.createdAt, createdAt);
    expect(stored.occurredAt, isNull);
  });

  testWidgets('Quick Capture keeps Note as the default type', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18, 45);
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        createdAt: createdAt,
        id: 'note-1',
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quick-capture-occurred-at')), findsNothing);

    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'یادداشت سریع',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('note-1');
    expect(stored, isNotNull);
    expect(stored!.type, TimelineItemType.note);
    expect(stored.occurredAt, isNull);
    expect(find.text('یادداشت'), findsOneWidget);
  });

  testWidgets('Event can persist an optional occurredAt from Quick Capture',
      (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18, 45);
    final occurredAt = DateTime.utc(2026, 8, 28, 9, 30);
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        createdAt: createdAt,
        id: 'event-1',
        occurredAtPicker: (context, initialDateTime) async => occurredAt,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await _selectType(tester, 'رویداد');

    expect(find.byKey(const Key('quick-capture-occurred-at')), findsOneWidget);
    expect(find.text('تاریخ و زمان (اختیاری)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('quick-capture-occurred-at')));
    await tester.pumpAndSettle();

    expect(find.text('2026/08/28 - 09:30'), findsOneWidget);
    expect(
      find.byKey(const Key('quick-capture-occurred-at-clear')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'جلسه پروژه',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('event-1');
    expect(stored, isNotNull);
    expect(stored!.type, TimelineItemType.event);
    expect(stored.createdAt, createdAt);
    expect(stored.occurredAt, occurredAt);
    expect(stored.timelineAt, occurredAt);
  });

  testWidgets('Activity can clear occurredAt before saving', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18, 45);
    final occurredAt = DateTime.utc(2026, 8, 27, 7, 15);
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        createdAt: createdAt,
        id: 'activity-1',
        occurredAtPicker: (context, initialDateTime) async => occurredAt,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await _selectType(tester, 'فعالیت');

    expect(find.byKey(const Key('quick-capture-occurred-at')), findsOneWidget);

    await tester.tap(find.byKey(const Key('quick-capture-occurred-at')));
    await tester.pumpAndSettle();
    expect(find.text('2026/08/27 - 07:15'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('quick-capture-occurred-at-clear')),
    );
    await tester.pumpAndSettle();
    expect(find.text('تاریخ و زمان (اختیاری)'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'ورزش صبحگاهی',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('activity-1');
    expect(stored, isNotNull);
    expect(stored!.type, TimelineItemType.activity);
    expect(stored.occurredAt, isNull);
  });

  testWidgets('switching from Event to Idea drops hidden occurredAt state',
      (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18, 45);
    final occurredAt = DateTime.utc(2026, 8, 28, 9, 30);
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(
      _buildApp(
        repository: repository,
        createdAt: createdAt,
        id: 'idea-after-event',
        occurredAtPicker: (context, initialDateTime) async => occurredAt,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await _selectType(tester, 'رویداد');
    await tester.tap(find.byKey(const Key('quick-capture-occurred-at')));
    await tester.pumpAndSettle();

    await _selectType(tester, 'ایده');
    expect(find.byKey(const Key('quick-capture-occurred-at')), findsNothing);

    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'ایده بدون تاریخ',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('idea-after-event');
    expect(stored, isNotNull);
    expect(stored!.type, TimelineItemType.idea);
    expect(stored.occurredAt, isNull);
  });
}
