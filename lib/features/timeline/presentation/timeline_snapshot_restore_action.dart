enum TimelineSnapshotRestoreResult {
  restored,
  cancelled,
  invalidBackup,
  unsupportedSchema,
  duplicateId,
}

typedef TimelineSnapshotRestoreAction = Future<TimelineSnapshotRestoreResult> Function();
