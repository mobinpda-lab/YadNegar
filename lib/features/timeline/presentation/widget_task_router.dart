import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/load_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/tracked_subject_detail.dart';

class WidgetTaskRouter extends StatefulWidget {
  const WidgetTaskRouter({
    super.key,
    required this.child,
    required this.taskRequest,
    required this.loadSubjects,
    required this.loadFollowUps,
    required this.addFollowUp,
    required this.editTimelineItem,
    this.reminderScheduler,
  });

  final Widget child;
  final ValueListenable<String?> taskRequest;
  final LoadTrackedSubjects loadSubjects;
  final LoadTimelineFollowUps loadFollowUps;
  final AddTimelineFollowUp addFollowUp;
  final EditTimelineItem editTimelineItem;
  final TimelineReminderScheduler? reminderScheduler;

  @override
  State<WidgetTaskRouter> createState() => _WidgetTaskRouterState();
}

class _WidgetTaskRouterState extends State<WidgetTaskRouter> {
  bool _opening = false;
  String? _queuedId;
  String? _lastHandledValue;

  @override
  void initState() {
    super.initState();
    widget.taskRequest.addListener(_onRequest);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onRequest());
  }

  @override
  void didUpdateWidget(covariant WidgetTaskRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.taskRequest != widget.taskRequest) {
      oldWidget.taskRequest.removeListener(_onRequest);
      widget.taskRequest.addListener(_onRequest);
    }
  }

  @override
  void dispose() {
    widget.taskRequest.removeListener(_onRequest);
    super.dispose();
  }

  void _onRequest() {
    final id = widget.taskRequest.value?.trim();
    if (id == null || id.isEmpty) return;
    if (id == _lastHandledValue && !_opening) return;
    _lastHandledValue = id;
    _queuedId = id;
    _drain();
  }

  Future<void> _drain() async {
    if (_opening || !mounted) return;
    final id = _queuedId;
    if (id == null || id.isEmpty) return;
    _queuedId = null;
    _opening = true;
    try {
      final subjects = await widget.loadSubjects.load();
      TimelineItem? subject;
      for (final candidate in subjects) {
        if (candidate.id == id && candidate.isTrackedSubject) {
          subject = candidate;
          break;
        }
      }
      if (!mounted || subject == null) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (context) => TrackedSubjectDetail(
            subject: subject!,
            loadFollowUps: widget.loadFollowUps,
            addFollowUp: widget.addFollowUp,
            editTimelineItem: widget.editTimelineItem,
            reminderScheduler: widget.reminderScheduler,
          ),
        ),
      );
    } finally {
      _opening = false;
      if (_queuedId != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _drain());
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
