import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';

void main() {
  late Directory tempDirectory;
  late File storageFile;
  late JsonFileTimelineRepository repository;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync('yadnegar_vertical_slice_');
    storageFile = File('${tempDirectory.path}/timeline.json');
    repository = JsonFileTimelineRepository(storageFile);
  });

  tearDown(() {
    if (tempDirectory.existsSync()) {
      tempDirectory.deleteSync(recursive: true);
    }
  });

  testWidgets('Quick Capture persists to disk and renders in Timeline', (tester) async {
    final createdAt = DateTime.utc(2026, 8, 26, 17);
    final quickCapture = QuickCapture(
      repository: repository,
      clock: () => createdAt,
      idGenerator: () => 'capture-1',
    );
    final loadTimeline = LoadTimeline(repository: repository);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: quickCapture,
            loadTimeline: loadTimeline,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-empty-state')), findsOneWidget);

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('quick-capture-input')),
      '  خرید شیر  ',
    );
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timeline-list')), findsOneWidget);
    expect(find.byKey(const Key('timeline-item-capture-1')), findsOneWidget);
    expect(find.text('خرید شیر'), findsOneWidget);
    expect(find.text('یادداشت'), findsOneWidget);
    expect(storageFile.existsSync(), isTrue);

    final persisted = await repository.findById('capture-1');
    expect(persisted, isNotNull);
    expect(persisted!.text, 'خرید شیر');
    expect(persisted.type, TimelineItemType.note);
    expect(persisted.createdAt, createdAt);

    final reloadedRepository = JsonFileTimelineRepository(storageFile);
    final reloadedItems = await reloadedRepository.listNewestFirst();
    expect(reloadedItems, hasLength(1));
    expect(reloadedItems.single.id, 'capture-1');
    expect(reloadedItems.single.text, 'خرید شیر');
  });

  testWidgets('empty Quick Capture stays on the empty Timeline', (tester) async {
    final quickCapture = QuickCapture(
      repository: repository,
      clock: () => DateTime.utc(2026, 8, 26, 17),
      idGenerator: () => 'capture-1',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TimelineHome(
            quickCapture: quickCapture,
            loadTimeline: LoadTimeline(repository: repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('quick-capture-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick-capture-save')));
    await tester.pumpAndSettle();

    expect(find.text('متن ثبت سریع نمی‌تواند خالی باشد.'), findsOneWidget);
    expect(find.byKey(const Key('timeline-empty-state')), findsOneWidget);
    expect(await repository.listNewestFirst(), isEmpty);
  });
}
