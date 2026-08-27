import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  final List<TimelineItem> items;

  @override
  Future<bool> deleteById(String id) async => false;

  @override
  Future<TimelineItem?> findById(String id) async {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async => List.of(items);

  @override
  Future<void> upsert(TimelineItem item) async {}
}

TimelineItem _item({
  required String id,
  required TimelineItemType type,
  required String text,
  required int hour,
}) {
  return TimelineItem(
    id: id,
    type: type,
    text: text,
    createdAt: DateTime.utc(2026, 8, 27, hour),
  );
}

Widget _buildApp(_MemoryTimelineRepository repository) {
  return MaterialApp(
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: TimelineHome(
        quickCapture: QuickCapture(
          repository: repository,
          clock: () => DateTime.utc(2026, 8, 27, 20),
          idGenerator: () => 'new-item',
        ),
        loadTimeline: LoadTimeline(repository: repository),
        searchTimeline: SearchTimeline(repository: repository),
      ),
    ),
  );
}

void main() {
  testWidgets('all types clears only type filter and keeps search query',
      (tester) async {
    final repository = _MemoryTimelineRepository([
      _item(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'جلسه پروژه',
        hour: 19,
      ),
      _item(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'جلسه یادداشت',
        hour: 18,
      ),
      _item(
        id: 'idea-1',
        type: TimelineItemType.idea,
        text: 'ایده سفر',
        hour: 17,
      ),
    ]);

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('timeline-search-input')),
      'جلسه',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-event-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-note-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-idea-1')), findsNothing);

    await tester.tap(find.byKey(const Key('timeline-type-filter')));
    await tester.pumpAndSettle();
    expect(find.text('همه انواع'), findsWidgets);
    await tester.tap(find.text('رویداد').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-event-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-note-1')), findsNothing);
    expect(find.byKey(const Key('timeline-item-idea-1')), findsNothing);

    await tester.tap(find.byKey(const Key('timeline-type-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('همه انواع').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-item-event-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-note-1')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-idea-1')), findsNothing);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('timeline-search-input')))
          .controller!
          .text,
      'جلسه',
    );
  });
}
