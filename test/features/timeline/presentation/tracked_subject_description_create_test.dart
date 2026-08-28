import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/load_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_home.dart';
import 'package:yadnegar/main.dart';

void main() {
  testWidgets('create flow persists optional description at narrow Android width', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _MemoryRepository();
    DateTime clock() => DateTime(2026, 8, 28, 14);

    await tester.pumpWidget(
      YadNegarApp(
        home: TrackedSubjectHome(
          quickCapture: QuickCapture(
            repository: repository,
            clock: clock,
            idGenerator: () => 'new-root',
          ),
          loadSubjects: LoadTrackedSubjects(repository: repository),
          loadFollowUps: LoadTimelineFollowUps(repository: repository),
          addFollowUp: AddTimelineFollowUp(
            repository: repository,
            clock: clock,
            idGenerator: () => 'new-follow-up',
          ),
          editTimelineItem: EditTimelineItem(repository: repository),
          clock: clock,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.takeException(),
      isNull,
      reason: 'initial tracked-task Home must fit at 320px',
    );

    await tester.tap(find.byKey(const Key('tracked-subject-add')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tracked-subject-description-input')), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'new tracked-task dialog must fit at 320px',
    );

    await tester.enterText(
      find.byKey(const Key('tracked-subject-input')),
      'پیگیری قرارداد',
    );
    await tester.enterText(
      find.byKey(const Key('tracked-subject-description-input')),
      '  خلاصه قرارداد و اقدام بعدی  ',
    );
    await tester.pump();
    expect(
      tester.takeException(),
      isNull,
      reason: 'filled tracked-task dialog must fit at 320px',
    );

    await tester.ensureVisible(find.byKey(const Key('tracked-subject-save')));
    await tester.tap(find.byKey(const Key('tracked-subject-save')));
    await tester.pumpAndSettle();

    final saved = await repository.findById('new-root');
    expect(saved, isNotNull);
    expect(saved!.text, 'پیگیری قرارداد');
    expect(saved.description, 'خلاصه قرارداد و اقدام بعدی');
    expect(find.text('پیگیری قرارداد'), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'saved no-follow-up task card must fit at 320px',
    );
  });
}

class _MemoryRepository implements TimelineRepository {
  final List<TimelineItem> items = <TimelineItem>[];

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
  Future<List<TimelineItem>> listNewestFirst() async {
    final result = <TimelineItem>[...items]
      ..sort((left, right) => right.timelineAt.compareTo(left.timelineAt));
    return result;
  }

  @override
  Future<void> upsert(TimelineItem item) async {
    final index = items.indexWhere((candidate) => candidate.id == item.id);
    if (index == -1) {
      items.add(item);
    } else {
      items[index] = item;
    }
  }
}
