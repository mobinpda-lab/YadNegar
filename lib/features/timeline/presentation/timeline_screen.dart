import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({
    super.key,
    this.onQuickCapture,
  });

  final VoidCallback? onQuickCapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('یادنگار'),
        centerTitle: false,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timeline, size: 48),
              SizedBox(height: 16),
              Text(
                'هنوز چیزی ثبت نشده',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Timeline یادنگار پس از ثبت اولین مورد از همین‌جا شروع می‌شود.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onQuickCapture,
        tooltip: 'ثبت سریع',
        icon: const Icon(Icons.add),
        label: const Text('ثبت سریع'),
      ),
    );
  }
}
