import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yadnegar/features/timeline/application/export_timeline_text.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_backup_scope.dart';

typedef TimelineClipboardWriter = Future<void> Function(String text);

class TimelineScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final backupScope = TimelineBackupScope.maybeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('یادنگار'),
        centerTitle: false,
        actions: [
          if (backupScope != null)
            IconButton(
              key: const Key('timeline-backup-action'),
              tooltip: 'پشتیبان‌گیری',
              onPressed: isLoading
                  ? null
                  : () => _shareBackup(context, backupScope.backupAction),
              icon: const Icon(Icons.backup_outlined),
            ),
          IconButton(
            key: const Key('timeline-export-action'),
            tooltip: 'کپی موارد نمایش‌داده‌شده',
            onPressed: isLoading ? null : () => _copyExport(context),
            icon: const Icon(Icons.copy_all_outlined),
          ),
        ],
      ),
      body: _buildPageBody(),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('quick-capture-action'),
        onPressed: onQuickCapture,
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
    final text = const ExportTimelineText().export(items);
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('موردی برای کپی وجود ندارد.')),
      );
      return;
    }

    try {
      final writer = clipboardWriter ?? _writeClipboard;
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
    final hasSearchControls = searchController != null && onSearchChanged != null;
    final hasDateControls = onDateRangeTap != null;

    if (!hasSearchControls && !hasDateControls) {
      return _buildContent();
    }

    return Column(
      children: [
        if (hasSearchControls) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              key: const Key('timeline-search-input'),
              controller: searchController,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'جستجو در یادنگار',
                hintText: 'متن مورد را جستجو کنید',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
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
                    value: selectedFilterType,
                    hint: const Text('همه انواع'),
                    isExpanded: true,
                    items: TimelineItemType.values
                        .map(
                          (type) => DropdownMenuItem<TimelineItemType>(
                            value: type,
                            child: Text(_typeLabel(type)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: onTypeFilterChanged,
                  ),
                ),
                if (hasActiveSearch) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    key: const Key('timeline-search-clear'),
                    tooltip: 'پاک کردن جستجو و فیلترها',
                    onPressed: onClearSearch,
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (hasDateControls)
          Padding(
            padding: EdgeInsets.fromLTRB(16, hasSearchControls ? 0 : 12, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const Key('timeline-date-filter'),
                onPressed: onDateRangeTap,
                icon: const Icon(Icons.date_range),
                label: Text(dateRangeLabel ?? 'فیلتر بازه زمانی'),
              ),
            ),
          ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('timeline-loading')),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            errorMessage!,
            key: const Key('timeline-error'),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (items.isEmpty && hasActiveSearch) {
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

    if (items.isEmpty) {
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
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          key: Key('timeline-item-${item.id}'),
          child: ListTile(
            leading: const Icon(Icons.notes),
            title: Text(item.text),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_typeLabel(item.type)),
                const SizedBox(height: 2),
                Text(
                  _timelineTimeLabel(item),
                  key: Key('timeline-time-${item.id}'),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: onItemTap == null ? null : const Icon(Icons.chevron_left),
            onTap: onItemTap == null ? null : () => onItemTap!(item),
          ),
        );
      },
    );
  }

  String _timelineTimeLabel(TimelineItem item) {
    final prefix = item.occurredAt == null ? 'زمان ثبت' : 'زمان رخداد';
    return '$prefix: ${_formatDateTime(item.timelineAt)}';
  }

  String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.year}/$month/$day - $hour:$minute';
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
}
