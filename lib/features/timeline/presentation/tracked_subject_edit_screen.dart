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
  late final TextEditingController _descriptionController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subject.text);
    _descriptionController = TextEditingController(
      text: widget.subject.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _saving) {
      return;
    }
    setState(() => _saving = true);
    try {
      final updated = await widget.editTimelineItem.update(
        id: widget.subject.id,
        text: title,
        replaceDescription: true,
        description: _descriptionController.text,
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
              const SizedBox(height: 16),
              TextField(
                key: const Key('tracked-subject-edit-description'),
                controller: _descriptionController,
                minLines: 3,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'شرح یا خلاصه کار (اختیاری)',
                  hintText: 'جزئیات مهم، زمینه یا نتیجه مورد انتظار',
                  alignLabelWithHint: true,
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
