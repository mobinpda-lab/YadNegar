import 'package:flutter/material.dart';

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
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Center(
            child: Text('یادنگار'),
          ),
        ),
      ),
    );
  }
}
