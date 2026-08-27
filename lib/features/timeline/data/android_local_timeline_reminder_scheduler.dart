import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

class AndroidLocalTimelineReminderScheduler implements TimelineReminderScheduler {
  AndroidLocalTimelineReminderScheduler({
    required FlutterLocalNotificationsPlugin notifications,
    required DateTime Function() clock,
    required bool localTimezoneReady,
  })  : _notifications = notifications,
        _clock = clock,
        _localTimezoneReady = localTimezoneReady;

  static const String _payloadPrefix = 'yadnegar:timeline:';
  static const String _channelId = 'timeline_reminders';
  static const String _channelName = 'یادآورهای یادنگار';
  static const String _channelDescription = 'یادآور موارد ثبت‌شده در یادنگار';

  final FlutterLocalNotificationsPlugin _notifications;
  final DateTime Function() _clock;
  final bool _localTimezoneReady;

  @override
  Future<TimelineReminderScheduleResult> schedule(TimelineItem item) async {
    final reminderAt = item.reminderAt;
    if (reminderAt == null) {
      await cancel(item.id);
      return TimelineReminderScheduleResult.skippedPast;
    }

    if (item.reminderRecurrence != TimelineReminderRecurrence.none &&
        !_localTimezoneReady) {
      await cancel(item.id);
      throw StateError('Local timezone is required for recurring reminders.');
    }

    final scheduledAt = _nextScheduledAt(item);
    if (scheduledAt == null) {
      await cancel(item.id);
      return TimelineReminderScheduleResult.skippedPast;
    }

    if (!await _ensurePermission()) {
      return TimelineReminderScheduleResult.permissionDenied;
    }

    await _scheduleWithoutPermission(item, scheduledAt: scheduledAt);
    return TimelineReminderScheduleResult.scheduled;
  }

  @override
  Future<void> cancel(String timelineItemId) async {
    final payload = _payloadFor(timelineItemId);
    final pending = await _notifications.pendingNotificationRequests();
    for (final request in pending) {
      if (request.payload == payload) {
        await _notifications.cancel(request.id);
      }
    }
  }

  @override
  Future<void> reconcile(Iterable<TimelineItem> items) async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final notificationsEnabled = await android?.areNotificationsEnabled();
    if (notificationsEnabled == false) {
      return;
    }

    final pending = await _notifications.pendingNotificationRequests();
    for (final request in pending) {
      if (request.payload?.startsWith(_payloadPrefix) ?? false) {
        await _notifications.cancel(request.id);
      }
    }

    for (final item in items) {
      if (item.reminderAt == null) {
        continue;
      }
      if (item.reminderRecurrence != TimelineReminderRecurrence.none &&
          !_localTimezoneReady) {
        throw StateError('Local timezone is required for recurring reminders.');
      }
      final scheduledAt = _nextScheduledAt(item);
      if (scheduledAt != null) {
        await _scheduleWithoutPermission(item, scheduledAt: scheduledAt);
      }
    }
  }

  Future<bool> _ensurePermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) {
      return true;
    }

    final enabled = await android.areNotificationsEnabled();
    if (enabled == true) {
      return true;
    }

    final granted = await android.requestNotificationsPermission();
    return granted ?? true;
  }

  tz.TZDateTime? _nextScheduledAt(TimelineItem item) {
    final reminderAt = item.reminderAt;
    if (reminderAt == null) {
      return null;
    }

    if (item.reminderRecurrence == TimelineReminderRecurrence.none) {
      if (!reminderAt.isAfter(_clock())) {
        return null;
      }
      return tz.TZDateTime.from(reminderAt.toUtc(), tz.UTC);
    }

    if (!_localTimezoneReady) {
      return null;
    }

    final now = tz.TZDateTime.from(_clock().toUtc(), tz.local);
    final anchor = reminderAt.isUtc
        ? tz.TZDateTime.from(reminderAt, tz.local)
        : tz.TZDateTime(
            tz.local,
            reminderAt.year,
            reminderAt.month,
            reminderAt.day,
            reminderAt.hour,
            reminderAt.minute,
            reminderAt.second,
            reminderAt.millisecond,
            reminderAt.microsecond,
          );

    switch (item.reminderRecurrence) {
      case TimelineReminderRecurrence.none:
        return null;
      case TimelineReminderRecurrence.daily:
        var candidate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          anchor.hour,
          anchor.minute,
          anchor.second,
          anchor.millisecond,
          anchor.microsecond,
        );
        if (!candidate.isAfter(now)) {
          candidate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day + 1,
            anchor.hour,
            anchor.minute,
            anchor.second,
            anchor.millisecond,
            anchor.microsecond,
          );
        }
        return candidate;
      case TimelineReminderRecurrence.weekly:
        var daysUntil = (anchor.weekday - now.weekday) % DateTime.daysPerWeek;
        var candidate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day + daysUntil,
          anchor.hour,
          anchor.minute,
          anchor.second,
          anchor.millisecond,
          anchor.microsecond,
        );
        if (!candidate.isAfter(now)) {
          daysUntil += DateTime.daysPerWeek;
          candidate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day + daysUntil,
            anchor.hour,
            anchor.minute,
            anchor.second,
            anchor.millisecond,
            anchor.microsecond,
          );
        }
        return candidate;
    }
  }

  Future<void> _scheduleWithoutPermission(
    TimelineItem item, {
    required tz.TZDateTime scheduledAt,
  }) async {
    final pending = await _notifications.pendingNotificationRequests();
    final payload = _payloadFor(item.id);
    int? existingId;
    final usedIds = <int>{};

    for (final request in pending) {
      if (request.payload == payload) {
        existingId ??= request.id;
      } else {
        usedIds.add(request.id);
      }
    }

    if (existingId != null) {
      await _notifications.cancel(existingId);
    }

    final notificationId = existingId ?? _allocateNotificationId(item.id, usedIds);

    await _notifications.zonedSchedule(
      notificationId,
      'یادآور یادنگار',
      item.text,
      scheduledAt,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: _matchDateTimeComponents(item.reminderRecurrence),
      payload: payload,
    );
  }

  DateTimeComponents? _matchDateTimeComponents(
    TimelineReminderRecurrence recurrence,
  ) {
    return switch (recurrence) {
      TimelineReminderRecurrence.none => null,
      TimelineReminderRecurrence.daily => DateTimeComponents.time,
      TimelineReminderRecurrence.weekly => DateTimeComponents.dayOfWeekAndTime,
    };
  }

  int _allocateNotificationId(String timelineItemId, Set<int> usedIds) {
    var candidate = _stableId(timelineItemId);
    while (usedIds.contains(candidate)) {
      candidate = candidate == 0x7fffffff ? 1 : candidate + 1;
    }
    return candidate;
  }

  int _stableId(String value) {
    var hash = 0x811c9dc5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  String _payloadFor(String timelineItemId) => '$_payloadPrefix$timelineItemId';
}
