import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/restore_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_snapshot_restore_action.dart';

typedef TimelineDateRangePicker = Future<DateTimeRange?> Function(
  BuildContext context,
  DateTimeRange? initialRange,
);

typedef TimelineOccurredAtPicker = Future<DateTime?> Function(
  BuildContext context,
  DateTime initialDateTime,
);

typedef TimelineReminderAtPicker = Future<DateTime?> Function(
  BuildContext context,
  DateTime initialDateTime,
);

class _QuickCaptureDraft {
  const _QuickCaptureDraft({
    required this.text,
    required this.type,
    this.occurredAt,
    this.reminderAt,
  });

  final String text;
  final TimelineItemType type;
  final DateTime? occurredAt;
  final DateTime? reminderAt;
}

class _EditTimelineDraft {
  const _EditTimelineDraft({
    required this.text,
    required this.replaceOccurredAt,
    required this.replaceReminderAt,
    this.replacementType,
    this.occurredAt,
    this.reminderAt,
    this.deleteRequested = false,
  });

  final String text;
  final TimelineItemType? replacementType;
  final bool replaceOccurredAt;
  final DateTime? occurredAt;
  final bool replaceReminderAt;
  final DateTime? reminderAt;
  final bool deleteRequested;
}

class TimelineHome extends StatefulWidget {
  const TimelineHome({
    super.key,
    required this.quickCapture,
    required this.loadTimeline,
    this.editTimelineItem,
    this.deleteTimelineItem,
    this.restoreTimelineItem,
    this.restoreTimelineSnapshot,
    this.searchTimeline,
    this.filterTimelineByDateRange,
    this.dateRangePicker,
    this.occurredAtPicker,
    this.reminderAtPicker,
    this.reminderScheduler,
  });

  final QuickCapture quickCapture;
  final LoadTimeline loadTimeline;
  final EditTimelineItem? editTimelineItem;
  final DeleteTimelineItem? deleteTimelineItem;
  final RestoreTimelineItem? restoreTimelineItem;
  final TimelineSnapshotRestoreAction? restoreTimelineSnapshot;
  final SearchTimeline? searchTimeline;
  final FilterTimelineByDateRange? filterTimelineByDateRange;
  final TimelineDateRangePicker? dateRangePicker;
  final TimelineOccurredAtPicker? occurredAtPicker;
  final TimelineReminderAtPicker? reminderAtPicker;
  final TimelineReminderScheduler? reminderScheduler;

  @override
  State<TimelineHome> createState() => _TimelineHomeState();
}

class _TimelineHomeState extends State<TimelineHome> {
  final TextEditingController _searchController = TextEditingController();

  List<TimelineItem> _items = const <TimelineItem>[];
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';
  TimelineItemType? _filterType;
  DateTime? _dateStart;
  DateTime? _dateEndExclusive;
  int _loadGeneration = 0;

  bool get _hasSearchQueryOrType => _query.trim().isNotEmpty || _filterType != null;

  bool get _hasDateRange => _dateStart != null && _dateEndExclusive != null;

  bool get _hasActiveSearch => _hasSearchQueryOrType || _hasDateRange;

  DateTimeRange? get _selectedDateRange {
    if (!_hasDateRange) {
      return null;
    }
    return DateTimeRange(
      start: _dateStart!,
      end: _dateEndExclusive!.subtract(const Duration(days: 1)),
    );
  }

  String? get _dateRangeLabel {
    final range = _selectedDateRange;
    if (range == null) {
      return null;
    }
    return '${_formatDate(range.start)} تا ${_formatDate(range.end)}';
  }

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final generation = ++_loadGeneration;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final searchTimeline = widget.searchTimeline;
      final dateFilter = widget.filterTimelineByDateRange;
      late final List<TimelineItem> items;

      if (_hasDateRange && dateFilter != null) {
        final dateItems = await dateFilter.filter(
          start: _dateStart,
          end: _dateEndExclusive,
        );

        if (_hasSearchQueryOrType && searchTimeline != null) {
          final searchItems = await searchTimeline.search(
            query: _query,
            type: _filterType,
          );
          final dateIds = dateItems.map((item) => item.id).toSet();
          items = List<TimelineItem>.unmodifiable(
            searchItems.where((item) => dateIds.contains(item.id)),
          );
        } else {
          items = dateItems;
        }
      } else if (searchTimeline != null) {
        items = await searchTimeline.search(query: _query, type: _filterType);
      } else {
        items = await widget.loadTimeline.load();
      }

