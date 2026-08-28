class JalaliDate {
  const JalaliDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;
}

class PersianDateTimeFormatter {
  const PersianDateTimeFormatter();

  static const _westernDigits = '0123456789';
  static const _persianDigits = '۰۱۲۳۴۵۶۷۸۹';

  String persianDigits(String value) {
    final buffer = StringBuffer();
    for (final rune in value.runes) {
      final char = String.fromCharCode(rune);
      final index = _westernDigits.indexOf(char);
      buffer.write(index == -1 ? char : _persianDigits[index]);
    }
    return buffer.toString();
  }

  String formatDate(DateTime value) {
    final jalali = toJalali(value);
    final month = jalali.month.toString().padLeft(2, '0');
    final day = jalali.day.toString().padLeft(2, '0');
    return persianDigits('${jalali.year}/$month/$day');
  }

  String formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return persianDigits('$hour:$minute');
  }

  String formatDateTime(DateTime value) {
    return '${formatDate(value)} - ${formatTime(value)}';
  }

  String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start)} تا ${formatDate(end)}';
  }

  JalaliDate toJalali(DateTime value) {
    var gy = value.year;
    final gm = value.month;
    final gd = value.day;
    const gregorianMonthDays = <int>[
      0,
      31,
      59,
      90,
      120,
      151,
      181,
      212,
      243,
      273,
      304,
      334,
    ];

    late int jy;
    if (gy > 1600) {
      jy = 979;
      gy -= 1600;
    } else {
      jy = 0;
      gy -= 621;
    }

    final gy2 = gm > 2 ? gy + 1 : gy;
    var days = 365 * gy +
        ((gy2 + 3) ~/ 4) -
        ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) -
        80 +
        gd +
        gregorianMonthDays[gm - 1];

    jy += 33 * (days ~/ 12053);
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;

    if (days > 365) {
      jy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }

    if (days < 186) {
      return JalaliDate(jy, 1 + (days ~/ 31), 1 + (days % 31));
    }

    return JalaliDate(
      jy,
      7 + ((days - 186) ~/ 30),
      1 + ((days - 186) % 30),
    );
  }

  DateTime toGregorian(
    JalaliDate date, {
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  }) {
    var jy = date.year + 1595;
    var days = -355668 +
        (365 * jy) +
        ((jy ~/ 33) * 8) +
        (((jy % 33) + 3) ~/ 4) +
        date.day +
        (date.month < 7
            ? (date.month - 1) * 31
            : ((date.month - 7) * 30) + 186);

    var gy = 400 * (days ~/ 146097);
    days %= 146097;

    if (days > 36524) {
      days -= 1;
      gy += 100 * (days ~/ 36524);
      days %= 36524;
      if (days >= 365) {
        days += 1;
      }
    }

    gy += 4 * (days ~/ 1461);
    days %= 1461;

    if (days > 365) {
      gy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }

    var gd = days + 1;
    final leap = (gy % 4 == 0 && gy % 100 != 0) || gy % 400 == 0;
    final monthDays = <int>[
      0,
      31,
      leap ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
    var gm = 1;
    while (gm <= 12 && gd > monthDays[gm]) {
      gd -= monthDays[gm];
      gm += 1;
    }

    return DateTime(
      gy,
      gm,
      gd,
      hour,
      minute,
      second,
      millisecond,
    );
  }

  int daysInJalaliMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be between 1 and 12');
    }
    if (month <= 6) {
      return 31;
    }
    if (month <= 11) {
      return 30;
    }
    final lastDayOfYear = toJalali(
      toGregorian(JalaliDate(year + 1, 1, 1)).subtract(
        const Duration(days: 1),
      ),
    );
    return lastDayOfYear.day;
  }
}
