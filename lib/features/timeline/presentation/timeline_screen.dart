import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({
    super.key,
    this.items = const <TimelineItem>[],
    this.isLoading = false,
    this.errorMessage,
    this.onQuickCapture,
  });

  final List<TimelineItem> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onQuickCapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('یادنگار'),
        centerTitle: false,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('quick-capture-action'),
        onPressed: onQuickCapture,
        tooltip: 'ثبت سریع',
        icon: const Icon(Icons.add),
        label: const Text('ثبت سریع'),
      ),
    );
  }

  Widget _buildBody() {
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
