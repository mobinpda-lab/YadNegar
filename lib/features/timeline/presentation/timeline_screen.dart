import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yadnegar/features/timeline/application/export_timeline_text.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_backup_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_item_type_presentation.dart';

typedef TimelineClipboardWriter = Future<void> Function(String text);

enum TimelineReminderPresenceFilter {
  all,
  withReminder,
  withoutReminder,
}

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    super.key,
    this.items = const <TimelineItem>[],
    this.isLoading = false,
    this.errorMessage,
    this.onQuickCapture,
    this.onItemTap,
    this.clipboardWriter,
    this.searchController,
    this.selectedFilterType,
    this.hasActiveSearch = false,
    this.onSearchChanged,
    this.onTypeFilterChanged,
    this.onClearSearch,
    this.dateRangeLabel,
    this.onDateRangeTap,
    this.onDateRangeClear,
    this.onRestoreSnapshot,
  });

  final List<TimelineItem> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onQuickCapture;
  final ValueChanged<TimelineItem>? onItemTap;
  final TimelineClipboardWriter? clipboardWriter;
  final TextEditingController? searchController;
  final TimelineItemType? selectedFilterType;
  final bool hasActiveSearch;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<TimelineItemType?>? onTypeFilterChanged;
  final VoidCallback? onClearSearch;
  final String? dateRangeLabel;
  final VoidCallback? onDateRangeTap;
  final VoidCallback? onDateRangeClear;
  final VoidCallback? onRestoreSnapshot;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  TimelineReminderPresenceFilter _reminderFilter =
      TimelineReminderPresenceFilter.all;

  bool get _hasReminderFilter =>
      _reminderFilter != TimelineReminderPresenceFilter.all;

  bool get _hasActiveSearch => widget.hasActiveSearch || _hasReminderFilter;

  List<TimelineItem> get _visibleItems {
    final matches = widget.items.where((item) {
      return switch (_reminderFilter) {
        TimelineReminderPresenceFilter.all => true,
        TimelineReminderPresenceFilter.withReminder => item.reminderAt != null,
        TimelineReminderPresenceFilter.withoutReminder => item.reminderAt == null,
      };
    }).toList(growable: false);
    return List<TimelineItem>.unmodifiable(matches);
  }

  @override
  Widget build(BuildContext context) {
    final backupScope = TimelineBackupScope.maybeOf(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'بسم الله الرحمن الرحیم',
              key: const Key('home-bismillah'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            const Text('یادنگار'),
          ],
        ),
        centerTitle: true,
        actions: [
          if (widget.onRestoreSnapshot != null)
            IconButton(
              key: const Key('timeline-restore-action'),
              tooltip: 'بازیابی پشتیبان',
              onPressed: widget.isLoading ? null : widget.onRestoreSnapshot,
              icon: const Icon(Icons.restore_page_outlined),
            ),
          if (backupScope != null)
            IconButton(
              key: const Key('timeline-backup-action'),
              tooltip: 'پشتیبان‌گیری',
              onPressed: widget.isLoading
                  ? null
                  : () => _shareBackup(context, backupScope.backupAction),
              icon: const Icon(Icons.backup_outlined),
            ),
          IconButton(
            key: const Key('timeline-export-action'),
            tooltip: 'کپی موارد نمایش‌داده‌شده',
            onPressed: widget.isLoading ? null : () => _copyExport(context),
            icon: const Icon(Icons.copy_all_outlined),
          ),
        ],
      ),
      body: _buildPageBody(),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('quick-capture-action'),
        onPressed: widget.onQuickCapture,
        tooltip: 'ثبت سریع',
        icon: const Icon(Icons.add),
        label: const Text('ثبت سریع'),
      ),
    );
  }

  Future<void> _shareBackup(
    BuildContext context,
    TimelineBackupAction backupAction,
  ) async {
    try {
      await backupAction();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فایل پشتیبان برای اشتراک‌گذاری آماده شد.')),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('پشتیبان‌گیری انجام نشد.')),
      );
    }
  }

  Future<void> _copyExport(BuildContext context) async {
    final text = const ExportTimelineText().export(_visibleItems);
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('موردی برای کپی وجود ندارد.')),
      );
      return;
    }

    try {
      final writer = widget.clipboardWriter ?? _writeClipboard;
      await writer(text);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خروجی Timeline کپی شد.')),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کپی خروجی انجام نشد.')),
      );
    }
  }

  Future<void> _writeClipboard(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  Widget _buildPageBody() {
    final hasSearchControls =
        widget.searchController != null && widget.onSearchChanged != null;
    final hasDateControls = widget.onDateRangeTap != null;
    final hasReminderControls = widget.items.isNotEmpty || _hasReminderFilter;

    if (!hasSearchControls && !hasDateControls && !hasReminderControls) {
      return _buildContent();
    }

    return Column(
      children: [
        if (hasSearchControls) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              key: const Key('timeline-search-input'),
              controller: widget.searchController,
              onChanged: widget.onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: 'جستجو در یادنگار',
                hintText: 'متن مورد را جستجو کنید',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: widget.searchController!.text.isEmpty
                    ? null
                    : IconButton(
                        key: const Key('timeline-query-clear'),
                        tooltip: 'پاک کردن متن جستجو',
                        onPressed: () {
                          widget.searchController!.clear();
                          widget.onSearchChanged?.call('');
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                const Text('نوع:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<TimelineItemType>(
                    key: const Key('timeline-type-filter'),
                    value: widget.selectedFilterType,
                    hint: const Text('همه انواع'),
                    isExpanded: true,
                    items: <DropdownMenuItem<TimelineItemType>>[
                      const DropdownMenuItem<TimelineItemType>(
                        value: null,
                        child: Text('همه انواع'),
                      ),
                      ...TimelineItemType.values.map(
                        (type) => DropdownMenuItem<TimelineItemType>(
                          value: type,
                          child: TimelineItemTypeOption(type: type),
                        ),
                      ),
                    ],
                    onChanged: widget.onTypeFilterChanged,
                  ),
                ),
                if (_hasActiveSearch) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    key: const Key('timeline-search-clear'),
                    tooltip: 'پاک کردن جستجو و فیلترها',
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (hasReminderControls)
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              hasSearchControls ? 0 : 12,
              16,
              4,
            ),
            child: Row(
              children: [
                const Text('یادآور:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<TimelineReminderPresenceFilter>(
                    key: const Key('timeline-reminder-filter'),
                    value: _reminderFilter,
                    isExpanded: true,
                    items: TimelineReminderPresenceFilter.values
                        .map(
                          (filter) => DropdownMenuItem<
                              TimelineReminderPresenceFilter>(
                            value: filter,
                            child: Text(_reminderFilterLabel(filter)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (filter) {
                      if (filter == null) {
                        return;
                      }
                      setState(() {
                        _reminderFilter = filter;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        if (hasDateControls)
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              hasSearchControls || hasReminderControls ? 0 : 12,
              16,
              8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('timeline-date-filter'),
                    onPressed: widget.onDateRangeTap,
                    icon: const Icon(Icons.date_range),
                    label: Text(widget.dateRangeLabel ?? 'فیلتر بازه زمانی'),
                  ),
                ),
                if (widget.dateRangeLabel != null &&
                    widget.onDateRangeClear != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    key: const Key('timeline-date-filter-clear'),
                    tooltip: 'پاک کردن بازه زمانی',
                    onPressed: widget.onDateRangeClear,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),
          ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _reminderFilter = TimelineReminderPresenceFilter.all;
    });
    widget.onClearSearch?.call();
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('timeline-loading')),
      );
    }

    if (widget.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            widget.errorMessage!,
            key: const Key('timeline-error'),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final visibleItems = _visibleItems;

    if (visibleItems.isEmpty && _hasActiveSearch) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48),
              SizedBox(height: 16),
              Text(
                'نتیجه‌ای پیدا نشد',
                key: Key('timeline-search-empty-state'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'عبارت جستجو یا فیلترها را تغییر دهید.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (visibleItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timeline, size: 48),
              SizedBox(height: 16),
              Text(
                'هنوز چیزی ثبت نشده',
                key: Key('timeline-empty-state'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Timeline یادنگار پس از ثبت اولین مورد از همین‌جا شروع می‌شود.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      key: const Key('timeline-list'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: visibleItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = visibleItems[index];
        final reminderLabel = _reminderLabel(item);
        return Card(
          key: Key('timeline-item-${item.id}'),
          child: ListTile(
            leading: Icon(
              timelineItemTypeIcon(item.type),
              key: Key('timeline-type-icon-${item.id}'),
            ),
            title: Text(item.text),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timelineItemTypeLabel(item.type)),
                const SizedBox(height: 2),
                Text(
                  _timelineTimeLabel(item),
                  key: Key('timeline-time-${item.id}'),
                ),
                if (reminderLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    reminderLabel,
                    key: Key('timeline-reminder-${item.id}'),
                  ),
                ],
              ],
            ),
            isThreeLine: true,
            trailing: widget.onItemTap == null
                ? null
                : const Icon(Icons.chevron_left),
            onTap: widget.onItemTap == null
                ? null
                : () => widget.onItemTap!(item),
          ),
        );
      },
    );
  }

  String _timelineTimeLabel(TimelineItem item) {
    final prefix = item.occurredAt == null ? 'زمان ثبت' : 'زمان رخداد';
    return '$prefix: ${_formatDateTime(item.timelineAt)}';
  }

  String? _reminderLabel(TimelineItem item) {
    final reminderAt = item.reminderAt;
    if (reminderAt == null) {
      return null;
    }

    return switch (item.reminderRecurrence) {
      TimelineReminderRecurrence.none =>
        'یادآور: ${_formatDateTime(reminderAt)}',
      TimelineReminderRecurrence.daily =>
        'یادآور: روزانه - ${_formatTime(reminderAt)}',
      TimelineReminderRecurrence.weekly =>
        'یادآور: هفتگی - ${_weekdayLabel(reminderAt.weekday)} - ${_formatTime(reminderAt)}',
    };
  }

  String _reminderFilterLabel(TimelineReminderPresenceFilter filter) {
    return switch (filter) {
      TimelineReminderPresenceFilter.all => 'همه موارد',
      TimelineReminderPresenceFilter.withReminder => 'دارای یادآور',
      TimelineReminderPresenceFilter.withoutReminder => 'بدون یادآور',
    };
  }

  String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}/$month/$day - ${_formatTime(value)}';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _weekdayLabel(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'دوشنبه',
      DateTime.tuesday => 'سه‌شنبه',
      DateTime.wednesday => 'چهارشنبه',
      DateTime.thursday => 'پنجشنبه',
      DateTime.friday => 'جمعه',
      DateTime.saturday => 'شنبه',
      DateTime.sunday => 'یکشنبه',
      _ => '',
    };
  }
}
