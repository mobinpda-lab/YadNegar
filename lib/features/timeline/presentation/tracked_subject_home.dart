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
  static const _primary = Color(0xFF5546D8);
  static const _surfaceTint = Color(0xFFF4F2FF);
  static const _background = Color(0xFFF8F8FC);
  static const _muted = Color(0xFF77788A);

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<TimelineItem> _subjects = const <TimelineItem>[];
  Map<String, List<TimelineItem>> _followUps = const <String, List<TimelineItem>>{};
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<TimelineItem> get _visibleSubjects {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return _subjects;
    }
    return _subjects
        .where((subject) => subject.text.toLowerCase().contains(query))
        .toList(growable: false);
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
        _errorMessage = 'بارگذاری کارها و پیگیری‌ها انجام نشد.';
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('کار جدید'),
          content: Column(
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
      onRefresh: _reload,
      child: ListView(
        key: const Key('tracked-subject-home-scroll'),
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
        children: [
          _buildHeader(),
          const SizedBox(height: 22),
          _buildSearch(),
          const SizedBox(height: 18),
          _buildStats(),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'کارهای من',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
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
            icon: const Icon(Icons.notifications_none_rounded, color: _primary),
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

  Widget _buildSubjectCard(TimelineItem subject) {
    final followUps = _followUps[subject.id] ?? const <TimelineItem>[];
    final latest = followUps.isEmpty ? null : followUps.first;
    final hasFollowUp = latest != null;
    final statusColor = hasFollowUp ? const Color(0xFF3176D5) : const Color(0xFFE69A17);
    final statusTint = hasFollowUp ? const Color(0xFFEAF2FF) : const Color(0xFFFFF4DF);
    final statusText = hasFollowUp ? 'در حال پیگیری' : 'نیازمند پیگیری';

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
                  color: _surfaceTint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(timelineItemTypeIcon(subject.type), color: _primary, size: 25),
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
        'موردی مطابق جستجو پیدا نشد.',
        key: Key('tracked-subject-search-empty'),
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted),
      ),
    );
  }
}

class _StatData {
  const _StatData(this.label, this.value, this.icon, this.color, this.tint);

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color tint;
}
