import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/restore_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

void main() {
  testWidgets('undo refuses to overwrite an item that reused the deleted id', (
    tester,
  ) async {
    final original = TimelineItem(
      id: 'shared-id',
      type: TimelineItemType.note,
      text: 'نسخه حذف‌شده',
      createdAt: DateTime.utc(2026, 8, 27, 8),
    );
    final repository = _MemoryTimelineRepository(original);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => DateTime.utc(2026, 8, 27, 9),
              idGenerator: () => 'capture-unused',
            ),
            loadTimeline: LoadTimeline(repository: repository),
            editTimelineItem: EditTimelineItem(repository: repository),
            deleteTimelineItem: DeleteTimelineItem(repository: repository),
            restoreTimelineItem: RestoreTimelineItem(repository: repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-item-shared-id')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-delete-confirm')));
    await tester.pumpAndSettle();

    final replacement = TimelineItem(
      id: 'shared-id',
      type: TimelineItemType.idea,
      text: 'نسخه جدیدتر',
      createdAt: DateTime.utc(2026, 8, 27, 10),
    );
    await repository.upsert(replacement);

    await tester.tap(find.text('بازگردانی'));
    await tester.pumpAndSettle();

    final stored = await repository.findById('shared-id');
    expect(stored, same(replacement));
    expect(stored!.text, 'نسخه جدیدتر');
    expect(stored.type, TimelineItemType.idea);
    expect(find.text('این مورد دیگر قابل بازگردانی نیست.'), findsOneWidget);
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
