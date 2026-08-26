import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

typedef TimelineClock = DateTime Function();
typedef TimelineIdGenerator = String Function();

class QuickCapture {
  const QuickCapture({
    required this.repository,
    required this.clock,
    required this.idGenerator,
  });

  final TimelineRepository repository;
  final TimelineClock clock;
  final TimelineIdGenerator idGenerator;

  Future<TimelineItem> capture({
    required String text,
    TimelineItemType type = TimelineItemType.note,
    DateTime? occurredAt,
  }) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      throw ArgumentError.value(text, 'text', 'Quick Capture text cannot be empty.');
    }

    final id = idGenerator().trim();
    if (id.isEmpty) {
      throw StateError('Quick Capture id generator returned an empty id.');
    }

    final item = TimelineItem(
      id: id,
      type: type,
      text: normalizedText,
      createdAt: clock(),
      occurredAt: occurredAt,
    );

    await repository.upsert(item);
    return item;
  }
}
