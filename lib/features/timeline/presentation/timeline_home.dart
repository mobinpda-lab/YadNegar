import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

class TimelineHome extends StatefulWidget {
  const TimelineHome({
    super.key,
    required this.quickCapture,
    required this.loadTimeline,
  });

  final QuickCapture quickCapture;
  final LoadTimeline loadTimeline;

  @override
  State<TimelineHome> createState() => _TimelineHomeState();
}

class _TimelineHomeState extends State<TimelineHome> {
  List<TimelineItem> _items = const <TimelineItem>[];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final items = await widget.loadTimeline.load();
      if (!mounted) {
        return;
      }
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'بارگذاری Timeline انجام نشد.';
      });
    }
  }

  Future<void> _openQuickCapture() async {
    var draft = '';
    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ثبت سریع'),
        content: TextField(
          key: const Key('quick-capture-input'),
          autofocus: true,
          minLines: 1,
          maxLines: 4,
          onChanged: (value) => draft = value,
          decoration: const InputDecoration(
            hintText: 'چه چیزی را می‌خواهید به خاطر بسپارید؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('انصراف'),
          ),
          FilledButton(
            key: const Key('quick-capture-save'),
            onPressed: () => Navigator.of(dialogContext).pop(draft),
            child: const Text('ثبت'),
          ),
        ],
      ),
    );

    if (text == null) {
      return;
    }

    try {
      await widget.quickCapture.capture(text: text);
      await _reload();
    } on ArgumentError {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('متن ثبت سریع نمی‌تواند خالی باشد.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ثبت مورد جدید انجام نشد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TimelineScreen(
      items: _items,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      onQuickCapture: _isLoading ? null : _openQuickCapture,
    );
  }
}
