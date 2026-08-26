import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/export_timeline_text.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  const export = ExportTimelineText();

  test('returns empty output when the visible Timeline has no items', () {
    expect(export.export(const <TimelineItem>[]), isEmpty);
  });

  test('preserves visible order with Persian type and effective time labels', () {
    final items = <TimelineItem>[
      TimelineItem(
        id: 'event-1',
        type: TimelineItemType.event,
        text: 'جلسه مهم',
        createdAt: DateTime.utc(2026, 8, 27, 7),
        occurredAt: DateTime.utc(2026, 8, 27, 10, 30),
      ),
      TimelineItem(
        id: 'note-1',
        type: TimelineItemType.note,
        text: 'یادداشت قدیمی',
        createdAt: DateTime.utc(2026, 8, 27, 8, 15),
      ),
    ];

    final text = export.export(items);

    expect(text, startsWith('یادنگار — خروجی Timeline'));
    expect(text, contains('نوع: رویداد'));
    expect(text, contains('زمان رخداد: 2026/08/27 - 10:30'));
    expect(text, contains('متن: جلسه مهم'));
    expect(text, contains('نوع: یادداشت'));
    expect(text, contains('زمان ثبت: 2026/08/27 - 08:15'));
    expect(text.indexOf('جلسه مهم'), lessThan(text.indexOf('یادداشت قدیمی')));
  });
}
