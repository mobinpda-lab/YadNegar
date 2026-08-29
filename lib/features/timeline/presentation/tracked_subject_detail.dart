import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';
import 'package:yadnegar/core/presentation/persian_duration_formatter.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/follow_up_editor_screen.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_edit_screen.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_pdf_actions.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_pdf_scope.dart';

typedef TrackedSubjectDetailClock = DateTime Function();

class TrackedSubjectDetail extends StatefulWidget {
  const TrackedSubjectDetail({
    super.key,
    required this.subject,
    required this.loadFollowUps,
    required this.addFollowUp,
    required this.editTimelineItem,
    this.reminderScheduler,
    this.clock = DateTime.now,
    this.dateTimeFormatter = const PersianDateTimeFormatter(),
    this.durationFormatter = const PersianDurationFormatter(),
  });

  final TimelineItem subject;
  final LoadTimelineFollowUps loadFollowUps;
  final AddTimelineFollowUp addFollowUp;
  final EditTimelineItem editTimelineItem;
  final TimelineReminderScheduler? reminderScheduler;
  final TrackedSubjectDetailClock clock;
  final PersianDateTimeFormatter dateTimeFormatter;
  final PersianDurationFormatter durationFormatter;

  @override
  State<TrackedSubjectDetail> createState() => _TrackedSubjectDetailState();
}

