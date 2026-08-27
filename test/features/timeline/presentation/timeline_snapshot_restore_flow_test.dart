import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_snapshot_restore_action.dart';

void main() {
  testWidgets('successful restore reloads while preserving active search', (
    tester,
  ) async {
    final repository = _MemoryTimelineRepository(<TimelineItem>[
      _item('old-target', 'هدف قدیمی', 10),
      _item('old-other', 'مورد دیگر', 9),
    ]);
    var restoreCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => DateTime.utc(2026, 8, 27, 12),
            idGenerator: () => 'generated',
          ),
          loadTimeline: LoadTimeline(repository: repository),
          searchTimeline: SearchTimeline(repository: repository),
          restoreTimelineSnapshot: () async {
            restoreCalls++;
            repository.items = <TimelineItem>[
              _item('new-target', 'هدف بازیابی‌شده', 12),
              _item('new-other', 'مورد دیگر جدید', 11),
            ];
            return TimelineSnapshotRestoreResult.restored;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('timeline-search-input')),
      'هدف',
    );
    await tester.pumpAndSettle();
    expect(find.text('هدف قدیمی'), findsOneWidget);
    expect(find.text('مورد دیگر'), findsNothing);

    await tester.tap(find.byKey(const Key('timeline-restore-action')));
    await tester.pumpAndSettle();
    expect(find.text('بازیابی فایل پشتیبان؟'), findsOneWidget);

    await tester.tap(find.byKey(const Key('timeline-restore-confirm')));
    await tester.pumpAndSettle();

    expect(restoreCalls, 1);
    expect(find.text('هدف بازیابی‌شده'), findsOneWidget);
    expect(find.text('مورد دیگر جدید'), findsNothing);
    expect(find.text('فایل پشتیبان با موفقیت بازیابی شد.'), findsOneWidget);
    final searchField = tester.widget<TextField>(
      find.byKey(const Key('timeline-search-input')),
    );
    expect(searchField.controller?.text, 'هدف');
  });

  testWidgets('restore confirmation can be cancelled without invoking action', (
    tester,
  ) async {
    final repository = _MemoryTimelineRepository(<TimelineItem>[
      _item('existing', 'موجود', 10),
    ]);
    var restoreCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => DateTime.utc(2026, 8, 27, 12),
            idGenerator: () => 'generated',
          ),
          loadTimeline: LoadTimeline(repository: repository),
          restoreTimelineSnapshot: () async {
            restoreCalls++;
            return TimelineSnapshotRestoreResult.restored;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-restore-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-restore-cancel')));
    await tester.pumpAndSettle();

    expect(restoreCalls, 0);
    expect(find.text('موجود'), findsOneWidget);
  });

  testWidgets('unsupported backup reports a specific Persian message', (
    tester,
  ) async {
    final repository = _MemoryTimelineRepository(<TimelineItem>[
      _item('existing', 'موجود', 10),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: TimelineHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: () => DateTime.utc(2026, 8, 27, 12),
            idGenerator: () => 'generated',
          ),
          loadTimeline: LoadTimeline(repository: repository),
          restoreTimelineSnapshot: () async =>
              TimelineSnapshotRestoreResult.unsupportedSchema,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeline-restore-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeline-restore-confirm')));
    await tester.pumpAndSettle();

    expect(find.text('نسخه این فایل پشتیبان پشتیبانی نمی‌شود.'), findsOneWidget);
    expect(find.text('موجود'), findsOneWidget);
  });
}

TimelineItem _item(String id, String text, int hour) => TimelineItem(
      id: id,
      type: TimelineItemType.note,
      text: text,
      createdAt: DateTime.utc(2026, 8, 27, hour),
    );

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  List<TimelineItem> items;

  @override
  Future<bool> deleteById(String id) async {
    final before = items.length;
    items.removeWhere((item) => item.id == id);
    return items.length != before;
  }

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
  Future<List<TimelineItem>> listNewestFirst() async =>
      List<TimelineItem>.unmodifiable(items);

  @override
  Future<void> upsert(TimelineItem item) async {
    final index = items.indexWhere((candidate) => candidate.id == item.id);
    if (index == -1) {
      items = <TimelineItem>[item, ...items];
    } else {
      final updated = List<TimelineItem>.from(items);
      updated[index] = item;
      items = updated;
    }
  }
}
