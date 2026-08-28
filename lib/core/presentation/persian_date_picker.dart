import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';

Future<DateTime?> showYadNegarPersianDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  PersianDateTimeFormatter formatter = const PersianDateTimeFormatter(),
}) async {
  final initial = formatter.toJalali(initialDate);
  var year = initial.year;
  var month = initial.month;
  var day = initial.day;

  const monthNames = <String>[
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];
  const weekDays = <String>['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

  return showDialog<DateTime>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        final daysInMonth = formatter.daysInJalaliMonth(year, month);
        if (day > daysInMonth) {
          day = daysInMonth;
        }
        final firstGregorian = formatter.toGregorian(JalaliDate(year, month, 1));
        final leadingEmptyCells = (firstGregorian.weekday + 1) % 7;
        final totalCells = leadingEmptyCells + daysInMonth;

        void moveMonth(int delta) {
          setState(() {
            month += delta;
            if (month < 1) {
              month = 12;
              year -= 1;
            } else if (month > 12) {
              month = 1;
              year += 1;
            }
            final maxDay = formatter.daysInJalaliMonth(year, month);
            if (day > maxDay) {
              day = maxDay;
            }
          });
        }

        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          title: Row(
            children: [
              IconButton(
                key: const Key('jalali-next-month'),
                tooltip: 'ماه بعد',
                onPressed: () => moveMonth(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
              Expanded(
                child: Text(
                  '${monthNames[month - 1]} ${formatter.persianDigits(year.toString())}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                key: const Key('jalali-previous-month'),
                tooltip: 'ماه قبل',
                onPressed: () => moveMonth(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
            ],
          ),
          content: SizedBox(
            width: 330,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    for (final label in weekDays)
                      Expanded(
                        child: Center(
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Color(0xFF77788A),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 280,
                  child: GridView.builder(
                    key: const Key('jalali-calendar-grid'),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      if (index < leadingEmptyCells) {
                        return const SizedBox.shrink();
                      }
                      final value = index - leadingEmptyCells + 1;
                      final selected = value == day;
                      return InkWell(
                        key: Key('jalali-day-$value'),
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => day = value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          decoration: BoxDecoration(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            formatter.persianDigits(value.toString()),
                            style: TextStyle(
                              color: selected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : null,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('لغو'),
            ),
            FilledButton(
              key: const Key('jalali-date-confirm'),
              onPressed: () {
                final selected = formatter.toGregorian(
                  JalaliDate(year, month, day),
                  hour: initialDate.hour,
                  minute: initialDate.minute,
                  second: initialDate.second,
                  millisecond: initialDate.millisecond,
                );
                Navigator.of(dialogContext).pop(selected);
              },
              child: const Text('تأیید'),
            ),
          ],
        );
      },
    ),
  );
}
