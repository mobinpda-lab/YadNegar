import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/classify_tracked_subject_next_action.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  const classify = ClassifyTrackedSubjectNextAction();
  final now = DateTime(2026, 8, 29, 14, 30);

  TimelineItem root({DateTime? nextActionAt}) => TimelineItem(
        id: 'root-1',
        type: TimelineItemType.activity,
        text: 'کار',
        createdAt: DateTime(2026, 8, 20),
        nextActionAt: nextActionAt,
      );

  test('same calendar day remains Today even when time already passed', () {
    expect(
      classify(subject: root(nextActionAt: DateTime(2026, 8, 29, 8)), now: now),
      TrackedSubjectNextActionBucket.today,
    );
  });

  test('previous calendar day is Overdue', () {
    expect(
      classify(subject: root(nextActionAt: DateTime(2026, 8, 28, 23, 59)), now: now),
      TrackedSubjectNextActionBucket.overdue,
    );
  });

  test('next calendar day is Upcoming', () {
    expect(
      classify(subject: root(nextActionAt: DateTime(2026, 8, 30)), now: now),
      TrackedSubjectNextActionBucket.upcoming,
    );
  });

  test('null next action is No Next Action', () {
    expect(
      classify(subject: root(), now: now),
      TrackedSubjectNextActionBucket.noNextAction,
    );
  });

  test('FollowUp cannot be classified as a root task', () {
    final followUp = TimelineItem(
      id: 'follow-1',
      parentId: 'root-1',
      type: TimelineItemType.activity,
      text: 'پیگیری',
      createdAt: DateTime(2026, 8, 29),
    );

    expect(
      () => classify(subject: followUp, now: now),
      throwsArgumentError,
    );
  });
}
