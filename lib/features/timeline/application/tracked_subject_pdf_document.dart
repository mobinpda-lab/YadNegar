import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';
import 'package:yadnegar/features/timeline/application/build_tracked_subject_export.dart';

class TrackedSubjectPdfDocument {
  const TrackedSubjectPdfDocument({
    this.dateTimeFormatter = const PersianDateTimeFormatter(),
  });

  final PersianDateTimeFormatter dateTimeFormatter;

  Future<Uint8List> build({
    required TrackedSubjectExport export,
    required Uint8List regularFontBytes,
    required Uint8List boldFontBytes,
  }) async {
    final regularFont = pw.Font.ttf(ByteData.sublistView(regularFontBytes));
    final boldFont = pw.Font.ttf(ByteData.sublistView(boldFontBytes));
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        margin: const pw.EdgeInsets.fromLTRB(28, 32, 28, 32),
        build: (context) => <pw.Widget>[
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: <pw.Widget>[
                pw.Text(
                  'یادنگار — گزارش کارها و پیگیری‌ها',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(font: boldFont, fontSize: 18),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'تعداد کارها: ${dateTimeFormatter.persianDigits(export.entries.length.toString())}',
                  textAlign: pw.TextAlign.right,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 16),
                if (export.isEmpty)
                  pw.Text(
                    'موردی برای خروجی وجود ندارد.',
                    textAlign: pw.TextAlign.right,
                  )
                else
                  ..._buildEntries(export.entries, boldFont),
              ],
            ),
          ),
        ],
      ),
    );

    return document.save();
  }

  List<pw.Widget> _buildEntries(
    List<TrackedSubjectExportEntry> entries,
    pw.Font boldFont,
  ) {
    final widgets = <pw.Widget>[];
    for (var index = 0; index < entries.length; index += 1) {
      if (index > 0) {
        widgets.add(pw.SizedBox(height: 14));
      }
      widgets.add(_buildEntry(entries[index], boldFont));
    }
    return widgets;
  }

  pw.Widget _buildEntry(
    TrackedSubjectExportEntry entry,
    pw.Font boldFont,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.6),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: <pw.Widget>[
          pw.Text(
            entry.subject.text,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(font: boldFont, fontSize: 14),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'زمان ثبت کار: ${dateTimeFormatter.formatDateTime(entry.subject.timelineAt)}',
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 9),
          pw.Text(
            'پیگیری‌ها',
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(font: boldFont, fontSize: 11),
          ),
          pw.SizedBox(height: 5),
          if (entry.followUps.isEmpty)
            pw.Text(
              'هنوز پیگیری ثبت نشده است',
              textAlign: pw.TextAlign.right,
              style: const pw.TextStyle(fontSize: 9),
            )
          else
            ...entry.followUps.map(
              (followUp) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: <pw.Widget>[
                    pw.Text(
                      followUp.text.trim().isEmpty ? 'پیگیری' : followUp.text,
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      dateTimeFormatter.formatDateTime(followUp.timelineAt),
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
