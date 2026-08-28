import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('capture trims an optional root description and empty becomes null', () async {
    final repository = _MemoryRepository();
    final capture = QuickCapture(
      repository: repository,
      clock: () => DateTime(2026, 8, 28, 10),
      idGenerator: () => 'root-1',
    );

    final saved = await capture.capture(
      text: '  قرارداد جدید  ',
      description: '  خلاصه قرارداد و اقدام بعدی  ',
      type: TimelineItemType.activity,
    );

    expect(saved.text, 'قرارداد جدید');
    expect(saved.description, 'خلاصه قرارداد و اقدام بعدی');

    final emptyRepository = _MemoryRepository();
    final emptyCapture = QuickCapture(
      repository: emptyRepository,
      clock: () => DateTime(2026, 8, 28, 11),
      idGenerator: () => 'root-2',
    );
    final empty = await emptyCapture.capture(
      text: 'کار بدون شرح',
      description: '   ',
    );
    expect(empty.description, isNull);
  });

  test('edit can set and clear root description without changing children', () async {
    final root = TimelineItem(
      id: 'root-1',
      type: TimelineItemType.activity,
      text: 'قرارداد',
      createdAt: DateTime(2026, 8, 28, 10),
    );
    final child = TimelineItem(
      id: 'follow-1',
      parentId: root.id,
      type: TimelineItemType.activity,
      text: 'تماس با مشتری',
      createdAt: DateTime(2026, 8, 28, 11),
      occurredAt: DateTime(2026, 8, 28, 11),
    );
    final repository = _MemoryRepository(<TimelineItem>[root, child]);
    final edit = EditTimelineItem(repository: repository);

    final described = await edit.update(
      id: root.id,
      text: root.text,
      replaceDescription: true,
      description: '  خلاصه جدید  ',
    );
    expect(described.id, root.id);
    expect(described.description, 'خلاصه جدید');
    expect((await repository.findById(child.id))?.parentId, root.id);
    expect((await repository.findById(child.id))?.text, child.text);

    final cleared = await edit.update(
      id: root.id,
      text: root.text,
      replaceDescription: true,
      description: ' ',
    );
    expect(cleared.description, isNull);
    expect((await repository.findById(child.id))?.parentId, root.id);
  });

  test('ordinary root edits preserve an existing description', () async {
    final repository = _MemoryRepository(<TimelineItem>[
      TimelineItem(
        id: 'root-1',
        type: TimelineItemType.activity,
        text: 'عنوان قدیمی',
        description: 'شرح موجود',
        createdAt: DateTime(2026, 8, 28, 10),
      ),
    ]);

    final updated = await EditTimelineItem(repository: repository).updateText(
      id: 'root-1',
      text: 'عنوان جدید',
    );

    expect(updated.text, 'عنوان جدید');
    expect(updated.description, 'شرح موجود');
  });
}

class _MemoryRepository implements TimelineRepository {
  _MemoryRepository([List<TimelineItem>? initial])
      : items = <TimelineItem>[...?initial];

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
  Future<List<TimelineItem>> listNewestFirst() async => List<TimelineItem>.of(items);

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
