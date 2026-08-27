import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_item_type_presentation.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

class _MemoryTimelineRepository implements TimelineRepository {
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

const _expected = <TimelineItemType, ({String label, IconData icon})>{
  TimelineItemType.note: (label: 'یادداشت', icon: Icons.note_outlined),
  TimelineItemType.event: (label: 'رویداد', icon: Icons.event_outlined),
  TimelineItemType.call: (label: 'تماس', icon: Icons.call_outlined),
  TimelineItemType.idea: (label: 'ایده', icon: Icons.lightbulb_outline),
  TimelineItemType.activity: (
    label: 'فعالیت',
    icon: Icons.check_circle_outline,
  ),
};

void _expectOpenTypeOptions() {
  for (final entry in _expected.entries) {
    expect(timelineItemTypeLabel(entry.key), entry.value.label);
    expect(timelineItemTypeIcon(entry.key), entry.value.icon);
    expect(
      find.byKey(Key('timeline-type-option-${entry.key.name}-icon')),
      findsWidgets,
    );
    expect(find.text(entry.value.label), findsWidgets);
  }
}

Widget _buildHome(_MemoryTimelineRepository repository) {
  return MaterialApp(
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: TimelineHome(
        quickCapture: QuickCapture(
          repository: repository,
          clock: () => DateTime.utc(2026, 8, 27, 17),
          idGenerator: () => 'new-item',
        ),
        loadTimeline: LoadTimeline(repository: repository),
        editTimelineItem: EditTimelineItem(repository: repository),
      ),
    ),
  );
}

void main() {
  testWidgets('Timeline type filter exposes shared icons and labels',
      (tester) async {
    final searchController = TextEditingController();
    addTearDown(searchController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineScreen(
            searchController: searchController,
            onSearchChanged: (_) {},
            onTypeFilterChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('timeline-type-filter')));
    await tester.pumpAndSettle();

    _expectOpenTypeOptions();
  });

  testWidgets('Quick Capture type selector reuses shared type options',
      (tester) async {
    final repository = _MemoryTimelineRepository();

    await tester.pumpWidget(_buildHome(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick-capture-type')));
    await tester.pumpAndSettle();

    _expectOpenTypeOptions();
  });

  testWidgets('Edit type selector reuses shared type options', (tester) async {
    final repository = _MemoryTimelineRepository();
    await repository.upsert(
      TimelineItem(
        id: 'edit-item',
        type: TimelineItemType.idea,
        text: 'مورد قابل ویرایش',
        createdAt: DateTime.utc(2026, 8, 27, 16),
      ),
    );

    await tester.pumpWidget(_buildHome(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('مورد قابل ویرایش'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-edit-type')));
    await tester.pumpAndSettle();

    _expectOpenTypeOptions();
  });
}
