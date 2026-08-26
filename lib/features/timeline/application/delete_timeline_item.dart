import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class DeleteTimelineItem {
  const DeleteTimelineItem({required this.repository});

  final TimelineRepository repository;

  Future<bool> delete({required String id}) async {
    final normalizedId = id.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(id, 'id', 'Timeline item id cannot be empty.');
    }

    return repository.deleteById(normalizedId);
  }
}
