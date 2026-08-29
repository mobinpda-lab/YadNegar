import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_date_picker.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';
import 'package:yadnegar/core/presentation/persian_time_picker.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';
import 'package:yadnegar/features/timeline/presentation/project_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_persian_pickers.dart';

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
  static const _formatter = PersianDateTimeFormatter();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String? _projectId;
  late DateTime? _nextActionAt;
  late DateTime? _reminderAt;
  late TimelineReminderRecurrence _reminderRecurrence;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subject.text);
    _descriptionController = TextEditingController(
      text: widget.subject.description ?? '',
    );
    _projectId = widget.subject.projectId;
    _nextActionAt = widget.subject.nextActionAt;
    _reminderAt = widget.subject.reminderAt;
    _reminderRecurrence = widget.subject.reminderRecurrence;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickNextActionDate() async {
    final initial = _nextActionAt ?? DateTime.now();
    final selected = await showYadNegarPersianDatePicker(
      context: context,
      initialDate: initial,
    );
    if (selected == null || !mounted) return;
    final current = _nextActionAt ?? initial;
    setState(() {
      _nextActionAt = DateTime(
        selected.year,
        selected.month,
        selected.day,
        current.hour,
        current.minute,
      );
    });
  }

  Future<void> _pickNextActionTime() async {
    final initial = _nextActionAt ?? DateTime.now();
    final selected = await showYadNegarPersianTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (selected == null || !mounted) return;
    final current = _nextActionAt ?? initial;
    setState(() {
      _nextActionAt = DateTime(
        current.year,
        current.month,
        current.day,
        selected.hour,
        selected.minute,
      );
    });
  }

  Future<void> _pickReminder() async {
    final selected = await pickPersianFutureReminderDateTime(
      context,
      _reminderAt ?? DateTime.now().add(const Duration(hours: 1)),
    );
    if (selected == null || !mounted) return;
    setState(() => _reminderAt = selected);
  }

  void _clearReminder() {
    setState(() {
      _reminderAt = null;
      _reminderRecurrence = TimelineReminderRecurrence.none;
    });
  }

  String _recurrenceLabel(TimelineReminderRecurrence value) {
    return switch (value) {
      TimelineReminderRecurrence.none => 'بدون تکرار',
      TimelineReminderRecurrence.daily => 'روزانه',
      TimelineReminderRecurrence.weekly => 'هفتگی',
    };
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final updated = await widget.editTimelineItem.update(
        id: widget.subject.id,
        text: title,
        replaceDescription: true,
        description: _descriptionController.text,
        replaceProjectId: ProjectScope.maybeOf(context) != null,
        projectId: _projectId,
        replaceNextActionAt: true,
        nextActionAt: _nextActionAt,
        replaceReminderAt: true,
        reminderAt: _reminderAt,
        replaceReminderRecurrence: true,
        reminderRecurrence: _reminderRecurrence,
      );
      if (mounted) Navigator.of(context).pop(updated);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ویرایش کار انجام نشد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectScope = ProjectScope.maybeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش کار')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            Card(
              key: const Key('tracked-subject-edit-next-action'),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('اقدام بعدی', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      _nextActionAt == null
                          ? 'زمانی تعیین نشده است'
                          : _formatter.formatDateTime(_nextActionAt!),
                      key: const Key('tracked-subject-edit-next-action-value'),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          key: const Key('tracked-subject-edit-next-action-date'),
                          onPressed: _pickNextActionDate,
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: const Text('تاریخ'),
                        ),
                        OutlinedButton.icon(
                          key: const Key('tracked-subject-edit-next-action-time'),
                          onPressed: _pickNextActionTime,
                          icon: const Icon(Icons.schedule_outlined),
                          label: const Text('ساعت'),
                        ),
                        if (_nextActionAt != null)
                          TextButton.icon(
                            key: const Key('tracked-subject-edit-next-action-clear'),
                            onPressed: () => setState(() => _nextActionAt = null),
                            icon: const Icon(Icons.close),
                            label: const Text('پاک کردن'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              key: const Key('tracked-subject-edit-reminder'),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('یادآور', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      _reminderAt == null
                          ? 'یادآوری تعیین نشده است'
                          : _formatter.formatDateTime(_reminderAt!),
                      key: const Key('tracked-subject-edit-reminder-value'),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          key: const Key('tracked-subject-edit-reminder-pick'),
                          onPressed: _pickReminder,
                          icon: const Icon(Icons.notifications_active_outlined),
                          label: Text(_reminderAt == null ? 'تنظیم یادآور' : 'تغییر زمان'),
                        ),
                        if (_reminderAt != null)
                          TextButton.icon(
                            key: const Key('tracked-subject-edit-reminder-clear'),
                            onPressed: _clearReminder,
                            icon: const Icon(Icons.notifications_off_outlined),
                            label: const Text('پاک کردن'),
                          ),
                      ],
                    ),
                    if (_reminderAt != null) ...[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<TimelineReminderRecurrence>(
                        key: const Key('tracked-subject-edit-reminder-recurrence'),
                        initialValue: _reminderRecurrence,
                        decoration: const InputDecoration(
                          labelText: 'تکرار یادآور',
                          border: OutlineInputBorder(),
                        ),
                        items: TimelineReminderRecurrence.values
                            .map(
                              (value) => DropdownMenuItem<TimelineReminderRecurrence>(
                                value: value,
                                child: Text(_recurrenceLabel(value)),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value != null) setState(() => _reminderRecurrence = value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (projectScope != null) ...[
              const SizedBox(height: 16),
              FutureBuilder<List<YadNegarProject>>(
                future: projectScope.manageProjects.list(),
                builder: (context, snapshot) {
                  final projects = snapshot.data ?? const <YadNegarProject>[];
                  final validProjectId = projects.any((p) => p.id == _projectId)
                      ? _projectId
                      : null;
                  return DropdownButtonFormField<String?>(
                    key: const Key('tracked-subject-edit-project'),
                    initialValue: validProjectId,
                    decoration: const InputDecoration(
                      labelText: 'پروژه',
                      helperText: 'پروژه با تگ متفاوت است',
                      border: OutlineInputBorder(),
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('بدون پروژه'),
                      ),
                      ...projects.map(
                        (project) => DropdownMenuItem<String?>(
                          value: project.id,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color(project.colorValue),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(project.title),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: snapshot.hasData
                        ? (value) => setState(() => _projectId = value)
                        : null,
                  );
                },
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('tracked-subject-edit-confirm'),
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'در حال ذخیره…' : 'ذخیره'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