class _TrackedSubjectDetailState extends State<TrackedSubjectDetail> {
  late TimelineItem _subject;
  List<TimelineItem> _followUps = const <TimelineItem>[];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _subject = widget.subject;
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final followUps = await widget.loadFollowUps.load(_subject.id);
      if (!mounted) return;
      setState(() {
        _followUps = followUps;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'بارگذاری پیگیری‌ها انجام نشد.';
      });
    }
  }

  Future<void> _syncReminder(TimelineItem item) async {
    try {
      if (item.reminderAt == null) {
        await widget.reminderScheduler?.cancel(item.id);
      } else {
        await widget.reminderScheduler?.schedule(item);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اطلاعات ذخیره شد؛ همگام‌سازی یادآور انجام نشد.')),
      );
    }
  }

  Future<void> _addFollowUp() async {
    final saved = await Navigator.of(context).push<TimelineItem>(
      MaterialPageRoute<TimelineItem>(
        builder: (context) => FollowUpEditorScreen(
          subject: _subject,
          addFollowUp: widget.addFollowUp,
          editTimelineItem: widget.editTimelineItem,
          clock: widget.clock,
          dateTimeFormatter: widget.dateTimeFormatter,
        ),
      ),
    );
    if (saved != null && mounted) {
      await _syncReminder(saved);
      await _reload();
    }
  }

  Future<void> _editSubject() async {
    final updated = await Navigator.of(context).push<TimelineItem>(
      MaterialPageRoute<TimelineItem>(
        builder: (context) => TrackedSubjectEditScreen(
          subject: _subject,
          editTimelineItem: widget.editTimelineItem,
        ),
      ),
    );
    if (updated != null && mounted) {
      await _syncReminder(updated);
      if (mounted) setState(() => _subject = updated);
    }
  }

  Future<void> _editFollowUp(TimelineItem followUp) async {
    final updated = await Navigator.of(context).push<TimelineItem>(
      MaterialPageRoute<TimelineItem>(
        builder: (context) => FollowUpEditorScreen(
          subject: _subject,
          existing: followUp,
          addFollowUp: widget.addFollowUp,
          editTimelineItem: widget.editTimelineItem,
          clock: widget.clock,
          dateTimeFormatter: widget.dateTimeFormatter,
        ),
      ),
    );
    if (updated != null && mounted) {
      await _syncReminder(updated);
      await _reload();
    }
  }

  String _recurrenceLabel(TimelineReminderRecurrence recurrence) => switch (recurrence) {
        TimelineReminderRecurrence.none => 'بدون تکرار',
        TimelineReminderRecurrence.daily => 'هر روز',
        TimelineReminderRecurrence.weekly => 'هر هفته',
      };

  @override
  Widget build(BuildContext context) {
    final latest = _followUps.isEmpty ? null : _followUps.first;
    final hasPdfActions = TrackedSubjectPdfScope.maybeOf(context) != null;
    final description = _subject.description;
    final nextActionAt = _subject.nextActionAt;
    final reminderAt = _subject.reminderAt;
    return Scaffold(
      appBar: AppBar(
        title: Text(_subject.text, key: const Key('tracked-subject-detail-title')),
        actions: [
          if (hasPdfActions)
            IconButton(
              key: const Key('tracked-subject-pdf-open'),
              tooltip: 'گزارش PDF',
              onPressed: () async {
                await TrackedSubjectPdfActions.open(context, currentSubjectId: _subject.id);
              },
              icon: const Icon(Icons.picture_as_pdf_outlined),
            ),
          TextButton(
            key: const Key('tracked-subject-edit'),
            onPressed: _editSubject,
            child: const Text('ویرایش'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_subject.text, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    const Text('شرح کار', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      description == null || description.isEmpty ? 'شرحی برای این کار ثبت نشده است.' : description,
                      key: const Key('tracked-subject-description'),
                      softWrap: true,
                    ),
                    const SizedBox(height: 14),
                    const Text('اقدام بعدی', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      key: const Key('tracked-subject-next-action'),
                      children: [
                        Icon(nextActionAt == null ? Icons.event_busy_outlined : Icons.event_available_outlined, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nextActionAt == null ? 'اقدام بعدی تعیین نشده است' : widget.dateTimeFormatter.formatDateTime(nextActionAt),
                            key: const Key('tracked-subject-next-action-value'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('یادآور', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      reminderAt == null
                          ? 'یادآوری تعیین نشده است'
                          : '${widget.dateTimeFormatter.formatDateTime(reminderAt)} • ${_recurrenceLabel(_subject.reminderRecurrence)}',
                      key: const Key('tracked-subject-reminder-value'),
                    ),
                    const SizedBox(height: 14),
                    const Text('آخرین پیگیری', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      latest == null ? 'هنوز پیگیری ثبت نشده است' : widget.dateTimeFormatter.formatDateTime(latest.timelineAt),
                      key: const Key('tracked-subject-last-follow-up'),
                    ),
                    if (latest != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '● ${widget.durationFormatter.elapsedSince(now: widget.clock(), latest: latest.timelineAt)}',
                        key: const Key('tracked-subject-elapsed'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('تاریخچه پیگیری‌ها', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          Expanded(child: _buildFollowUpList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('tracked-subject-add-follow-up'),
        tooltip: 'ثبت پیگیری جدید',
        onPressed: _addFollowUp,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFollowUpList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) return Center(child: Text(_errorMessage!));
    if (_followUps.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('هنوز پیگیری ثبت نشده است', key: Key('tracked-subject-follow-up-empty'), textAlign: TextAlign.center),
        ),
      );
    }

    return ListView.separated(
      key: const Key('tracked-subject-follow-up-list'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      itemCount: _followUps.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final followUp = _followUps[index];
        final previous = index + 1 < _followUps.length ? _followUps[index + 1] : null;
        final reminderAt = followUp.reminderAt;
        return Card(
          key: Key('follow-up-${followUp.id}'),
          child: ListTile(
            onTap: () => _editFollowUp(followUp),
            leading: const Icon(Icons.history),
            title: Text(followUp.text),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.dateTimeFormatter.formatDateTime(followUp.timelineAt), key: Key('follow-up-time-${followUp.id}')),
                if (reminderAt != null)
                  Text(
                    'یادآور: ${widget.dateTimeFormatter.formatDateTime(reminderAt)} • ${_recurrenceLabel(followUp.reminderRecurrence)}',
                    key: Key('follow-up-reminder-${followUp.id}'),
                  ),
                if (previous != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.durationFormatter.intervalBetween(newer: followUp.timelineAt, older: previous.timelineAt),
                    key: Key('follow-up-interval-${followUp.id}'),
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.edit_outlined),
          ),
        );
      },
    );
  }
}
