import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_pdf_scope.dart';

class TrackedSubjectPdfActions {
  const TrackedSubjectPdfActions._();

  static Future<void> open(
    BuildContext context, {
    required String currentSubjectId,
  }) async {
    final scope = TrackedSubjectPdfScope.maybeOf(context);
    if (scope == null) {
      return;
    }

    final exportScope = await showModalBottomSheet<_PdfExportScope>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'گزارش PDF',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('محدوده گزارش را انتخاب کنید'),
            ),
            ListTile(
              key: const Key('tracked-subject-pdf-current'),
              leading: const Icon(Icons.description_outlined),
              title: const Text('همین کار'),
              onTap: () => Navigator.of(sheetContext).pop(_PdfExportScope.current),
            ),
            ListTile(
              key: const Key('tracked-subject-pdf-all'),
              leading: const Icon(Icons.library_books_outlined),
              title: const Text('همه کارها'),
              onTap: () => Navigator.of(sheetContext).pop(_PdfExportScope.all),
            ),
            ListTile(
              key: const Key('tracked-subject-pdf-selected'),
              leading: const Icon(Icons.checklist_rtl_outlined),
              title: const Text('انتخاب چند کار'),
              onTap: () => Navigator.of(sheetContext).pop(_PdfExportScope.selected),
            ),
          ],
        ),
      ),
    );
    if (exportScope == null || !context.mounted) {
      return;
    }

    Set<String>? subjectIds;
    switch (exportScope) {
      case _PdfExportScope.current:
        subjectIds = <String>{currentSubjectId};
        break;
      case _PdfExportScope.all:
        subjectIds = null;
        break;
      case _PdfExportScope.selected:
        subjectIds = await _selectSubjects(
          context,
          scope: scope,
          currentSubjectId: currentSubjectId,
        );
        if (subjectIds == null || subjectIds.isEmpty || !context.mounted) {
          return;
        }
        break;
    }

    await _chooseAction(context, scope: scope, subjectIds: subjectIds);
  }

  static Future<Set<String>?> _selectSubjects(
    BuildContext context, {
    required TrackedSubjectPdfScope scope,
    required String currentSubjectId,
  }) async {
    List<TimelineItem> subjects;
    try {
      subjects = await scope.loadSubjects();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('بارگذاری فهرست کارها انجام نشد.')),
        );
      }
      return null;
    }
    if (!context.mounted) {
      return null;
    }

    final selected = <String>{currentSubjectId};
    return showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('انتخاب کارها'),
          content: SizedBox(
            width: double.maxFinite,
            child: subjects.isEmpty
                ? const Text('کاری برای انتخاب وجود ندارد.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      final checked = selected.contains(subject.id);
                      return CheckboxListTile(
                        key: Key('tracked-subject-pdf-select-${subject.id}'),
                        value: checked,
                        title: Text(subject.text),
                        onChanged: (value) {
                          setDialogState(() {
                            if (value == true) {
                              selected.add(subject.id);
                            } else {
                              selected.remove(subject.id);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              key: const Key('tracked-subject-pdf-selection-cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('انصراف'),
            ),
            FilledButton(
              key: const Key('tracked-subject-pdf-selection-confirm'),
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.of(dialogContext).pop(Set<String>.of(selected)),
              child: const Text('ادامه'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _chooseAction(
    BuildContext context, {
    required TrackedSubjectPdfScope scope,
    required Set<String>? subjectIds,
  }) async {
    final action = await showModalBottomSheet<_PdfOutputAction>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'خروجی گزارش',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            ListTile(
              key: const Key('tracked-subject-pdf-share'),
              leading: const Icon(Icons.share_outlined),
              title: const Text('اشتراک PDF'),
              onTap: () => Navigator.of(sheetContext).pop(_PdfOutputAction.share),
            ),
            ListTile(
              key: const Key('tracked-subject-pdf-print'),
              leading: const Icon(Icons.print_outlined),
              title: const Text('چاپ PDF'),
              onTap: () => Navigator.of(sheetContext).pop(_PdfOutputAction.print),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) {
      return;
    }

    try {
      switch (action) {
        case _PdfOutputAction.share:
          await scope.sharePdf(subjectIds);
          break;
        case _PdfOutputAction.print:
          await scope.printPdf(subjectIds);
          break;
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ساخت یا ارسال گزارش PDF انجام نشد.')),
        );
      }
    }
  }
}

enum _PdfExportScope { current, all, selected }

enum _PdfOutputAction { share, print }
