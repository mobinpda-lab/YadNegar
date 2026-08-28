import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';
import 'package:yadnegar/core/presentation/persian_duration_formatter.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/load_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_backup_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_item_type_presentation.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_detail.dart';

typedef TrackedSubjectHomeClock = DateTime Function();

class TrackedSubjectHome extends StatefulWidget {
  const TrackedSubjectHome({
    super.key,
    required this.quickCapture,
    required this.loadSubjects,
    required this.loadFollowUps,
    required this.addFollowUp,
    required this.editTimelineItem,
    this.legacyTimeline,
    this.clock = DateTime.now,
    this.dateTimeFormatter = const PersianDateTimeFormatter(),
    this.durationFormatter = const PersianDurationFormatter(),
  });

  final QuickCapture quickCapture;
  final LoadTrackedSubjects loadSubjects;
  final LoadTimelineFollowUps loadFollowUps;
  final AddTimelineFollowUp addFollowUp;
  final EditTimelineItem editTimelineItem;
  final Widget? legacyTimeline;
  final TrackedSubjectHomeClock clock;
  final PersianDateTimeFormatter dateTimeFormatter;
  final PersianDurationFormatter durationFormatter;

  @override
  State<TrackedSubjectHome> createState() => _TrackedSubjectHomeState();
}

class _TrackedSubjectHomeState extends State<TrackedSubjectHome> {
  List<TimelineItem> _subjects = const <TimelineItem>[];
  Map<String, List<TimelineItem>> _followUps = const <String, List<TimelineItem>>{};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final subjects = await widget.loadSubjects.load();
      final followUps = <String, List<TimelineItem>>{};
      for (final subject in subjects) {
        followUps[subject.id] = await widget.loadFollowUps.load(subject.id);
      }

      final sorted = List<TimelineItem>.of(subjects)
        ..sort((left, right) {
          final leftFollowUps = followUps[left.id] ?? const <TimelineItem>[];
          final rightFollowUps = followUps[right.id] ?? const <TimelineItem>[];
          final leftAt = leftFollowUps.isEmpty ? left.timelineAt : leftFollowUps.first.timelineAt;
          final rightAt = rightFollowUps.isEmpty ? right.timelineAt : rightFollowUps.first.timelineAt;
          return rightAt.compareTo(leftAt);
        });

      if (!mounted) {
        return;
      }
      setState(() {
        _subjects = List<TimelineItem>.unmodifiable(sorted);
        _followUps = Map<String, List<TimelineItem>>.unmodifiable(followUps);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'بارگذاری موضوعات پیگیری انجام نشد.';
      });
    }
  }

  Future<void> _createSubject() async {
    var draft = '';
    var selectedType = TimelineItemType.activity;
    final result = await showDialog<(String, TimelineItemType)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('کار جدید'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('tracked-subject-input'),
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'نام کار',
                  hintText: 'مثلاً تماس با علی',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => draft = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TimelineItemType>(
                key: const Key('tracked-subject-type'),
                initialValue: selectedType,
                decoration: const InputDecoration(
                  labelText: 'نوع کار',
                  border: OutlineInputBorder(),
                ),
                items: TimelineItemType.values
                    .map(
                      (type) => DropdownMenuItem<TimelineItemType>(
                        value: type,
                        child: TimelineItemTypeOption(type: type),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (type) {
                  if (type != null) {
                    setDialogState(() => selectedType = type);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('لغو'),
            ),
            FilledButton(
              key: const Key('tracked-subject-save'),
              onPressed: () {
                final normalized = draft.trim();
                if (normalized.isEmpty) {
                  return;
                }
                Navigator.of(dialogContext).pop((normalized, selectedType));
              },
              child: const Text('ذخیره'),
            ),
          ],
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    try {
      await widget.quickCapture.capture(text: result.$1, type: result.$2);
      await _reload();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ایجاد کار انجام نشد.')),
      );
    }
  }

  Future<void> _openSubject(TimelineItem subject) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => TrackedSubjectDetail(
          subject: subject,
          loadFollowUps: widget.loadFollowUps,
          addFollowUp: widget.addFollowUp,
          editTimelineItem: widget.editTimelineItem,
          clock: widget.clock,
          dateTimeFormatter: widget.dateTimeFormatter,
          durationFormatter: widget.durationFormatter,
        ),
      ),
    );
    if (mounted) {
      await _reload();
    }
  }

  Future<void> _runBackup() async {
    final scope = TimelineBackupScope.maybeOf(context);
    if (scope == null) {
      return;
    }
    try {
      await scope.backupAction();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('پشتیبان‌گیری انجام نشد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backupAvailable = TimelineBackupScope.maybeOf(context) != null;
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('یادنگار'),
            Text(
              'مدیریت کارها و پیگیری‌ها',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          if (backupAvailable)
            IconButton(
              key: const Key('tracked-subject-backup'),
              tooltip: 'پشتیبان‌گیری',
              onPressed: _runBackup,
              icon: const Icon(Icons.backup_outlined),
            ),
          if (widget.legacyTimeline != null)
            IconButton(
              key: const Key('tracked-subject-legacy-tools'),
              tooltip: 'ابزارها',
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(builder: (_) => widget.legacyTimeline!),
              ),
              icon: const Icon(Icons.tune),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('tracked-subject-add'),
        onPressed: _createSubject,
        icon: const Icon(Icons.add),
        label: const Text('افزودن کار جدید'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    if (_subjects.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'یک کار بسازید؛ بعد هر بار اتفاق تازه‌ای افتاد، داخل همان کار یک پیگیری ثبت کنید.',
            key: Key('tracked-subject-empty'),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        key: const Key('tracked-subject-list'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: _subjects.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final subject = _subjects[index];
          final followUps = _followUps[subject.id] ?? const <TimelineItem>[];
          final latest = followUps.isEmpty ? null : followUps.first;
          return Card(
            key: Key('tracked-subject-${subject.id}'),
            child: ListTile(
              leading: Icon(timelineItemTypeIcon(subject.type)),
              title: Text(subject.text),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.dateTimeFormatter.persianDigits(followUps.length.toString())} پیگیری',
                  ),
                  if (latest == null)
                    const Text(
                      'هنوز پیگیری ثبت نشده است',
                      key: Key('tracked-subject-no-follow-up'),
                    )
                  else ...[
                    Text(
                      'آخرین پیگیری: ${widget.dateTimeFormatter.formatDateTime(latest.timelineAt)}',
                      key: Key('tracked-subject-last-${subject.id}'),
                    ),
                    Text(
                      widget.durationFormatter.relativeAgo(
                        now: widget.clock(),
                        value: latest.timelineAt,
                      ),
                      key: Key('tracked-subject-relative-${subject.id}'),
                    ),
                  ],
                ],
              ),
              isThreeLine: latest != null,
              trailing: const Icon(Icons.chevron_left),
              onTap: () => _openSubject(subject),
            ),
          );
        },
      ),
    );
  }
}
