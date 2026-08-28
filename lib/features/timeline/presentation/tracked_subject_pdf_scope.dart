import 'package:flutter/widgets.dart';

typedef TrackedSubjectPdfAction = Future<void> Function(Set<String>? subjectIds);

class TrackedSubjectPdfScope extends InheritedWidget {
  const TrackedSubjectPdfScope({
    super.key,
    required this.sharePdf,
    required this.printPdf,
    required super.child,
  });

  final TrackedSubjectPdfAction sharePdf;
  final TrackedSubjectPdfAction printPdf;

  static TrackedSubjectPdfScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TrackedSubjectPdfScope>();
  }

  @override
  bool updateShouldNotify(TrackedSubjectPdfScope oldWidget) {
    return sharePdf != oldWidget.sharePdf || printPdf != oldWidget.printPdf;
  }
}
