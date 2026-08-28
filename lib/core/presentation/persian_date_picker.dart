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

  return showDialog<DateTime>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        final daysInMonth = formatter.daysInJalaliMonth(year, month);
        if (day > daysInMonth) {
          day = daysInMonth;
        }
        final years = List<int>.generate(151, (index) => initial.year - 100 + index);

        DropdownMenuItem<int> item(int value) => DropdownMenuItem<int>(
              value: value,
              child: Text(formatter.persianDigits(value.toString())),
            );

        return AlertDialog(
          title: const Text('انتخاب تاریخ'),
          content: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: const Key('jalali-year'),
                  initialValue: year,
                  decoration: const InputDecoration(labelText: 'سال'),
                  items: years.map(item).toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => year = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: const Key('jalali-month'),
                  initialValue: month,
                  decoration: const InputDecoration(labelText: 'ماه'),
                  items: List<int>.generate(12, (index) => index + 1)
                      .map(item)
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => month = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: const Key('jalali-day'),
                  initialValue: day,
                  decoration: const InputDecoration(labelText: 'روز'),
                  items: List<int>.generate(daysInMonth, (index) => index + 1)
                      .map(item)
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => day = value);
                    }
                  },
                ),
              ),
            ],
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
