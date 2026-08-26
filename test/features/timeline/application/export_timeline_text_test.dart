import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/export_timeline_text.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

void main() {
  test('returns empty output when Timeline has no items', () async {
    final repository = _MemoryTimelineRepository();
    final export = ExportTimelineText(repository: repository);

    expect(await export.export(), isEmpty);
  });

  test('exports repository order with Persian type and effective time labels', () async {
    final repository = _MemoryTimelineRepository();
    await repository.upsert(
      TimelineItem(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'یادداشت قدیمی',
        createdAt: DateTime.utc(2026, 8, 27, 8, 15),
      ),
    );
    await repository.upsert(
      TimelineItem(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'جلسه مهم',
        createdAt: DateTime.utc(2026, 8, 27, 7),
        occurredAt: DateTime.utc(2026, 8, 27, 10, 30),
      ),
    );

    final text = await ExportTimelineText(repository: repository).export();

    expect(text, startsWith('یادنگار — خروجی Timeline'));
    expect(text, contains('نوع: رویداد'));
    expect(text, contains('زمان رخداد: 2026/08/27 - 10:30'));
    expect(text, contains('متن: جلسه مهم'));
    expect(text, contains('نوع: یادداشت'));
    expect(text, contains('زمان ثبت: 2026/08/27 - 08:15'));
    expect(text.indexOf('جلسه مهم'), lessThan(text.indexOf('یادداشت قدیمی')));
  });
}

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
