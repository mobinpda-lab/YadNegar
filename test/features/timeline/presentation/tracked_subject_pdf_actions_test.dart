import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_pdf_actions.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_pdf_scope.dart';

void main() {
  testWidgets('current task scope shares only the current tracked task', (tester) async {
    Set<String>? sharedIds;
    var shareCalled = false;

    await tester.pumpWidget(
      _Harness(
        sharePdf: (ids) async {
          shareCalled = true;
          sharedIds = ids;
        },
        printPdf: (_) async {},
      ),
    );

    await tester.tap(find.byKey(const Key('open-pdf-actions')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracked-subject-pdf-current')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracked-subject-pdf-share')));
    await tester.pumpAndSettle();

    expect(shareCalled, isTrue);
    expect(sharedIds, <String>{'a'});
  });

  testWidgets('all task scope prints with null selection meaning all roots', (tester) async {
    Set<String>? printedIds = <String>{'unexpected'};
    var printCalled = false;

    await tester.pumpWidget(
      _Harness(
        sharePdf: (_) async {},
        printPdf: (ids) async {
          printCalled = true;
          printedIds = ids;
        },
      ),
    );

    await tester.tap(find.byKey(const Key('open-pdf-actions')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracked-subject-pdf-all')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracked-subject-pdf-print')));
    await tester.pumpAndSettle();

    expect(printCalled, isTrue);
    expect(printedIds, isNull);
  });

  testWidgets('selected scope can include multiple tracked tasks', (tester) async {
    Set<String>? sharedIds;

    await tester.pumpWidget(
      _Harness(
        sharePdf: (ids) async {
          sharedIds = ids;
        },
        printPdf: (_) async {},
      ),
    );

    await tester.tap(find.byKey(const Key('open-pdf-actions')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracked-subject-pdf-selected')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('tracked-subject-pdf-select-b')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracked-subject-pdf-selection-confirm')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracked-subject-pdf-share')));
    await tester.pumpAndSettle();

    expect(sharedIds, <String>{'a', 'b'});
  });
}

class _Harness extends StatelessWidget {
  const _Harness({
    required this.sharePdf,
    required this.printPdf,
  });

  final TrackedSubjectPdfAction sharePdf;
  final TrackedSubjectPdfAction printPdf;

  @override
  Widget build(BuildContext context) {
    return TrackedSubjectPdfScope(
      sharePdf: sharePdf,
      printPdf: printPdf,
      loadSubjects: () async => <TimelineItem>[
        _subject('a', 'کار اول'),
        _subject('b', 'کار دوم'),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                key: const Key('open-pdf-actions'),
                onPressed: () async {
                  await TrackedSubjectPdfActions.open(
                    context,
                    currentSubjectId: 'a',
                  );
                },
                child: const Text('PDF'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TimelineItem _subject(String id, String text) {
  return TimelineItem(
    id: id,
    type: TimelineItemType.activity,
    text: text,
    createdAt: DateTime(2026, 8, 28, 10),
  );
}
