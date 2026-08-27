import 'dart:io';

import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';

class JsonTimelineBackupService {
  const JsonTimelineBackupService({
    required this.repository,
    required this.clock,
  });

  final JsonFileTimelineRepository repository;
  final DateTime Function() clock;

  Future<File> createSnapshot(Directory destinationDirectory) async {
    final bytes = await repository.readValidatedSnapshotBytes();
    await destinationDirectory.create(recursive: true);

    final snapshot = File(
      '${destinationDirectory.path}/${_snapshotName(clock().toUtc())}',
    );
    await snapshot.writeAsBytes(bytes, flush: true);

    // Reuse the production parser to verify the completed snapshot file.
    await JsonFileTimelineRepository(snapshot).listNewestFirst();
    return snapshot;
  }

  String _snapshotName(DateTime value) {
    final iso = value.toIso8601String().replaceAll(':', '-');
    return 'yadnegar-backup-$iso.json';
  }
}
