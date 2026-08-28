import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/core/presentation/persian_duration_formatter.dart';

void main() {
  const formatter = PersianDurationFormatter();

  test('formats minute, hour, day, week and month examples in Persian digits', () {
    expect(formatter.format(const Duration(minutes: 15)), '۱۵ دقیقه');
    expect(formatter.format(const Duration(hours: 2, minutes: 15)), '۲ ساعت و ۱۵ دقیقه');
    expect(formatter.format(const Duration(days: 3)), '۳ روز');
    expect(formatter.format(const Duration(days: 3, hours: 4)), '۳ روز و ۴ ساعت');
    expect(formatter.format(const Duration(days: 14)), '۲ هفته');
    expect(formatter.format(const Duration(days: 35)), '۱ ماه و ۵ روز');
  });

  test('builds elapsed-since-last-follow-up text without persisted fields', () {
    final latest = DateTime(2026, 8, 25, 10, 45);
    final now = DateTime(2026, 8, 28, 10, 45);
    expect(
      formatter.elapsedSince(now: now, latest: latest),
      '۳ روز از آخرین پیگیری گذشته',
    );
  });

  test('builds interval-between-follow-ups text', () {
    final older = DateTime(2026, 8, 23, 7, 45);
    final newer = DateTime(2026, 8, 28, 10, 45);
    expect(
      formatter.intervalBetween(newer: newer, older: older),
      'فاصله از پیگیری قبلی: ۵ روز و ۳ ساعت',
    );
  });

  test('relative home helper uses the same computed formatter', () {
    final value = DateTime(2026, 8, 25, 10);
    final now = DateTime(2026, 8, 28, 10);
    expect(formatter.relativeAgo(now: now, value: value), '۳ روز پیش');
  });

  test('future timestamps fail closed to zero elapsed time', () {
    final now = DateTime(2026, 8, 28, 10);
    final future = DateTime(2026, 8, 28, 11);
    expect(formatter.elapsedSince(now: now, latest: future), '۰ دقیقه از آخرین پیگیری گذشته');
  });
}
