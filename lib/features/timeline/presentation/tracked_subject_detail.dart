import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/load_timeline_follow_ups.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

class TrackedSubjectDetail extends StatefulWidget {
  const TrackedSubjectDetail({
    super.key,
    required this.subject,
    required this.loadFollowUps,
    required this.addFollowUp,
    this.dateTimeFormatter = const PersianDateTimeFormatter(),
  });

  final TimelineItem subject;
  final LoadTimelineFollowUps loadFollowUps;
  final AddTimelineFollowUp addFollowUp;
  final PersianDateTimeFormatter dateTimeFormatter;

  @override
  State<TrackedSubjectDetail> createState() => _TrackedSubjectDetailState();
}

class _TrackedSubjectDetailState extends State<TrackedSubjectDetail> {
  List<TimelineItem> _followUps = const <TimelineItem>[];
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
      final followUps = await widget.loadFollowUps.load(widget.subject.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _followUps = followUps;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'بارگذاری پیگیری‌ها انجام نشد.';
      });
    }
  }

  Future<void> _addFollowUp() async {
    var draft = '';
    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('پیگیری جدید برای «${widget.subject.text}»'),
        content: TextField(
          key: const Key('follow-up-input'),
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'شرح پیگیری',
            hintText: 'مثلاً تماس گرفتم، نتیجه این شد…',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => draft = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('انصراف'),
          ),
          FilledButton(
            key: const Key('follow-up-save'),
            onPressed: () {
              final normalized = draft.trim();
              if (normalized.isEmpty) {
                return;
              }
              Navigator.of(dialogContext).pop(normalized);
            },
            child: const Text('ثبت پیگیری'),
          ),
        ],
      ),
    );

    if (text == null || !mounted) {
      return;
    }

    try {
      await widget.addFollowUp.add(subject: widget.subject, text: text);
      await _reload();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ثبت پیگیری انجام نشد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subject.text,
          key: const Key('tracked-subject-detail-title'),
        ),
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
                    const Text(
                      'موضوع پیگیری',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(widget.subject.text),
                    const SizedBox(height: 10),
                    Text(
                      'شروع: ${widget.dateTimeFormatter.formatDateTime(widget.subject.timelineAt)}',
                      key: const Key('tracked-subject-created-at'),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _followUps.isEmpty
                          ? 'هنوز پیگیری ثبت نشده است.'
                          : 'آخرین پیگیری: ${widget.dateTimeFormatter.formatDateTime(_followUps.first.timelineAt)}',
                      key: const Key('tracked-subject-last-follow-up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: FilledButton.icon(
              key: const Key('tracked-subject-add-follow-up'),
              onPressed: _addFollowUp,
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('ثبت پیگیری جدید'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              'تاریخچه پیگیری‌ها',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: _buildFollowUpList()),
        ],
      ),
    );
  }

  Widget _buildFollowUpList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    if (_followUps.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'اولین پیگیری را ثبت کنید تا تاریخچه این موضوع شکل بگیرد.',
            key: Key('tracked-subject-follow-up-empty'),
            textAlign: TextAlign.center,
          ),
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
        return Card(
          key: Key('follow-up-${followUp.id}'),
          child: ListTile(
            leading: const Icon(Icons.history),
            title: Text(followUp.text),
            subtitle: Text(
              widget.dateTimeFormatter.formatDateTime(followUp.timelineAt),
              key: Key('follow-up-time-${followUp.id}'),
            ),
          ),
        );
      },
    );
  }
}
