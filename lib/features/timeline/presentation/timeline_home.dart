import 'package:flutter/material.dart';
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

class _QuickCaptureDraft {
  const _QuickCaptureDraft({required this.text, required this.type});

  final String text;
  final TimelineItemType type;
}

class TimelineHome extends StatefulWidget {
  const TimelineHome({
    super.key,
    required this.quickCapture,
    required this.loadTimeline,
    this.editTimelineItem,
    this.searchTimeline,
    this.filterTimelineByDateRange,
    this.dateRangePicker,
  });

  final QuickCapture quickCapture;
  final LoadTimeline loadTimeline;
  final EditTimelineItem? editTimelineItem;
  final SearchTimeline? searchTimeline;
  final FilterTimelineByDateRange? filterTimelineByDateRange;
  final TimelineDateRangePicker? dateRangePicker;

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
                  setDialogState(() => selectedType = type);
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
                _QuickCaptureDraft(text: draft, type: selectedType),
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
    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('ویرایش ${_typeLabel(item.type)}'),
        content: TextFormField(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('انصراف'),
          ),
          FilledButton(
            key: const Key('timeline-edit-save'),
            onPressed: () => Navigator.of(dialogContext).pop(draft),
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );

    if (text == null) {
      return;
    }

    try {
      await editTimelineItem.updateText(id: item.id, text: text);
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
