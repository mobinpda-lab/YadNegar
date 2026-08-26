import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/settings/font_settings_page.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({
    super.key,
    this.items = const <TimelineItem>[],
    this.isLoading = false,
    this.errorMessage,
    this.onQuickCapture,
    this.onItemTap,
    this.searchController,
    this.selectedFilterType,
    this.hasActiveSearch = false,
    this.onSearchChanged,
    this.onTypeFilterChanged,
    this.onClearSearch,
  });

  final List<TimelineItem> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onQuickCapture;
  final ValueChanged<TimelineItem>? onItemTap;
  final TextEditingController? searchController;
  final TimelineItemType? selectedFilterType;
  final bool hasActiveSearch;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<TimelineItemType?>? onTypeFilterChanged;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('یادنگار'),
        centerTitle: false,
        actions: [
          IconButton(
            key: const Key('font-settings-action'),
            tooltip: 'تنظیم فونت',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const FontSettingsPage(),
              ),
            ),
            icon: const Icon(Icons.text_fields_outlined),
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

  Widget _buildPageBody() {
    if (searchController == null || onSearchChanged == null) {
      return _buildContent();
    }

    return Column(
      children: [
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
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
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
                  tooltip: 'پاک کردن جستجو و فیلتر',
                  onPressed: onClearSearch,
                  icon: const Icon(Icons.clear),
                ),
              ],
            ],
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
                'عبارت جستجو یا فیلتر نوع را تغییر دهید.',
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
            subtitle: Text(_typeLabel(item.type)),
            trailing: onItemTap == null ? null : const Icon(Icons.chevron_left),
            onTap: onItemTap == null ? null : () => onItemTap!(item),
          ),
        );
      },
    );
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
