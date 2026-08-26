import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

class ExportTimelineText {
  const ExportTimelineText();

  String export(Iterable<TimelineItem> items) {
    final visibleItems = items.toList(growable: false);
    if (visibleItems.isEmpty) {
      return '';
    }

    final sections = visibleItems.map(_formatItem).join('\n\n---\n\n');
    return 'یادنگار — خروجی Timeline\n\n$sections';
  }

  String _formatItem(TimelineItem item) {
    final timeLabel = item.occurredAt == null ? 'زمان ثبت' : 'زمان رخداد';
    return <String>[
      'نوع: ${_typeLabel(item.type)}',
      '$timeLabel: ${_formatDateTime(item.timelineAt)}',
      'متن: ${item.text}',
    ].join('\n');
  }

  String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.year}/$month/$day - $hour:$minute';
  }

  String _typeLabel(TimelineItemType type) {
    return switch (type) {
      TimelineItemType.note => 'یادداشت',
      TimelineItemType.event => 'رویداد',
      TimelineItemType.call => 'تماس',
      TimelineItemType.idea => 'ایده',
      TimelineItemType.activity => 'فعالیت',
    };
  }
}
