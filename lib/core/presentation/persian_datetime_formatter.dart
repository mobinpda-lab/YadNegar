class JalaliDate {
  const JalaliDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;
}

class PersianDateTimeFormatter {
  const PersianDateTimeFormatter();

  String formatDate(DateTime value) {
    final jalali = toJalali(value);
    final month = jalali.month.toString().padLeft(2, '0');
    final day = jalali.day.toString().padLeft(2, '0');
    return '${jalali.year}/$month/$day';
  }

  String formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
}