      if (!mounted || generation != _loadGeneration) {
        return;
      }
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || generation != _loadGeneration) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'بارگذاری Timeline انجام نشد.';
      });
    }
  }

  void _onSearchChanged(String value) {
    _query = value;
    _reload();
  }

  void _onTypeFilterChanged(TimelineItemType? type) {
    _filterType = type;
    _reload();
  }

  Future<void> _openDateRangeFilter() async {
    final picker = widget.dateRangePicker ?? _showDateRangePicker;
    final range = await picker(context, _selectedDateRange);
    if (range == null || !mounted) {
      return;
    }

    setState(() {
      _dateStart = _startOfDay(range.start);
      _dateEndExclusive = _startOfDay(range.end).add(const Duration(days: 1));
    });
    await _reload();
  }

  Future<DateTimeRange?> _showDateRangePicker(
    BuildContext context,
    DateTimeRange? initialRange,
  ) {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: initialRange,
      helpText: 'انتخاب بازه زمانی',
      cancelText: 'انصراف',
      confirmText: 'اعمال',
      saveText: 'اعمال',
    );
  }

  Future<DateTime?> _showOccurredAtPicker(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: initialDateTime,
      helpText: 'تاریخ رویداد یا فعالیت',
      cancelText: 'انصراف',
      confirmText: 'بعدی',
    );
    if (date == null || !context.mounted) {
      return null;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
      helpText: 'زمان رویداد یا فعالیت',
      cancelText: 'انصراف',
      confirmText: 'اعمال',
    );
    if (time == null) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<DateTime?> _showReminderAtPicker(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    final now = DateTime.now();
    final initialDate = initialDateTime.isBefore(now) ? now : initialDateTime;
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
      initialDate: initialDate,
      helpText: 'تاریخ یادآور',
      cancelText: 'انصراف',
      confirmText: 'بعدی',
    );
    if (date == null || !context.mounted) {
      return null;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
      helpText: 'زمان یادآور',
      cancelText: 'انصراف',
      confirmText: 'اعمال',
    );
    if (time == null) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime _startOfDay(DateTime value) {
    if (value.isUtc) {
      return DateTime.utc(value.year, value.month, value.day);
    }
    return DateTime(value.year, value.month, value.day);
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}/$month/$day';
  }

  String _formatDateTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${_formatDate(value)} - $hour:$minute';
  }

  bool _supportsOccurredAt(TimelineItemType type) {
    return type == TimelineItemType.event || type == TimelineItemType.activity;
  }

  bool _isFutureReminder(DateTime? value) {
    return value == null || value.isAfter(DateTime.now());
  }

  Future<String?> _scheduleReminder(TimelineItem item) async {
    final scheduler = widget.reminderScheduler;
    if (scheduler == null || item.reminderAt == null) {
      return null;
    }

    try {
      final result = await scheduler.schedule(item);
      return switch (result) {
        TimelineReminderScheduleResult.scheduled => null,
        TimelineReminderScheduleResult.permissionDenied =>
          'مورد ذخیره شد، اما اجازه نمایش اعلان یادآور داده نشد.',
        TimelineReminderScheduleResult.skippedPast =>
          'مورد ذخیره شد، اما زمان یادآور باید در آینده باشد.',
      };
    } catch (_) {
      return 'مورد ذخیره شد، اما تنظیم اعلان یادآور انجام نشد.';
    }
  }

  Future<String?> _cancelReminder(String timelineItemId) async {
    final scheduler = widget.reminderScheduler;
    if (scheduler == null) {
      return null;
    }
    try {
      await scheduler.cancel(timelineItemId);
      return null;
    } catch (_) {
      return 'تغییر ذخیره شد، اما همگام‌سازی یادآور کامل نشد.';
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearSearch() {
    _searchController.clear();
    _query = '';
    _filterType = null;
    _dateStart = null;
    _dateEndExclusive = null;
    _reload();
  }

  Future<void> _openSnapshotRestore() async {
    final restoreTimelineSnapshot = widget.restoreTimelineSnapshot;
    if (restoreTimelineSnapshot == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('بازیابی فایل پشتیبان؟'),
        content: const Text(
          'اطلاعات فعلی یادنگار با محتوای فایل پشتیبان جایگزین می‌شود. فایل پیش از جایگزینی اعتبارسنجی خواهد شد.',
        ),
        actions: [
          TextButton(
            key: const Key('timeline-restore-cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            key: const Key('timeline-restore-confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('انتخاب و بازیابی'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    try {
      final result = await restoreTimelineSnapshot();
      if (!mounted) {
        return;
      }

      switch (result) {
        case TimelineSnapshotRestoreResult.cancelled:
          return;
        case TimelineSnapshotRestoreResult.restored:
          await _reload();
          if (!mounted) {
            return;
          }
          _showMessage('فایل پشتیبان با موفقیت بازیابی شد.');
          return;
        case TimelineSnapshotRestoreResult.invalidBackup:
          _showMessage('فایل پشتیبان معتبر نیست.');
          return;
        case TimelineSnapshotRestoreResult.unsupportedSchema:
          _showMessage('نسخه این فایل پشتیبان پشتیبانی نمی‌شود.');
          return;
        case TimelineSnapshotRestoreResult.duplicateId:
          _showMessage('فایل پشتیبان شامل شناسه‌های تکراری است.');
          return;
      }
    } catch (_) {
      _showMessage('بازیابی فایل پشتیبان انجام نشد.');
    }
  }

  Future<void> _openQuickCapture() async {
    var draft = '';
    var selectedType = TimelineItemType.note;
    DateTime? occurredAt;
    DateTime? reminderAt;

    final captureDraft = await showDialog<_QuickCaptureDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('ثبت سریع'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('نوع مورد'),
                const SizedBox(height: 4),
                DropdownButton<TimelineItemType>(
                  key: const Key('quick-capture-type'),
                  value: selectedType,
                  isExpanded: true,
                  items: TimelineItemType.values
                      .map(
                        (type) => DropdownMenuItem<TimelineItemType>(
                          value: type,
                          child: Text(_typeLabel(type)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (type) {
                    if (type == null) {
                      return;
                    }
                    setDialogState(() {
                      selectedType = type;
                      if (!_supportsOccurredAt(type)) {
                        occurredAt = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('quick-capture-input'),
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (value) => draft = value,
                  decoration: const InputDecoration(
                    hintText: 'چه چیزی را می‌خواهید به خاطر بسپارید؟',
                  ),
                ),
                if (_supportsOccurredAt(selectedType)) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    key: const Key('quick-capture-occurred-at'),
                    onPressed: () async {
                      final picker = widget.occurredAtPicker ?? _showOccurredAtPicker;
                      final value = await picker(
                        dialogContext,
                        occurredAt ?? DateTime.now(),
                      );
                      if (value == null || !dialogContext.mounted) {
                        return;
                      }
                      setDialogState(() => occurredAt = value);
                    },
                    icon: const Icon(Icons.event),
                    label: Text(
                      occurredAt == null
                          ? 'تاریخ و زمان (اختیاری)'
                          : _formatDateTime(occurredAt!),
                    ),
                  ),
                  if (occurredAt != null)
                    TextButton(
                      key: const Key('quick-capture-occurred-at-clear'),
                      onPressed: () => setDialogState(() => occurredAt = null),
                      child: const Text('پاک کردن تاریخ و زمان'),
                    ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('quick-capture-reminder-at'),
                  onPressed: () async {
                    final picker = widget.reminderAtPicker ?? _showReminderAtPicker;
                    final value = await picker(
                      dialogContext,
                      reminderAt ?? DateTime.now().add(const Duration(hours: 1)),
                    );
                    if (value == null || !dialogContext.mounted) {
                      return;
                    }
                    setDialogState(() => reminderAt = value);
                  },
                  icon: const Icon(Icons.notifications_none),
                  label: Text(
                    reminderAt == null
                        ? 'یادآور (اختیاری)'
                        : _formatDateTime(reminderAt!),
                  ),
                ),
                if (reminderAt != null)
                  TextButton(
                    key: const Key('quick-capture-reminder-at-clear'),
                    onPressed: () => setDialogState(() => reminderAt = null),
                    child: const Text('پاک کردن یادآور'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('انصراف'),
            ),
            FilledButton(
              key: const Key('quick-capture-save'),
              onPressed: () => Navigator.of(dialogContext).pop(
                _QuickCaptureDraft(
                  text: draft,
                  type: selectedType,
                  occurredAt: occurredAt,
                  reminderAt: reminderAt,
                ),
              ),
              child: const Text('ثبت'),
            ),
          ],
        ),
      ),
    );

    if (captureDraft == null) {
      return;
    }
    if (!_isFutureReminder(captureDraft.reminderAt)) {
      _showMessage('زمان یادآور باید در آینده باشد.');
      return;
    }

    late final TimelineItem item;
    try {
      item = await widget.quickCapture.capture(
        text: captureDraft.text,
        type: captureDraft.type,
        occurredAt: captureDraft.occurredAt,
        reminderAt: captureDraft.reminderAt,
      );
    } on ArgumentError {
      _showMessage('متن ثبت سریع نمی‌تواند خالی باشد.');
      return;
    } catch (_) {
      _showMessage('ثبت مورد جدید انجام نشد.');
      return;
    }

    final reminderWarning = await _scheduleReminder(item);
    await _reload();
    if (reminderWarning != null) {
      _showMessage(reminderWarning);
    }
  }

  Future<void> _openEdit(TimelineItem item) async {
    final editTimelineItem = widget.editTimelineItem;
    if (editTimelineItem == null) {
      return;
    }

    var draft = item.text;
    var selectedType = item.type;
    var occurredAt = item.occurredAt;
    var reminderAt = item.reminderAt;

    final editDraft = await showDialog<_EditTimelineDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final supportsOccurredAt = _supportsOccurredAt(selectedType);
          return AlertDialog(
            title: Text('ویرایش ${_typeLabel(selectedType)}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('نوع مورد'),
                  const SizedBox(height: 4),
                  DropdownButton<TimelineItemType>(
                    key: const Key('timeline-edit-type'),
                    value: selectedType,
                    isExpanded: true,
                    items: TimelineItemType.values
                        .map(
                          (type) => DropdownMenuItem<TimelineItemType>(
                            value: type,
                            child: Text(_typeLabel(type)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (type) {
                      if (type == null) {
                        return;
                      }
                      setDialogState(() {
                        selectedType = type;
                        if (!_supportsOccurredAt(type)) {
                          occurredAt = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('timeline-edit-input'),
                    initialValue: item.text,
                    autofocus: true,
                    minLines: 1,
                    maxLines: 6,
                    onChanged: (value) => draft = value,
                    decoration: const InputDecoration(labelText: 'متن'),
                  ),
                  if (supportsOccurredAt) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      key: const Key('timeline-edit-occurred-at'),
                      onPressed: () async {
                        final picker = widget.occurredAtPicker ?? _showOccurredAtPicker;
                        final value = await picker(
                          dialogContext,
                          occurredAt ?? item.createdAt,
                        );
                        if (value == null || !dialogContext.mounted) {
                          return;
                        }
                        setDialogState(() => occurredAt = value);
                      },
                      icon: const Icon(Icons.event),
                      label: Text(
                        occurredAt == null
                            ? 'تاریخ و زمان (اختیاری)'
                            : _formatDateTime(occurredAt!),
                      ),
                    ),
                    if (occurredAt != null)
                      TextButton(
                        key: const Key('timeline-edit-occurred-at-clear'),
                        onPressed: () => setDialogState(() => occurredAt = null),
                        child: const Text('پاک کردن تاریخ و زمان'),
                      ),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    key: const Key('timeline-edit-reminder-at'),
                    onPressed: () async {
                      final picker = widget.reminderAtPicker ?? _showReminderAtPicker;
                      final value = await picker(
                        dialogContext,
                        reminderAt ?? DateTime.now().add(const Duration(hours: 1)),
                      );
                      if (value == null || !dialogContext.mounted) {
                        return;
                      }
                      setDialogState(() => reminderAt = value);
                    },
                    icon: const Icon(Icons.notifications_none),
                    label: Text(
                      reminderAt == null
                          ? 'یادآور (اختیاری)'
                          : _formatDateTime(reminderAt!),
                    ),
                  ),
                  if (reminderAt != null)
                    TextButton(
                      key: const Key('timeline-edit-reminder-at-clear'),
                      onPressed: () => setDialogState(() => reminderAt = null),
                      child: const Text('پاک کردن یادآور'),
                    ),
                ],
              ),
            ),
            actions: [
              if (widget.deleteTimelineItem != null)
                TextButton(
                  key: const Key('timeline-edit-delete'),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: dialogContext,
                      builder: (confirmContext) => AlertDialog(
                        title: const Text('حذف این مورد؟'),
                        content: Text(
                          widget.restoreTimelineItem == null
                              ? 'این مورد از یادنگار حذف می‌شود. این کار قابل بازگشت نیست.'
                              : 'این مورد از یادنگار حذف می‌شود. پس از حذف می‌توانید آن را بازگردانید.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(confirmContext).pop(false),
                            child: const Text('انصراف'),
                          ),
                          FilledButton(
                            key: const Key('timeline-delete-confirm'),
                            onPressed: () => Navigator.of(confirmContext).pop(true),
                            child: const Text('حذف'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed != true || !dialogContext.mounted) {
                      return;
                    }
                    Navigator.of(dialogContext).pop(
                      _EditTimelineDraft(
                        text: draft,
                        replacementType: selectedType == item.type ? null : selectedType,
                        replaceOccurredAt: supportsOccurredAt,
                        occurredAt: occurredAt,
                        replaceReminderAt: false,
                        reminderAt: reminderAt,
                        deleteRequested: true,
                      ),
                    );
                  },
                  child: const Text('حذف'),
                ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('انصراف'),
              ),
              FilledButton(
                key: const Key('timeline-edit-save'),
                onPressed: () => Navigator.of(dialogContext).pop(
                  _EditTimelineDraft(
                    text: draft,
                    replacementType: selectedType == item.type ? null : selectedType,
                    replaceOccurredAt: supportsOccurredAt,
                    occurredAt: occurredAt,
                    replaceReminderAt: reminderAt != item.reminderAt,
                    reminderAt: reminderAt,
                  ),
                ),
                child: const Text('ذخیره'),
              ),
            ],
          );
        },
      ),
    );

    if (editDraft == null) {
      return;
    }

    if (editDraft.deleteRequested) {
      final deleteTimelineItem = widget.deleteTimelineItem;
      if (deleteTimelineItem == null) {
        return;
      }
      try {
        final deleted = await deleteTimelineItem.delete(id: item.id);
        if (!mounted) {
          return;
        }
        if (!deleted) {
          _showMessage('مورد برای حذف پیدا نشد.');
          return;
        }
        final reminderWarning = await _cancelReminder(item.id);
        await _reload();
        if (!mounted) {
          return;
        }
        final restoreTimelineItem = widget.restoreTimelineItem;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(reminderWarning ?? 'مورد حذف شد.'),
            action: restoreTimelineItem == null
                ? null
                : SnackBarAction(
                    label: 'بازگردانی',
                    onPressed: () async {
                      try {
                        final restored = await restoreTimelineItem.restore(item);
                        if (!mounted) {
                          return;
                        }
                        if (!restored) {
                          _showMessage('این مورد دیگر قابل بازگردانی نیست.');
                          return;
                        }
                        final warning = await _scheduleReminder(item);
                        await _reload();
                        if (!mounted) {
                          return;
                        }
                        _showMessage(warning ?? 'مورد بازگردانده شد.');
                      } catch (_) {
                        _showMessage('بازگردانی مورد انجام نشد.');
                      }
                    },
                  ),
          ),
        );
      } catch (_) {
        _showMessage('حذف مورد انجام نشد.');
      }
      return;
    }

    if (editDraft.replaceReminderAt && !_isFutureReminder(editDraft.reminderAt)) {
      _showMessage('زمان یادآور باید در آینده باشد.');
      return;
    }

    late final TimelineItem updated;
    try {
      updated = await editTimelineItem.update(
        id: item.id,
        text: editDraft.text,
        type: editDraft.replacementType,
        replaceOccurredAt: editDraft.replaceOccurredAt,
        occurredAt: editDraft.occurredAt,
        replaceReminderAt: editDraft.replaceReminderAt,
        reminderAt: editDraft.reminderAt,
      );
    } on ArgumentError {
      _showMessage('متن ویرایش نمی‌تواند خالی باشد.');
      return;
    } catch (_) {
      _showMessage('ویرایش مورد انجام نشد.');
      return;
    }

    String? reminderWarning;
    if (updated.reminderAt != null) {
      reminderWarning = await _scheduleReminder(updated);
    } else if (item.reminderAt != null) {
      reminderWarning = await _cancelReminder(item.id);
    }
    await _reload();
    if (reminderWarning != null) {
      _showMessage(reminderWarning);
    }
  }

  String _typeLabel(TimelineItemType type) {
    return switch (type) {
      TimelineItemType.note => 'یادداشت',
      TimelineItemType.event => 'رویداد',
      TimelineItemType.call => 'تماس',
      TimelineItemType.idea => 'ایده',
      TimelineItemType.activity => 'فعالیت',
    };
  }

  @override
  Widget build(BuildContext context) {
    return TimelineScreen(
      items: _items,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      onQuickCapture: _isLoading ? null : _openQuickCapture,
      onItemTap: widget.editTimelineItem == null ? null : _openEdit,
      searchController: widget.searchTimeline == null ? null : _searchController,
      selectedFilterType: _filterType,
      hasActiveSearch: _hasActiveSearch,
      onSearchChanged: widget.searchTimeline == null ? null : _onSearchChanged,
      onTypeFilterChanged:
          widget.searchTimeline == null ? null : _onTypeFilterChanged,
      onClearSearch: _hasActiveSearch ? _clearSearch : null,
      dateRangeLabel: _dateRangeLabel,
      onDateRangeTap:
          widget.filterTimelineByDateRange == null ? null : _openDateRangeFilter,
      onRestoreSnapshot:
          widget.restoreTimelineSnapshot == null ? null : _openSnapshotRestore,
    );
  }
}
