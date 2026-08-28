import 'dart:collection';

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

/// A date-range export request that preserves the existing PDF action contract.
///
/// It intentionally behaves as an empty string set so existing share/print
/// wiring can pass it through unchanged; [BuildTrackedSubjectExport] recognizes
/// the richer request type and applies the date projection to FollowUps.
class TrackedSubjectDateRangeSelection extends SetBase<String> {
  TrackedSubjectDateRangeSelection({
    required this.startInclusive,
    required this.endInclusive,
  });

  final DateTime startInclusive;
  final DateTime endInclusive;
  final Set<String> _values = <String>{};

  @override
  bool add(String value) => _values.add(value);

  @override
  bool contains(Object? element) => _values.contains(element);

  @override
  Iterator<String> get iterator => _values.iterator;

  @override
  int get length => _values.length;

  @override
  String? lookup(Object? element) => _values.lookup(element);

  @override
  bool remove(Object? value) => _values.remove(value);

  @override
  Set<String> toSet() => Set<String>.of(_values);
}

class BuildTrackedSubjectExport {
  const BuildTrackedSubjectExport({required this.repository});

  final TimelineRepository repository;

  Future<TrackedSubjectExport> build({Set<String>? subjectIds}) async {
    final items = await repository.listNewestFirst();
    final dateRange = subjectIds is TrackedSubjectDateRangeSelection
        ? subjectIds
        : null;
    final selectedIds = dateRange == null && subjectIds != null
        ? Set<String>.of(subjectIds)
        : null;

    final subjects = items
        .where(
          (item) =>
              item.isTrackedSubject &&
              (selectedIds == null || selectedIds.contains(item.id)),
        )
        .toList(growable: true)
      ..sort((left, right) => right.timelineAt.compareTo(left.timelineAt));

    final entries = <TrackedSubjectExportEntry>[];
    for (final subject in subjects) {
      final followUps = items
          .where((item) {
            if (item.parentId != subject.id) {
              return false;
            }
            if (dateRange == null) {
              return true;
            }
            return !_isBefore(item.timelineAt, dateRange.startInclusive) &&
                !_isAfter(item.timelineAt, dateRange.endInclusive);
          })
          .toList(growable: true)
        ..sort((left, right) => right.timelineAt.compareTo(left.timelineAt));

      // Date-based reports are activity reports: a root is included only when
      // at least one real FollowUp occurred inside the requested range.
      if (dateRange != null && followUps.isEmpty) {
        continue;
      }

      entries.add(
        TrackedSubjectExportEntry(
          subject: subject,
          followUps: List<TimelineItem>.unmodifiable(followUps),
        ),
      );
    }

    return TrackedSubjectExport(
      entries: List<TrackedSubjectExportEntry>.unmodifiable(entries),
    );
  }

  static bool _isBefore(DateTime value, DateTime boundary) =>
      value.compareTo(boundary) < 0;

  static bool _isAfter(DateTime value, DateTime boundary) =>
      value.compareTo(boundary) > 0;
}
