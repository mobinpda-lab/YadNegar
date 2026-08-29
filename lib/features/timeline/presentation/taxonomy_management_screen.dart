import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/manage_taxonomy.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_taxonomy.dart';

class TaxonomyManagementScreen extends StatefulWidget {
  const TaxonomyManagementScreen({super.key, required this.manageTaxonomy});
  final ManageTaxonomy manageTaxonomy;

  @override
  State<TaxonomyManagementScreen> createState() => _TaxonomyManagementScreenState();
}

class _TaxonomyManagementScreenState extends State<TaxonomyManagementScreen> {
  static const _palette = <int>[0xFF5B4BDB, 0xFF3176D5, 0xFF25A55A, 0xFFE69A17, 0xFFD9516A, 0xFF8A56C6, 0xFF258D8B, 0xFF607D8B];
  List<YadNegarCategory> _categories = const [];
  List<YadNegarTag> _tags = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final values = await Future.wait<Object>([
      widget.manageTaxonomy.listCategories(),
      widget.manageTaxonomy.listTags(),
    ]);
    if (!mounted) return;
    setState(() {
      _categories = values[0] as List<YadNegarCategory>;
      _tags = values[1] as List<YadNegarTag>;
      _loading = false;
    });
  }

  Future<_Draft?> _draftDialog(String title, {String initial = '', int? color}) async {
    final controller = TextEditingController(text: initial);
    var selected = color ?? _palette.first;
    return showDialog<_Draft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: controller, autofocus: true, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'عنوان', border: OutlineInputBorder())),
            const SizedBox(height: 14),
            Wrap(spacing: 10, runSpacing: 10, children: [
              for (final value in _palette)
                InkWell(
                  onTap: () => setDialogState(() => selected = value),
                  child: Container(width: 34, height: 34, decoration: BoxDecoration(color: Color(value), shape: BoxShape.circle, border: selected == value ? Border.all(width: 3) : null)),
                ),
            ]),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('لغو')),
            FilledButton(onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) Navigator.pop(dialogContext, _Draft(value, selected));
            }, child: const Text('ذخیره')),
          ],
        ),
      ),
    );
  }

  Future<void> _category([YadNegarCategory? existing]) async {
    final draft = await _draftDialog(existing == null ? 'دسته‌بندی جدید' : 'ویرایش دسته‌بندی', initial: existing?.title ?? '', color: existing?.colorValue);
    if (draft == null) return;
    if (existing == null) {
      await widget.manageTaxonomy.createCategory(title: draft.title, colorValue: draft.color);
    } else {
      await widget.manageTaxonomy.updateCategory(existing, title: draft.title, colorValue: draft.color);
    }
    await _reload();
  }

  Future<void> _tag([YadNegarTag? existing]) async {
    final draft = await _draftDialog(existing == null ? 'تگ جدید' : 'ویرایش تگ', initial: existing?.title ?? '', color: existing?.colorValue);
    if (draft == null) return;
    if (existing == null) {
      await widget.manageTaxonomy.createTag(title: draft.title, colorValue: draft.color);
    } else {
      await widget.manageTaxonomy.updateTag(existing, title: draft.title, colorValue: draft.color);
    }
    await _reload();
  }

  Future<void> _deleteCategory(YadNegarCategory value) async {
    try {
      await widget.manageTaxonomy.deleteCategory(value.id);
      await _reload();
    } on TaxonomyInUseException {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('این دسته‌بندی در یک یا چند کار استفاده شده و فعلاً قابل حذف نیست.')));
    }
  }

  Future<void> _deleteTag(YadNegarTag value) async {
    try {
      await widget.manageTaxonomy.deleteTag(value.id);
      await _reload();
    } on TaxonomyInUseException {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('این تگ در یک یا چند کار استفاده شده و فعلاً قابل حذف نیست.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('دسته‌بندی‌ها و تگ‌ها'), backgroundColor: Colors.white),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _header('دسته‌بندی‌ها', 'هر کار حداکثر یک دسته‌بندی دارد', () => _category()),
                if (_categories.isEmpty) const _Empty('هنوز دسته‌بندی ساخته نشده است.'),
                for (final value in _categories) _row(value.title, value.colorValue, () => _category(value), () => _deleteCategory(value)),
                const SizedBox(height: 24),
                _header('تگ‌ها', 'هر کار می‌تواند چند تگ داشته باشد', () => _tag()),
                if (_tags.isEmpty) const _Empty('هنوز تگی ساخته نشده است.'),
                for (final value in _tags) _row(value.title, value.colorValue, () => _tag(value), () => _deleteTag(value)),
              ],
            ),
    );
  }

  Widget _header(String title, String subtitle, VoidCallback add) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), Text(subtitle, style: const TextStyle(color: Color(0xFF77788A)))])),
          FilledButton.icon(onPressed: add, icon: const Icon(Icons.add), label: const Text('افزودن')),
        ]),
      );

  Widget _row(String title, int color, VoidCallback edit, VoidCallback delete) => Card(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Color(color), radius: 9),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => value == 'edit' ? edit() : delete(),
            itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text('ویرایش')), PopupMenuItem(value: 'delete', child: Text('حذف'))],
          ),
        ),
      );
}

class _Draft {
  const _Draft(this.title, this.color);
  final String title;
  final int color;
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 18), child: Center(child: Text(text, style: const TextStyle(color: Color(0xFF77788A)))));
}
