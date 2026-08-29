import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/manage_taxonomy.dart';
import 'package:yadnegar/features/timeline/presentation/taxonomy_management_screen.dart';

class TimelineToolsHub extends StatelessWidget {
  const TimelineToolsHub({
    super.key,
    required this.manageTaxonomy,
    required this.legacyTimeline,
  });

  final ManageTaxonomy manageTaxonomy;
  final Widget legacyTimeline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('ابزارها و تنظیمات'), backgroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.white,
            child: ListTile(
              key: const Key('taxonomy-management-entry'),
              leading: const Icon(Icons.sell_outlined),
              title: const Text('دسته‌بندی‌ها و تگ‌ها'),
              subtitle: const Text('افزودن، ویرایش و حذف دسته‌بندی‌ها و تگ‌ها'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => TaxonomyManagementScreen(manageTaxonomy: manageTaxonomy),
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.tune),
              title: const Text('ابزارهای خط زمانی'),
              subtitle: const Text('فیلترها و ابزارهای قدیمی یادنگار'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(builder: (_) => legacyTimeline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
