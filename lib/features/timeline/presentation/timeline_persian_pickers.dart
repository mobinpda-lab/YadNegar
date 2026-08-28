import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_date_picker.dart';
import 'package:yadnegar/core/presentation/persian_date_range_picker.dart';
import 'package:yadnegar/core/presentation/persian_time_picker.dart';

Future<DateTimeRange?> pickPersianTimelineDateRange(
  BuildContext context,
  DateTimeRange? initialRange,
) {
  return showYadNegarPersianDateRangePicker(
    context: context,
    initialRange: initialRange,
  );
}

Future<DateTime?> pickPersianTimelineDateTime(
  BuildContext context,
  DateTime initialDateTime,
) async {
  final date = await showYadNegarPersianDatePicker(
    context: context,
    initialDate: initialDateTime,
  );
  if (date == null || !context.mounted) {
    return null;
  }

  final time = await showYadNegarPersianTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDateTime),
  );
  if (time == null) {
    return null;
  }

  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
    initialDateTime.second,
    initialDateTime.millisecond,
    initialDateTime.microsecond,
  );
}

Future<DateTime?> pickPersianFutureReminderDateTime(
  BuildContext context,
  DateTime initialDateTime,
) async {
  final now = DateTime.now();
  final safeInitial = initialDateTime.isBefore(now) ? now : initialDateTime;
  return pickPersianTimelineDateTime(context, safeInitial);
}
