import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';

Future<TimeOfDay?> showYadNegarPersianTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  PersianDateTimeFormatter formatter = const PersianDateTimeFormatter(),
}) async {
  var hour = initialTime.hour;
  var minute = initialTime.minute;

  return showDialog<TimeOfDay>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        DropdownMenuItem<int> item(int value) => DropdownMenuItem<int>(
              value: value,
              child: Text(
                formatter.persianDigits(value.toString().padLeft(2, '0')),
              ),
            );

        return AlertDialog(
          title: const Text('انتخاب ساعت'),
          content: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: const Key('persian-time-hour'),
                  initialValue: hour,
                  decoration: const InputDecoration(labelText: 'ساعت'),
                  items: List<int>.generate(24, (index) => index)
                      .map(item)
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => hour = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: const Key('persian-time-minute'),
                  initialValue: minute,
                  decoration: const InputDecoration(labelText: 'دقیقه'),
                  items: List<int>.generate(60, (index) => index)
                      .map(item)
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => minute = value);
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
              key: const Key('persian-time-confirm'),
              onPressed: () => Navigator.of(dialogContext).pop(
                TimeOfDay(hour: hour, minute: minute),
              ),
              child: const Text('تأیید'),
            ),
          ],
        );
      },
    ),
  );
}
