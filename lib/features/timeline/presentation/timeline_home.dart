import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/delete_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/filter_timeline_by_date_range.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

typedef TimelineDateRangePicker = Future<DateTimeRange?> Function(
  BuildContext context,
  DateTimeRange? initialRange,
);

typedef TimelineOccurredAtPicker = Future<DateTime?> Function(
  BuildContext context,
  DateTime initialDateTime,
);

class _QuickCaptureDraft {
  const _QuickCaptureDraft({
    required this.text,
    required this.type,
    this.occurredAt,
  });

  final String text;
  final TimelineItemType type;
  final DateTime? occurredAt;
}

class _EditTimelineDraft {
  const _EditTimelineDraft({
    required this.text,
    required this.replaceOccurredAt,
    this.replacementType,
    this.occurredAt,
    this.deleteRequested = false,
  });

  final String text;
  final TimelineItemType? replacementType;
  final bool replaceOccurredAt;
  final DateTime? occurredAt;
  final bool deleteRequested;
}

class TimelineHome extends StatefulWidget {
  const TimelineHome({
    super.key,
    required this.quickCapture,
    required this.loadTimeline,
    this.editTimelineItem,
    this.deleteTimelineItem,
    this.searchTimeline,
    this.filterTimelineByDateRange,
    this.dateRangePicker,
    this.occurredAtPicker,
  });

  final QuickCapture quickCapture;
  final LoadTimeline loadTimeline;
  final EditTimelineItem? editTimelineItem;
  final DeleteTimelineItem? deleteTimelineItem;
  final SearchTimeline? searchTimeline;
  final FilterTimelineByDateRange? filterTimelineByDateRange;
  final TimelineDateRangePicker? dateRangePicker;
  final TimelineOccurredAtPicker? occurredAtPicker;

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

  void _clearSearch() {
    _searchController.clear();
    _query = '';
    _filterType = null;
    _dateStart = null;
    _dateEndExclusive = null;
    _reload();
  }

  Future<void> _openQuickCapture() async {
    var draft = '';
    var selectedType = TimelineItemType.note;
    DateTime? occurredAt;

    final captureDraft = await showDialog<_QuickCaptureDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('ثبت سریع'),
          content: Column(
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
            ],
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

    try {
      await widget.quickCapture.capture(
        text: captureDraft.text,
        type: captureDraft.type,
        occurredAt: captureDraft.occurredAt,
      );
      await _reload();
    } on ArgumentError {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('متن ثبت سریع نمی‌تواند خالی باشد.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ثبت مورد جدید انجام نشد.')),
      );
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

    final editDraft = await showDialog<_EditTimelineDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final supportsOccurredAt = _supportsOccurredAt(selectedType);
          return AlertDialog(
            title: Text('ویرایش ${_typeLabel(selectedType)}'),
            content: Column(
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
                  decoration: const InputDecoration(
                    labelText: 'متن',
                  ),
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
              ],
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
                        content: const Text(
                          'این مورد از یادنگار حذف می‌شود. این کار قابل بازگشت نیست.',
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('مورد برای حذف پیدا نشد.')),
          );
          return;
        }
        await _reload();
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('مورد حذف شد.')),
        );
      } catch (_) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حذف مورد انجام نشد.')),
        );
      }
      return;
    }

    try {
      await editTimelineItem.update(
        id: item.id,
        text: editDraft.text,
        type: editDraft.replacementType,
        replaceOccurredAt: editDraft.replaceOccurredAt,
        occurredAt: editDraft.occurredAt,
      );
      await _reload();
    } on ArgumentError {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('متن ویرایش نمی‌تواند خالی باشد.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ویرایش مورد انجام نشد.')),
      );
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
    );
  }
}
