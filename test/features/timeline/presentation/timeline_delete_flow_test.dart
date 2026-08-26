import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

void main() {
  testWidgets('delete requires confirmation and removes item after confirmation', (
    tester,
  ) async {
    final createdAt = DateTime(2026, 8, 27, 8);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'delete-me',
        type: TimelineItemType.note,
        text: 'برای حذف',
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
            deleteTimelineItem: DeleteTimelineItem(repository: repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-delete-me')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();

    expect(find.text('حذف این مورد؟'), findsOneWidget);
    expect(await repository.findById('delete-me'), isNotNull);

    await tester.tap(find.byKey(const Key('timeline-delete-confirm')));
    await tester.pumpAndSettle();

    expect(await repository.findById('delete-me'), isNull);
    expect(find.text('برای حذف'), findsNothing);
    expect(find.byKey(const Key('timeline-empty-state')), findsOneWidget);
    expect(find.text('مورد حذف شد.'), findsOneWidget);
  });

  testWidgets('cancelling delete keeps the item', (tester) async {
    final createdAt = DateTime(2026, 8, 27, 8);
    final repository = _MemoryTimelineRepository(
      TimelineItem(
        id: 'keep-me',
        type: TimelineItemType.idea,
        text: 'باقی بماند',
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
          deleteTimelineItem: DeleteTimelineItem(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-keep-me')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('انصراف').last);
    await tester.pumpAndSettle();

    expect(await repository.findById('keep-me'), isNotNull);
    expect(find.text('باقی بماند'), findsWidgets);
  });
}

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(TimelineItem seed) : _items = {seed.id: seed};

  final Map<String, TimelineItem> _items;

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
