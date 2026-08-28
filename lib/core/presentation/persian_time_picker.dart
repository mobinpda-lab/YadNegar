import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';

Future<TimeOfDay?> showYadNegarPersianTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  PersianDateTimeFormatter formatter = const PersianDateTimeFormatter(),
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    initialEntryMode: TimePickerEntryMode.dial,
    helpText: 'انتخاب ساعت ۲۴ ساعته',
    cancelText: 'لغو',
    confirmText: 'تأیید',
    hourLabelText: 'ساعت',
    minuteLabelText: 'دقیقه',
    builder: (context, child) {
      final mediaQuery = MediaQuery.of(context);
      return MediaQuery(
        data: mediaQuery.copyWith(alwaysUse24HourFormat: true),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        ),
      );
    },
  );
}
