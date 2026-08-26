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

void main() {
  testWidgets('Quick Capture can persist and render an Idea item', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18, 45);
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => createdAt,
              idGenerator: () => 'idea-1',
            ),
            loadTimeline: LoadTimeline(repository: repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();

    expect(find.text('یادداشت'), findsOneWidget);
    await tester.tap(find.byKey(const Key('quick-capture-type')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ایده').last);
    await tester.pumpAndSettle();

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
  });

  testWidgets('Quick Capture keeps Note as the default type', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 18, 45);
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => createdAt,
            idGenerator: () => 'note-1',
          ),
          loadTimeline: LoadTimeline(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      'یادداشت سریع',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    final stored = await repository.findById('note-1');
    expect(stored, isNotNull);
    expect(stored!.type, TimelineItemType.note);
    expect(find.text('یادداشت'), findsOneWidget);
  });
}
