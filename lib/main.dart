import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/application/load_timeline.dart';
import 'package:yadnegar/features/timeline/application/quick_capture.dart';
import 'package:yadnegar/features/timeline/application/search_timeline.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_home.dart';
import 'package:yadnegar/features/timeline/presentation/timeline_screen.dart';

final Random _secureRandom = Random.secure();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supportDirectory = await getApplicationSupportDirectory();
  final repository = JsonFileTimelineRepository(
    File('${supportDirectory.path}/timeline.json'),
  );

  runApp(
    YadNegarApp(
      home: TimelineHome(
        quickCapture: QuickCapture(
          repository: repository,
          clock: DateTime.now,
          idGenerator: _generateTimelineId,
        ),
        loadTimeline: LoadTimeline(repository: repository),
        editTimelineItem: EditTimelineItem(repository: repository),
        searchTimeline: SearchTimeline(repository: repository),
      ),
    ),
  );
}

String _generateTimelineId() {
  final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
  final randomPart = _secureRandom.nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
  return '$timestamp-$randomPart';
}

class YadNegarApp extends StatelessWidget {
  const YadNegarApp({
    super.key,
    this.home = const TimelineScreen(),
  });

  final Widget home;

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
      home: home,
    );
  }
}
