import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class _Repository implements TimelineRepository {
  final Map<String, TimelineItem> items = <String, TimelineItem>{};

  @override
  Future<bool> deleteById(String id) async => items.remove(id) != null;

  @override
  Future<TimelineItem?> findById(String id) async => items[id];

  @override
  Future<List<TimelineItem>> listNewestFirst() async => items.values.toList();

  @override
  Future<void> upsert(TimelineItem item) async {
    items[item.id] = item;
  }
}

void main() {
  test('blank follow-up becomes پیگیری and uses one injected clock instant', () async {
    final repository = _Repository();
    final root = TimelineItem(
      id: 'root',
      type: TimelineItemType.activity,
      text: 'تماس با علی',
      createdAt: DateTime(2026, 8, 28, 8),
    );
    repository.items[root.id] = root;
    var clockCalls = 0;
    final now = DateTime(2026, 8, 28, 10, 25);

    final saved = await AddTimelineFollowUp(
      repository: repository,
      clock: () {
        clockCalls += 1;
        return now;
      },
      idGenerator: () => 'follow-up',
    ).add(subject: root, text: '   ');

    expect(saved.text, 'پیگیری');
    expect(saved.parentId, root.id);
    expect(saved.createdAt, now);
    expect(saved.occurredAt, now);
    expect(clockCalls, 1);
  });

  test('editing one follow-up preserves parent and sibling history', () async {
    final repository = _Repository();
    final root = TimelineItem(
      id: 'root',
      type: TimelineItemType.activity,
      text: 'تماس با علی',
      createdAt: DateTime(2026, 8, 28, 8),
    );
    final first = TimelineItem(
      id: 'first',
      parentId: root.id,
      type: root.type,
      text: 'اولین تماس',
      createdAt: DateTime(2026, 8, 28, 9),
      occurredAt: DateTime(2026, 8, 28, 9),
    );
    final second = TimelineItem(
      id: 'second',
      parentId: root.id,
      type: root.type,
      text: 'منتظر پاسخ',
      createdAt: DateTime(2026, 8, 28, 10),
      occurredAt: DateTime(2026, 8, 28, 10),
    );
    repository.items.addAll({root.id: root, first.id: first, second.id: second});

    final edited = await EditTimelineItem(repository: repository).update(
      id: second.id,
      text: 'هماهنگی انجام شد',
      replaceOccurredAt: true,
      occurredAt: DateTime(2026, 8, 28, 10, 45),
    );

    expect(edited.parentId, root.id);
    expect(edited.text, 'هماهنگی انجام شد');
    expect(repository.items[first.id]?.text, 'اولین تماس');
    expect(
      repository.items.values.where((item) => item.parentId == root.id),
      hasLength(2),
    );
  });
}
