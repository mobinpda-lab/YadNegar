import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

void main() {
  runApp(const YadNegarApp());
}

class YadNegarApp extends StatelessWidget {
  const YadNegarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'یادنگار',
      locale: const Locale('fa'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const TimelineScreen(),
    );
  }
}
