import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';

class PersianDurationFormatter {
  const PersianDurationFormatter({
    this.dateTimeFormatter = const PersianDateTimeFormatter(),
  });

  final PersianDateTimeFormatter dateTimeFormatter;

  String elapsedSince({required DateTime now, required DateTime latest}) {
    final duration = _nonNegative(now.difference(latest));
    return '${format(duration)} از آخرین پیگیری گذشته';
  }

  String intervalBetween({required DateTime newer, required DateTime older}) {
    final duration = _nonNegative(newer.difference(older));
    return 'فاصله از پیگیری قبلی: ${format(duration)}';
  }

  String relativeAgo({required DateTime now, required DateTime value}) {
    return '${format(_nonNegative(now.difference(value)))} پیش';
  }

  String format(Duration duration) {
    final safe = _nonNegative(duration);
    final totalMinutes = safe.inMinutes;
    if (totalMinutes < 60) {
      return _part(totalMinutes, 'دقیقه');
    }

    final totalHours = safe.inHours;
    if (totalHours < 24) {
      final minutes = totalMinutes % 60;
      return _join(
        _part(totalHours, 'ساعت'),
        minutes == 0 ? null : _part(minutes, 'دقیقه'),
      );
    }

    final totalDays = safe.inDays;
    if (totalDays < 7) {
      final hours = totalHours % 24;
      return _join(
        _part(totalDays, 'روز'),
        hours == 0 ? null : _part(hours, 'ساعت'),
      );
    }

    if (totalDays < 30) {
      final weeks = totalDays ~/ 7;
      final days = totalDays % 7;
      return _join(
        _part(weeks, 'هفته'),
        days == 0 ? null : _part(days, 'روز'),
      );
    }

    final months = totalDays ~/ 30;
    final days = totalDays % 30;
    return _join(
      _part(months, 'ماه'),
      days == 0 ? null : _part(days, 'روز'),
    );
  }

  String _part(int value, String unit) {
    return '${dateTimeFormatter.persianDigits(value.toString())} $unit';
  }

  String _join(String first, String? second) {
    return second == null ? first : '$first و $second';
  }

  Duration _nonNegative(Duration value) {
    return value.isNegative ? Duration.zero : value;
  }
}
