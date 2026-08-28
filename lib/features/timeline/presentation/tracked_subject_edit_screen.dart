import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

class TrackedSubjectEditScreen extends StatefulWidget {
  const TrackedSubjectEditScreen({
    super.key,
    required this.subject,
    required this.editTimelineItem,
  });

  final TimelineItem subject;
  final EditTimelineItem editTimelineItem;

  @override
  State<TrackedSubjectEditScreen> createState() => _TrackedSubjectEditScreenState();
}

class _TrackedSubjectEditScreenState extends State<TrackedSubjectEditScreen> {
  late final TextEditingController _titleController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subject.text);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _saving) {
      return;
    }
    setState(() => _saving = true);
    try {
      final updated = await widget.editTimelineItem.updateText(
        id: widget.subject.id,
        text: title,
      );
      if (mounted) {
        Navigator.of(context).pop(updated);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ویرایش کار انجام نشد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش کار')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('tracked-subject-edit-title'),
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'عنوان کار',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              FilledButton(
                key: const Key('tracked-subject-edit-confirm'),
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'در حال ذخیره…' : 'ذخیره'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
