import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';

void main() {
  const formatter = PersianDateTimeFormatter();

  test('converts project date to Jalali', () {
    expect(formatter.formatDate(DateTime(2026, 8, 28)), '1405/06/06');
  });

  test('handles Nowruz and leap Esfand boundaries', () {
    expect(formatter.formatDate(DateTime(2026, 3, 21)), '1405/01/01');
    expect(formatter.formatDate(DateTime(2025, 3, 20)), '1403/12/30');
    expect(formatter.formatDate(DateTime(2025, 3, 21)), '1404/01/01');
  });

  test('keeps local clock while presenting Jalali calendar date', () {
    expect(
      formatter.formatDateTime(DateTime(2026, 8, 28, 9, 7)),
      '1405/06/06 - 09:07',
    );
  });
}
