import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

String timelineItemTypeLabel(TimelineItemType type) {
  return switch (type) {
    TimelineItemType.note => 'یادداشت',
    TimelineItemType.event => 'رویداد',
    TimelineItemType.call => 'تماس',
    TimelineItemType.idea => 'ایده',
    TimelineItemType.activity => 'فعالیت',
  };
}

IconData timelineItemTypeIcon(TimelineItemType type) {
  return switch (type) {
    TimelineItemType.note => Icons.note_outlined,
    TimelineItemType.event => Icons.event_outlined,
    TimelineItemType.call => Icons.call_outlined,
    TimelineItemType.idea => Icons.lightbulb_outline,
    TimelineItemType.activity => Icons.check_circle_outline,
  };
}

class TimelineItemTypeOption extends StatelessWidget {
  const TimelineItemTypeOption({
    super.key,
    required this.type,
  });

  final TimelineItemType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          timelineItemTypeIcon(type),
          size: 20,
          key: Key('timeline-type-option-${type.name}-icon'),
        ),
        const SizedBox(width: 8),
        Text(timelineItemTypeLabel(type)),
      ],
    );
  }
}
