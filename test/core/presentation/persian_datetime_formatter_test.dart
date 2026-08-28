import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';

void main() {
  const formatter = PersianDateTimeFormatter();

  test('converts project date to Jalali with Persian digits', () {
    expect(formatter.formatDate(DateTime(2026, 8, 28)), '۱۴۰۵/۰۶/۰۶');
  });

  test('handles Nowruz and leap Esfand boundaries', () {
    expect(formatter.formatDate(DateTime(2026, 3, 21)), '۱۴۰۵/۰۱/۰۱');
    expect(formatter.formatDate(DateTime(2025, 3, 20)), '۱۴۰۳/۱۲/۳۰');
    expect(formatter.formatDate(DateTime(2025, 3, 21)), '۱۴۰۴/۰۱/۰۱');
  });

  test('keeps local clock while presenting Persian date-time digits', () {
    expect(
      formatter.formatDateTime(DateTime(2026, 8, 28, 9, 7)),
      '۱۴۰۵/۰۶/۰۶ - ۰۹:۰۷',
    );
  });

  test('converts Jalali input back to the intended Gregorian local date', () {
    final gregorian = formatter.toGregorian(const JalaliDate(1405, 6, 6));
    expect(gregorian, DateTime(2026, 8, 28));
    expect(formatter.toJalali(gregorian).year, 1405);
    expect(formatter.toJalali(gregorian).month, 6);
    expect(formatter.toJalali(gregorian).day, 6);
  });

  test('preserves clock values when converting selected Jalali date', () {
    final value = formatter.toGregorian(
      const JalaliDate(1405, 6, 9),
      hour: 10,
      minute: 25,
    );
    expect(value, DateTime(2026, 8, 31, 10, 25));
    expect(formatter.formatDateTime(value), '۱۴۰۵/۰۶/۰۹ - ۱۰:۲۵');
  });

  test('reports Esfand day count across leap boundary', () {
    expect(formatter.daysInJalaliMonth(1403, 12), 30);
    expect(formatter.daysInJalaliMonth(1404, 12), 29);
  });
}
