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
