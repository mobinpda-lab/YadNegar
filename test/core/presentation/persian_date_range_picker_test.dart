import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/core/presentation/persian_date_range_picker.dart';

void main() {
  testWidgets('range calendar is fully Persian Jalali and returns selected range', (tester) async {
    DateTimeRange? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                key: const Key('open-range'),
                onPressed: () async {
                  selected = await showYadNegarPersianDateRangePicker(
                    context: context,
                    initialRange: DateTimeRange(
                      start: DateTime(2026, 8, 28),
                      end: DateTime(2026, 8, 30),
                    ),
                  );
                },
                child: const Text('باز کردن'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('open-range')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('persian-date-range-dialog')), findsOneWidget);
    expect(find.text('شهریور ۱۴۰۵'), findsOneWidget);
    for (final label in const ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج']) {
      expect(find.text(label), findsWidgets);
    }

    for (final english in const [
      'Start Date',
      'End Date',
      'August 2026',
      'September 2026',
      'S',
      'F',
      'T',
      'W',
      'M',
    ]) {
      expect(find.text(english), findsNothing);
    }

    await tester.tap(find.byKey(const Key('persian-calendar-day-1405-6-7')));
    await tester.tap(find.byKey(const Key('persian-calendar-day-1405-6-9')));
    await tester.tap(find.byKey(const Key('persian-date-range-confirm')));
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.start, DateTime(2026, 8, 29));
    expect(selected!.end, DateTime(2026, 8, 31));
  });
}
