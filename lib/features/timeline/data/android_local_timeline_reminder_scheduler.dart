import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

class AndroidLocalTimelineReminderScheduler implements TimelineReminderScheduler {
  AndroidLocalTimelineReminderScheduler({
    required FlutterLocalNotificationsPlugin notifications,
    required DateTime Function() clock,
  })  : _notifications = notifications,
        _clock = clock;

  static const String _payloadPrefix = 'yadnegar:timeline:';
  static const String _channelId = 'timeline_reminders';
  static const String _channelName = 'یادآورهای یادنگار';
  static const String _channelDescription = 'یادآور موارد ثبت‌شده در یادنگار';

  final FlutterLocalNotificationsPlugin _notifications;
  final DateTime Function() _clock;

  @override
  Future<TimelineReminderScheduleResult> schedule(TimelineItem item) async {
    final reminderAt = item.reminderAt;
    if (reminderAt == null || !reminderAt.isAfter(_clock())) {
      await cancel(item.id);
      return TimelineReminderScheduleResult.skippedPast;
    }

    if (!await _ensurePermission()) {
      return TimelineReminderScheduleResult.permissionDenied;
    }

    await _scheduleWithoutPermission(item);
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

    final now = _clock();
    for (final item in items) {
      final reminderAt = item.reminderAt;
      if (reminderAt != null && reminderAt.isAfter(now)) {
        await _scheduleWithoutPermission(item);
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

  Future<void> _scheduleWithoutPermission(TimelineItem item) async {
    final reminderAt = item.reminderAt;
    if (reminderAt == null) {
      return;
    }

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
    final scheduledAt = tz.TZDateTime.from(reminderAt.toUtc(), tz.UTC);

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
      payload: payload,
    );
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
