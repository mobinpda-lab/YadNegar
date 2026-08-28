import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/build_tracked_subject_export.dart';
import 'package:yadnegar/features/timeline/application/tracked_subject_pdf_document.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('build creates a valid PDF with bundled Vazirmatn fonts', () async {
    final regular = await rootBundle.load(
      'assets/fonts/vazirmatn/Vazirmatn-UI-FD-Regular.ttf',
    );
    final bold = await rootBundle.load(
      'assets/fonts/vazirmatn/Vazirmatn-UI-FD-Bold.ttf',
    );
    final subject = TimelineItem(
      id: 'subject-1',
      type: TimelineItemType.activity,
      text: 'پیگیری قرارداد',
      createdAt: DateTime(2026, 8, 28, 10),
      occurredAt: DateTime(2026, 8, 28, 10),
    );
    final followUp = TimelineItem(
      id: 'follow-1',
      parentId: subject.id,
      type: TimelineItemType.activity,
      text: 'تماس با مشتری',
      createdAt: DateTime(2026, 8, 28, 12, 20),
      occurredAt: DateTime(2026, 8, 28, 12, 20),
    );

    final bytes = await const TrackedSubjectPdfDocument().build(
      export: TrackedSubjectExport(
        entries: <TrackedSubjectExportEntry>[
          TrackedSubjectExportEntry(
            subject: subject,
            followUps: <TimelineItem>[followUp],
          ),
        ],
      ),
      regularFontBytes: _asBytes(regular),
      boldFontBytes: _asBytes(bold),
    );

    expect(bytes.length, greaterThan(1000));
    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
  });
}

Uint8List _asBytes(ByteData data) {
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
