import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

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
  });

  final QuickCapture quickCapture;
  final LoadTimeline loadTimeline;
  final EditTimelineItem? editTimelineItem;
  final SearchTimeline? searchTimeline;

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
  int _loadGeneration = 0;

  bool get _hasActiveSearch => _query.trim().isNotEmpty || _filterType != null;

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
      final items = searchTimeline == null
          ? await widget.loadTimeline.load()
          : await searchTimeline.search(query: _query, type: _filterType);

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

  void _clearSearch() {
    _searchController.clear();
    _query = '';
    _filterType = null;
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
      onClearSearch: widget.searchTimeline == null ? null : _clearSearch,
    );
  }
}
