import 'package:flutter/widgets.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

typedef TrackedSubjectPdfAction = Future<void> Function(Set<String>? subjectIds);
typedef TrackedSubjectPdfSubjectsLoader = Future<List<TimelineItem>> Function();

class TrackedSubjectPdfScope extends InheritedWidget {
  const TrackedSubjectPdfScope({
    super.key,
    required this.sharePdf,
    required this.printPdf,
    required this.loadSubjects,
    required super.child,
  });

  final TrackedSubjectPdfAction sharePdf;
  final TrackedSubjectPdfAction printPdf;
  final TrackedSubjectPdfSubjectsLoader loadSubjects;

  static TrackedSubjectPdfScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TrackedSubjectPdfScope>();
  }

  @override
  bool updateShouldNotify(TrackedSubjectPdfScope oldWidget) {
    return sharePdf != oldWidget.sharePdf ||
        printPdf != oldWidget.printPdf ||
        loadSubjects != oldWidget.loadSubjects;
  }
}
