import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_date_picker.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';
import 'package:yadnegar/core/presentation/persian_time_picker.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

typedef FollowUpEditorClock = DateTime Function();

class FollowUpEditorScreen extends StatefulWidget {
  const FollowUpEditorScreen({
    super.key,
    required this.subject,
    required this.addFollowUp,
    required this.editTimelineItem,
    this.existing,
    this.clock = DateTime.now,
    this.dateTimeFormatter = const PersianDateTimeFormatter(),
  });

  final TimelineItem subject;
  final TimelineItem? existing;
  final AddTimelineFollowUp addFollowUp;
  final EditTimelineItem editTimelineItem;
  final FollowUpEditorClock clock;
  final PersianDateTimeFormatter dateTimeFormatter;

  @override
  State<FollowUpEditorScreen> createState() => _FollowUpEditorScreenState();
}

class _FollowUpEditorScreenState extends State<FollowUpEditorScreen> {
  late final TextEditingController _titleController;
  late DateTime _selectedDateTime;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existing?.text ?? '');
    _selectedDateTime = widget.existing?.timelineAt ?? widget.clock();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showYadNegarPersianDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      formatter: widget.dateTimeFormatter,
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _selectedDateTime = DateTime(
        selected.year,
        selected.month,
        selected.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final selected = await showYadNegarPersianTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      formatter: widget.dateTimeFormatter,
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        selected.hour,
        selected.minute,
      );
    });
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    try {
      final rawTitle = _titleController.text;
      final TimelineItem saved;
      if (_isEditing) {
        saved = await widget.editTimelineItem.update(
          id: widget.existing!.id,
          text: rawTitle,
          replaceOccurredAt: true,
          occurredAt: _selectedDateTime,
        );
      } else {
        saved = await widget.addFollowUp.add(
          subject: widget.subject,
          text: rawTitle,
          occurredAt: _selectedDateTime,
        );
      }
      if (mounted) {
        Navigator.of(context).pop(saved);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ذخیره پیگیری انجام نشد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'ویرایش پیگیری' : 'ثبت پیگیری'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('برای کار'),
                    const SizedBox(height: 4),
                    Text(
                      widget.subject.text,
                      key: const Key('follow-up-editor-subject'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('follow-up-title-input'),
              controller: _titleController,
              autofocus: !_isEditing,
              decoration: const InputDecoration(
                labelText: 'عنوان پیگیری (اختیاری)',
                hintText: 'مثلاً تماس تلفنی اول',
                helperText: 'اگر خالی بگذارید، «پیگیری» ثبت می‌شود.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('follow-up-date-field'),
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Column(
                      children: [
                        const Text('تاریخ پیگیری'),
                        Text(widget.dateTimeFormatter.formatDate(_selectedDateTime)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('follow-up-time-field'),
                    onPressed: _pickTime,
                    icon: const Icon(Icons.schedule_outlined),
                    label: Column(
                      children: [
                        const Text('ساعت پیگیری'),
                        Text(widget.dateTimeFormatter.formatTime(_selectedDateTime)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const Key('follow-up-editor-cancel'),
                    onPressed: _saving ? null : () => Navigator.of(context).pop(),
                    child: const Text('لغو'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    key: const Key('follow-up-editor-confirm'),
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'در حال ذخیره…' : 'تأیید'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
