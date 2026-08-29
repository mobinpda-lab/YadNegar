import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_date_picker.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';
import 'package:yadnegar/core/presentation/persian_duration_formatter.dart';
import 'package:yadnegar/core/presentation/persian_time_picker.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/classify_tracked_subject_next_action.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/application/load_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/timeline_reminder_scheduler.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';
import 'package:yadnegar/features/timeline/presentation/follow_up_editor_screen.dart';
import 'package:yadnegar/features/timeline/presentation/project_management_sheet.dart';
import 'package:yadnegar/features/timeline/presentation/project_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_backup_scope.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_item_type_presentation.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_persian_pickers.dart';
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
    this.reminderScheduler,
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
  final TimelineReminderScheduler? reminderScheduler;
  final Widget? legacyTimeline;
  final TrackedSubjectHomeClock clock;
  final PersianDateTimeFormatter dateTimeFormatter;
  final PersianDurationFormatter durationFormatter;

  @override
  State<TrackedSubjectHome> createState() => _TrackedSubjectHomeState();
}

class _TrackedSubjectHomeState extends State<TrackedSubjectHome> {
  static const _primary = Color(0xFF5546D8);
  static const _surfaceTint = Color(0xFFF4F2FF);
  static const _background = Color(0xFFF8F8FC);
  static const _muted = Color(0xFF77788A);
  static const _classifyNextAction = ClassifyTrackedSubjectNextAction();

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<TimelineItem> _subjects = const <TimelineItem>[];
  Map<String, List<TimelineItem>> _followUps = const <String, List<TimelineItem>>{};
  List<YadNegarProject> _projects = const <YadNegarProject>[];
  bool _projectsLoaded = false;
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';
  TrackedSubjectNextActionBucket? _selectedNextActionBucket;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_projectsLoaded && ProjectScope.maybeOf(context) != null) {
      _projectsLoaded = true;
      _reloadProjects();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<TimelineItem> get _visibleSubjects {
    final query = _query.trim().toLowerCase();
    return _subjects.where((subject) {
      if (_selectedNextActionBucket != null &&
          _classifyNextAction(subject: subject, now: widget.clock()) !=
              _selectedNextActionBucket) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      if (subject.text.toLowerCase().contains(query)) {
        return true;
      }
      if (subject.description?.toLowerCase().contains(query) ?? false) {
        return true;
      }
      final project = _projectFor(subject.projectId);
      if (project?.title.toLowerCase().contains(query) ?? false) {
        return true;
      }
      final followUps = _followUps[subject.id] ?? const <TimelineItem>[];
      return followUps.any(
        (followUp) => followUp.text.toLowerCase().contains(query),
      );
    }).toList(growable: false);
  }

  int get _withFollowUpCount => _subjects
      .where((subject) => (_followUps[subject.id] ?? const <TimelineItem>[]).isNotEmpty)
      .length;

  int get _needsFollowUpCount => _subjects.length - _withFollowUpCount;

  int get _todayFollowUpCount {
    final now = widget.clock();
    return _subjects.where((subject) {
      final followUps = _followUps[subject.id] ?? const <TimelineItem>[];
      if (followUps.isEmpty) {
        return false;
      }
      final latest = followUps.first.timelineAt;
      return latest.year == now.year &&
          latest.month == now.month &&
          latest.day == now.day;
    }).length;
  }

  int _nextActionBucketCount(TrackedSubjectNextActionBucket bucket) {
    final now = widget.clock();
    return _subjects
        .where((subject) => _classifyNextAction(subject: subject, now: now) == bucket)
        .length;
  }

  YadNegarProject? _projectFor(String? projectId) {
    if (projectId == null) {
      return null;
    }
    for (final project in _projects) {
      if (project.id == projectId) {
        return project;
      }
    }
    return null;
  }

  Future<void> _reloadProjects() async {
    final scope = ProjectScope.maybeOf(context);
    if (scope == null) {
      return;
    }
    try {
      final projects = await scope.manageProjects.list();
      if (mounted) {
        setState(() => _projects = projects);
      }
    } catch (_) {
      // Project list failure must not block the task timeline.
    }
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final homeData = await widget.loadSubjects.loadHomeData();
      final subjects = homeData.subjects;
      final followUps = homeData.followUpsBySubject;

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
        _errorMessage = 'بارگذاری کارها و پیگیری‌ها انجام نشد.';
      });
    }
  }

  Future<void> _createSubject() async {
    var draft = '';
    var descriptionDraft = '';
    var selectedType = TimelineItemType.activity;
    String? selectedProjectId;
    DateTime? selectedNextActionAt;
    DateTime? selectedReminderAt;
    var selectedReminderRecurrence = TimelineReminderRecurrence.none;
    final result = await showDialog<_TrackedSubjectDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('کار جدید'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key('tracked-subject-input'),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'نام کار',
                    hintText: 'مثلاً تماس با علی',
                    filled: true,
                    fillColor: _surfaceTint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => draft = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('tracked-subject-description-input'),
                  minLines: 2,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    labelText: 'شرح یا خلاصه (اختیاری)',
                    hintText: 'جزئیات مهم این کار',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: _surfaceTint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => descriptionDraft = value,
                ),
                const SizedBox(height: 12),
                Container(
                  key: const Key('tracked-subject-next-action-input'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _surfaceTint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('اقدام بعدی (اختیاری)', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        selectedNextActionAt == null
                            ? 'زمانی تعیین نشده است'
                            : widget.dateTimeFormatter.formatDateTime(selectedNextActionAt!),
                        key: const Key('tracked-subject-next-action-input-value'),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            key: const Key('tracked-subject-next-action-date'),
                            onPressed: () async {
                              final initial = selectedNextActionAt ?? widget.clock();
                              final selected = await showYadNegarPersianDatePicker(
                                context: dialogContext,
                                initialDate: initial,
                              );
                              if (selected == null) return;
                              final current = selectedNextActionAt ?? initial;
                              setDialogState(() {
                                selectedNextActionAt = DateTime(
                                  selected.year,
                                  selected.month,
                                  selected.day,
                                  current.hour,
                                  current.minute,
                                );
                              });
                            },
                            icon: const Icon(Icons.calendar_month_outlined),
                            label: const Text('تاریخ'),
                          ),
                          OutlinedButton.icon(
                            key: const Key('tracked-subject-next-action-time'),
                            onPressed: () async {
                              final initial = selectedNextActionAt ?? widget.clock();
                              final selected = await showYadNegarPersianTimePicker(
                                context: dialogContext,
                                initialTime: TimeOfDay.fromDateTime(initial),
                              );
                              if (selected == null) return;
                              final current = selectedNextActionAt ?? initial;
                              setDialogState(() {
                                selectedNextActionAt = DateTime(
                                  current.year,
                                  current.month,
                                  current.day,
                                  selected.hour,
                                  selected.minute,
                                );
                              });
                            },
                            icon: const Icon(Icons.schedule_outlined),
                            label: const Text('ساعت'),
                          ),
                          if (selectedNextActionAt != null)
                            TextButton.icon(
                              key: const Key('tracked-subject-next-action-clear'),
                              onPressed: () => setDialogState(() => selectedNextActionAt = null),
                              icon: const Icon(Icons.close),
                              label: const Text('پاک کردن'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  key: const Key('tracked-subject-reminder-input'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _surfaceTint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('یادآور (اختیاری)', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        selectedReminderAt == null
                            ? 'یادآوری تعیین نشده است'
                            : widget.dateTimeFormatter.formatDateTime(selectedReminderAt!),
                        key: const Key('tracked-subject-reminder-input-value'),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            key: const Key('tracked-subject-reminder-pick'),
                            onPressed: () async {
                              final selected = await pickPersianFutureReminderDateTime(
                                dialogContext,
                                selectedReminderAt ?? widget.clock().add(const Duration(hours: 1)),
                              );
                              if (selected == null) return;
                              setDialogState(() => selectedReminderAt = selected);
                            },
                            icon: const Icon(Icons.notifications_active_outlined),
                            label: Text(selectedReminderAt == null ? 'تنظیم یادآور' : 'تغییر زمان'),
                          ),
                          if (selectedReminderAt != null)
                            TextButton.icon(
                              key: const Key('tracked-subject-reminder-clear'),
                              onPressed: () => setDialogState(() {
                                selectedReminderAt = null;
                                selectedReminderRecurrence = TimelineReminderRecurrence.none;
                              }),
                              icon: const Icon(Icons.notifications_off_outlined),
                              label: const Text('پاک کردن'),
                            ),
                        ],
                      ),
                      if (selectedReminderAt != null) ...[
                        const SizedBox(height: 10),
                        DropdownButtonFormField<TimelineReminderRecurrence>(
                          key: const Key('tracked-subject-reminder-recurrence'),
                          initialValue: selectedReminderRecurrence,
                          decoration: const InputDecoration(
                            labelText: 'تکرار یادآور',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: TimelineReminderRecurrence.none, child: Text('بدون تکرار')),
                            DropdownMenuItem(value: TimelineReminderRecurrence.daily, child: Text('روزانه')),
                            DropdownMenuItem(value: TimelineReminderRecurrence.weekly, child: Text('هفتگی')),
                          ],
                          onChanged: (value) {
                            if (value != null) setDialogState(() => selectedReminderRecurrence = value);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                if (_projects.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    key: const Key('tracked-subject-project'),
                    initialValue: selectedProjectId,
                    decoration: InputDecoration(
                      labelText: 'پروژه',
                      helperText: 'پروژه با تگ متفاوت است',
                      filled: true,
                      fillColor: _surfaceTint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('بدون پروژه'),
                      ),
                      ..._projects.map(
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
                    onChanged: (value) =>
                        setDialogState(() => selectedProjectId = value),
                  ),
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<TimelineItemType>(
                  key: const Key('tracked-subject-type'),
                  initialValue: selectedType,
                  decoration: InputDecoration(
                    labelText: 'نوع کار',
                    filled: true,
                    fillColor: _surfaceTint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('لغو'),
            ),
            FilledButton(
              key: const Key('tracked-subject-save'),
              style: FilledButton.styleFrom(backgroundColor: _primary),
              onPressed: () {
                final normalized = draft.trim();
                if (normalized.isEmpty) {
                  return;
                }
                final normalizedDescription = descriptionDraft.trim();
                Navigator.of(dialogContext).pop(
                  _TrackedSubjectDraft(
                    text: normalized,
                    description: normalizedDescription.isEmpty
                        ? null
                        : normalizedDescription,
                    projectId: selectedProjectId,
                    nextActionAt: selectedNextActionAt,
                    reminderAt: selectedReminderAt,
                    reminderRecurrence: selectedReminderRecurrence,
                    type: selectedType,
                  ),
                );
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
      final saved = await widget.quickCapture.capture(
        text: result.text,
        description: result.description,
        projectId: result.projectId,
        nextActionAt: result.nextActionAt,
        reminderAt: result.reminderAt,
        reminderRecurrence: result.reminderRecurrence,
        type: result.type,
      );
      if (saved.reminderAt != null && widget.reminderScheduler != null) {
        try {
          await widget.reminderScheduler!.schedule(saved);
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('کار ذخیره شد؛ همگام‌سازی یادآور انجام نشد.')),
            );
          }
        }
      }
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

  Future<void> _addFollowUpFromHome(TimelineItem subject) async {
    final saved = await Navigator.of(context).push<TimelineItem>(
      MaterialPageRoute<TimelineItem>(
        builder: (context) => FollowUpEditorScreen(
          subject: subject,
          addFollowUp: widget.addFollowUp,
          editTimelineItem: widget.editTimelineItem,
          clock: widget.clock,
          dateTimeFormatter: widget.dateTimeFormatter,
        ),
      ),
    );
    if (saved != null && mounted) {
      try {
        if (saved.reminderAt == null) {
          await widget.reminderScheduler?.cancel(saved.id);
        } else {
          await widget.reminderScheduler?.schedule(saved);
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('پیگیری ذخیره شد؛ همگام‌سازی یادآور انجام نشد.')),
          );
        }
      }
      await _reload();
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
          reminderScheduler: widget.reminderScheduler,
          clock: widget.clock,
          dateTimeFormatter: widget.dateTimeFormatter,
          durationFormatter: widget.durationFormatter,
        ),
      ),
    );
    if (mounted) {
      await _reload();
      await _reloadProjects();
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

  Future<void> _openProjects() async {
    final scope = ProjectScope.maybeOf(context);
    if (scope == null) {
      return;
    }
    await ProjectManagementSheet.open(
      context,
      manageProjects: scope.manageProjects,
    );
    if (mounted) {
      await _reloadProjects();
    }
  }

  void _openLegacyTools() {
    final legacyTimeline = widget.legacyTimeline;
    if (legacyTimeline == null) {
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => legacyTimeline),
    );
  }

  void _scrollToTasks() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      360,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _showMore() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ProjectScope.maybeOf(this.context) != null)
                ListTile(
                  key: const Key('tracked-subject-projects-menu'),
                  leading: const Icon(Icons.folder_copy_outlined, color: _primary),
                  title: const Text('پروژه‌ها'),
                  subtitle: const Text('ساخت، ویرایش و مدیریت پروژه‌های رنگی'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openProjects();
                  },
                ),
              if (TimelineBackupScope.maybeOf(this.context) != null)
                ListTile(
                  leading: const Icon(Icons.backup_outlined, color: _primary),
                  title: const Text('پشتیبان‌گیری'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _runBackup();
                  },
                ),
              if (widget.legacyTimeline != null)
                ListTile(
                  leading: const Icon(Icons.tune, color: _primary),
                  title: const Text('ابزارها و فیلترها'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openLegacyTools();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(child: _buildBody()),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('tracked-subject-add'),
        onPressed: _createSubject,
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text('افزودن کار جدید'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xFFE8E4FF),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected) ? _primary : _muted,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? _primary : _muted,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: 0,
          backgroundColor: Colors.white,
          elevation: 1,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'خانه'),
            NavigationDestination(icon: Icon(Icons.check_circle_outline), label: 'کارها'),
            NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'تقویم'),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: 'بیشتر'),
          ],
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                return;
              case 1:
                _scrollToTasks();
                return;
              case 2:
                _openLegacyTools();
                return;
              case 3:
                _showMore();
                return;
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    final visibleSubjects = _visibleSubjects;
    return RefreshIndicator(
      color: _primary,
      onRefresh: () async {
        await _reload();
        await _reloadProjects();
      },
      child: ListView(
        key: const Key('tracked-subject-home-scroll'),
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                'بسم الله الرحمن الرحیم',
                key: Key('tracked-subject-bismillah'),
                style: TextStyle(
                  color: Color(0xFF77788A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _buildHeader(),
          const SizedBox(height: 22),
          _buildSearch(),
          const SizedBox(height: 18),
          _buildStats(),
          const SizedBox(height: 22),
          _buildTodayCenter(),
          if (_projects.isNotEmpty) ...[
            const SizedBox(height: 22),
            _buildProjectsStrip(),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'کارهای من',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
              ),
              if (_selectedNextActionBucket != null)
                TextButton(
                  key: const Key('today-center-clear-filter'),
                  onPressed: () => setState(() => _selectedNextActionBucket = null),
                  child: const Text('نمایش همه'),
                ),
              Text(
                widget.dateTimeFormatter.persianDigits('${visibleSubjects.length} مورد'),
                style: const TextStyle(color: _primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_subjects.isEmpty)
            _buildEmptyState()
          else if (visibleSubjects.isEmpty)
            _buildSearchEmptyState()
          else
            for (final subject in visibleSubjects) ...[
              _buildSubjectCard(subject),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final hasBackup = TimelineBackupScope.maybeOf(context) != null;
    return Row(
      children: [
        IconButton.filledTonal(
          key: const Key('tracked-subject-menu'),
          tooltip: 'منو',
          onPressed: _showMore,
          icon: const Icon(Icons.menu, color: _primary),
          style: IconButton.styleFrom(backgroundColor: _surfaceTint),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'یادنگار',
                style: TextStyle(
                  color: Color(0xFF242044),
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'مدیریت کارها و پیگیری‌ها',
                style: TextStyle(color: _muted, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        if (hasBackup)
          IconButton(
            key: const Key('tracked-subject-backup'),
            tooltip: 'پشتیبان‌گیری',
            onPressed: _runBackup,
            icon: const Icon(Icons.backup_outlined, color: _primary),
          ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      key: const Key('tracked-subject-search'),
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: 'جستجو در کارها و پیگیری‌ها...',
        hintStyle: const TextStyle(color: Color(0xFF9A9BAA)),
        prefixIcon: const Icon(Icons.search_rounded, color: _muted),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                key: const Key('tracked-subject-search-clear'),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFEEEFFA)),
        ),
      ),
    );
  }

  Widget _buildStats() {
    final stats = [
      _StatData('همه کارها', _subjects.length, Icons.work_outline_rounded, const Color(0xFF5B4BDB), const Color(0xFFF0EDFF)),
      _StatData('نیازمند پیگیری', _needsFollowUpCount, Icons.schedule_rounded, const Color(0xFFE69A17), const Color(0xFFFFF4DF)),
      _StatData('دارای پیگیری', _withFollowUpCount, Icons.check_circle_outline_rounded, const Color(0xFF25A55A), const Color(0xFFEAF8EF)),
      _StatData('پیگیری امروز', _todayFollowUpCount, Icons.calendar_today_outlined, const Color(0xFF3176D5), const Color(0xFFEAF2FF)),
    ];

    return SingleChildScrollView(
      key: const Key('tracked-subject-stats'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < stats.length; index++) ...[
            _buildStatCard(stats[index]),
            if (index != stats.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(_StatData stat) {
    return Container(
      width: 112,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x10000000), blurRadius: 18, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: stat.tint, borderRadius: BorderRadius.circular(14)),
            child: Icon(stat.icon, color: stat.color, size: 23),
          ),
          const SizedBox(height: 10),
          Text(
            widget.dateTimeFormatter.persianDigits(stat.value.toString()),
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Color(0xFF28254A)),
          ),
          const SizedBox(height: 3),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCenter() {
    const buckets = <_TodayBucketData>[
      _TodayBucketData(TrackedSubjectNextActionBucket.today, 'امروز', Icons.today_outlined, Color(0xFF3176D5), Color(0xFFEAF2FF)),
      _TodayBucketData(TrackedSubjectNextActionBucket.overdue, 'عقب‌افتاده', Icons.warning_amber_rounded, Color(0xFFD9516A), Color(0xFFFFEDEF)),
      _TodayBucketData(TrackedSubjectNextActionBucket.upcoming, 'آینده', Icons.upcoming_outlined, Color(0xFF25A55A), Color(0xFFEAF8EF)),
      _TodayBucketData(TrackedSubjectNextActionBucket.noNextAction, 'بدون اقدام', Icons.event_busy_outlined, Color(0xFF77788A), Color(0xFFF0F0F4)),
    ];
    return Column(
      key: const Key('today-center'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('مرکز امروز', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('اقدام بعدی مستقل از یادآوری و اعلان است.', style: TextStyle(color: _muted, fontSize: 12.5)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < buckets.length; index++) ...[
                _buildTodayBucketCard(buckets[index]),
                if (index != buckets.length - 1) const SizedBox(width: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodayBucketCard(_TodayBucketData data) {
    final selected = _selectedNextActionBucket == data.bucket;
    final count = _nextActionBucketCount(data.bucket);
    return InkWell(
      key: Key('today-center-${data.bucket.name}'),
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _selectedNextActionBucket = selected ? null : data.bucket;
        });
      },
      child: Container(
        width: 122,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? data.tint : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? data.color : const Color(0xFFEEEFFA), width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: data.tint, borderRadius: BorderRadius.circular(11)),
              child: Icon(data.icon, color: data.color, size: 19),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dateTimeFormatter.persianDigits(count.toString()),
                    style: TextStyle(color: data.color, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Text(data.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsStrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'پروژه‌ها',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            TextButton.icon(
              key: const Key('projects-manage-inline'),
              onPressed: _openProjects,
              icon: const Icon(Icons.settings_outlined, size: 18),
              label: const Text('مدیریت'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          key: const Key('projects-colored-boxes'),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < _projects.length; index++) ...[
                _buildProjectBox(_projects[index]),
                if (index != _projects.length - 1) const SizedBox(width: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectBox(YadNegarProject project) {
    final color = Color(project.colorValue);
    final taskCount = _subjects.where((subject) => subject.projectId == project.id).length;
    return InkWell(
      key: Key('home-project-${project.id}'),
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _searchController.text = project.title;
        setState(() => _query = project.title);
      },
      child: Container(
        width: 154,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              project.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.dateTimeFormatter.persianDigits(taskCount.toString())} کار',
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(TimelineItem subject) {
    return Dismissible(
      key: Key('tracked-subject-swipe-${subject.id}'),
      direction: DismissDirection.horizontal,
      confirmDismiss: (_) async {
        await _addFollowUpFromHome(subject);
        return false;
      },
      background: _buildFollowUpSwipeBackground(Alignment.centerRight),
      secondaryBackground: _buildFollowUpSwipeBackground(Alignment.centerLeft),
      child: _buildSubjectCardBody(subject),
    );
  }

  Widget _buildFollowUpSwipeBackground(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_comment_outlined, color: _primary),
          SizedBox(width: 8),
          Text(
            'افزودن پیگیری',
            style: TextStyle(color: _primary, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCardBody(TimelineItem subject) {
    final followUps = _followUps[subject.id] ?? const <TimelineItem>[];
    final latest = followUps.isEmpty ? null : followUps.first;
    final hasFollowUp = latest != null;
    final statusColor = hasFollowUp ? const Color(0xFF3176D5) : const Color(0xFFE69A17);
    final statusTint = hasFollowUp ? const Color(0xFFEAF2FF) : const Color(0xFFFFF4DF);
    final statusText = hasFollowUp ? 'در حال پیگیری' : 'نیازمند پیگیری';
    final project = _projectFor(subject.projectId);
    final nextActionAt = subject.nextActionAt;

    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: Key('tracked-subject-${subject.id}'),
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openSubject(subject),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEEEFFA)),
            boxShadow: const [
              BoxShadow(color: Color(0x0D000000), blurRadius: 14, offset: Offset(0, 5)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: project == null
                      ? _surfaceTint
                      : Color(project.colorValue).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  timelineItemTypeIcon(subject.type),
                  color: project == null ? _primary : Color(project.colorValue),
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF242044),
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (project != null) ...[
                      const SizedBox(height: 5),
                      Container(
                        key: Key('tracked-subject-project-${subject.id}'),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(project.colorValue).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            right: BorderSide(
                              color: Color(project.colorValue),
                              width: 4,
                            ),
                          ),
                        ),
                        child: Text(
                          'پروژه: ${project.title}',
                          style: TextStyle(
                            color: Color(project.colorValue),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                    if (nextActionAt != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        key: Key('tracked-subject-next-action-${subject.id}'),
                        children: [
                          const Icon(Icons.event_available_outlined, size: 15, color: _primary),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'اقدام بعدی: ${_compactDateTime(nextActionAt)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: _primary, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 5),
                    Text(
                      '${widget.dateTimeFormatter.persianDigits(followUps.length.toString())} پیگیری',
                      style: const TextStyle(color: _muted, fontSize: 12.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 7),
                    if (latest == null)
                      const Text(
                        'هنوز پیگیری ثبت نشده است',
                        key: Key('tracked-subject-no-follow-up'),
                        style: TextStyle(color: _muted, fontSize: 12.5),
                      )
                    else ...[
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 15, color: _muted),
                          const SizedBox(width: 5),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                'آخرین پیگیری: ${_compactDateTime(latest.timelineAt)}',
                                key: Key('tracked-subject-last-${subject.id}'),
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  color: Color(0xFF5F6072),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: statusTint, borderRadius: BorderRadius.circular(999)),
                            child: Text(
                              statusText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: statusColor, fontSize: 11.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        if (latest != null) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.durationFormatter.relativeAgo(now: widget.clock(), value: latest.timelineAt),
                              key: Key('tracked-subject-relative-${subject.id}'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: _muted, fontSize: 11.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(top: 13),
                child: Icon(Icons.chevron_left_rounded, color: Color(0xFFAAAABC)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _compactDateTime(DateTime value) {
    return '${widget.dateTimeFormatter.formatDate(value)} ${widget.dateTimeFormatter.formatTime(value)}';
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Column(
        children: [
          Icon(Icons.add_task_rounded, color: _primary, size: 42),
          SizedBox(height: 12),
          Text(
            'هنوز کاری ثبت نشده است',
            key: Key('tracked-subject-empty'),
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          SizedBox(height: 6),
          Text(
            'اولین کار را بسازید و پیگیری‌های بعدی را داخل همان کار ثبت کنید.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Text(
        'موردی مطابق جستجو/فیلتر پیدا نشد.',
        key: Key('tracked-subject-search-empty'),
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted),
      ),
    );
  }
}

class _TrackedSubjectDraft {
  const _TrackedSubjectDraft({
    required this.text,
    required this.type,
    this.description,
    this.projectId,
    this.nextActionAt,
    this.reminderAt,
    this.reminderRecurrence = TimelineReminderRecurrence.none,
  });

  final String text;
  final String? description;
  final String? projectId;
  final DateTime? nextActionAt;
  final DateTime? reminderAt;
  final TimelineReminderRecurrence reminderRecurrence;
  final TimelineItemType type;
}

class _StatData {
  const _StatData(this.label, this.value, this.icon, this.color, this.tint);

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color tint;
}

class _TodayBucketData {
  const _TodayBucketData(this.bucket, this.label, this.icon, this.color, this.tint);

  final TrackedSubjectNextActionBucket bucket;
  final String label;
  final IconData icon;
  final Color color;
  final Color tint;
}
