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

class _MemoryTimelineRepository implements TimelineRepository {
  _MemoryTimelineRepository(this.items);

  final List<TimelineItem> items;

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
    final result = List<TimelineItem>.of(items)
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

void main() {
  testWidgets('tracked task supports blank-default capture and safe editing', (tester) async {
    final root = TimelineItem(
      id: 'car',
      type: TimelineItemType.activity,
      text: 'سرویس خودرو',
      createdAt: DateTime(2026, 8, 27, 8),
    );
    final existingFollowUp = TimelineItem(
      id: 'car-f1',
      parentId: root.id,
      type: root.type,
      text: 'بررسی روغن انجام شد',
      createdAt: DateTime(2026, 8, 28, 9, 15),
      occurredAt: DateTime(2026, 8, 28, 9, 15),
    );
    final repository = _MemoryTimelineRepository([root, existingFollowUp]);
    final edit = EditTimelineItem(repository: repository);
    var generatedId = 0;
    final now = DateTime(2026, 8, 28, 11, 30);

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: TrackedSubjectHome(
            quickCapture: QuickCapture(
              repository: repository,
              clock: () => now,
              idGenerator: () => 'root-${generatedId++}',
            ),
            loadSubjects: LoadTrackedSubjects(repository: repository),
            loadFollowUps: LoadTimelineFollowUps(repository: repository),
            addFollowUp: AddTimelineFollowUp(
              repository: repository,
              clock: () => now,
              idGenerator: () => 'follow-${generatedId++}',
            ),
            editTimelineItem: edit,
            clock: () => now,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final rootCard = find.byKey(const Key('tracked-subject-car'));
    await tester.drag(
      find.byKey(const Key('tracked-subject-home-scroll')),
      const Offset(0, -520),
    );
    await tester.pumpAndSettle();
    expect(rootCard, findsOneWidget);
    expect(find.text('۱ پیگیری'), findsOneWidget);
    expect(find.textContaining('۱۴۰۵/۰۶/۰۶'), findsWidgets);

    await tester.tap(rootCard);
    await tester.pumpAndSettle();

    expect(find.text('بررسی روغن انجام شد'), findsOneWidget);
    expect(find.text('۱۴۰۵/۰۶/۰۶ - ۰۹:۱۵'), findsWidgets);

    await tester.tap(find.byKey(const Key('tracked-subject-add-follow-up')));
    await tester.pumpAndSettle();

    expect(find.text('ثبت پیگیری'), findsOneWidget);
    expect(find.text('۱۴۰۵/۰۶/۰۶'), findsOneWidget);
    expect(find.text('۱۱:۳۰'), findsOneWidget);

    await tester.tap(find.byKey(const Key('follow-up-editor-confirm')));
    await tester.pumpAndSettle();

    expect(find.text('پیگیری'), findsOneWidget);
    expect(find.text('فاصله از پیگیری قبلی: ۲ ساعت و ۱۵ دقیقه'), findsOneWidget);
    expect(find.text('● ۰ دقیقه از آخرین پیگیری گذشته'), findsOneWidget);

    final newFollowUp = repository.items.singleWhere((item) => item.id == 'follow-0');
    expect(newFollowUp.parentId, root.id);
    expect(newFollowUp.text, 'پیگیری');
    expect(newFollowUp.occurredAt, now);

    await tester.tap(find.byKey(const Key('follow-up-follow-0')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('follow-up-title-input')),
      'تماس با تعمیرگاه',
    );
    await tester.tap(find.byKey(const Key('follow-up-editor-confirm')));
    await tester.pumpAndSettle();

    final editedFollowUp = repository.items.singleWhere((item) => item.id == 'follow-0');
    expect(editedFollowUp.text, 'تماس با تعمیرگاه');
    expect(editedFollowUp.parentId, root.id);
    expect(repository.items.where((item) => item.parentId == root.id), hasLength(2));

    await tester.tap(find.byKey(const Key('tracked-subject-edit')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('tracked-subject-edit-title')),
      'سرویس دوره‌ای خودرو',
    );
    await tester.tap(find.byKey(const Key('tracked-subject-edit-confirm')));
    await tester.pumpAndSettle();

    expect(find.text('سرویس دوره‌ای خودرو'), findsWidgets);
    expect(repository.items.where((item) => item.parentId == root.id), hasLength(2));
  });
}
