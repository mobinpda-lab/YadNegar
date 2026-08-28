import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class TrackedSubjectExportEntry {
  const TrackedSubjectExportEntry({
    required this.subject,
    required this.followUps,
  });

  final TimelineItem subject;
  final List<TimelineItem> followUps;
}

class TrackedSubjectExport {
  const TrackedSubjectExport({required this.entries});

  final List<TrackedSubjectExportEntry> entries;

  bool get isEmpty => entries.isEmpty;
}

class BuildTrackedSubjectExport {
  const BuildTrackedSubjectExport({required this.repository});

  final TimelineRepository repository;

  Future<TrackedSubjectExport> build({Set<String>? subjectIds}) async {
    final items = await repository.listNewestFirst();
    final selectedIds = subjectIds == null ? null : Set<String>.of(subjectIds);

    final subjects = items
        .where(
          (item) =>
              item.isTrackedSubject &&
              (selectedIds == null || selectedIds.contains(item.id)),
        )
        .toList(growable: true)
      ..sort((left, right) => right.timelineAt.compareTo(left.timelineAt));

    final entries = subjects.map((subject) {
      final followUps = items
          .where((item) => item.parentId == subject.id)
          .toList(growable: true)
        ..sort((left, right) => right.timelineAt.compareTo(left.timelineAt));
      return TrackedSubjectExportEntry(
        subject: subject,
        followUps: List<TimelineItem>.unmodifiable(followUps),
      );
    }).toList(growable: false);

    return TrackedSubjectExport(
      entries: List<TrackedSubjectExportEntry>.unmodifiable(entries),
    );
  }
}
