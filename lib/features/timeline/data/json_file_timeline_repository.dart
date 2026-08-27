import 'dart:convert';
import 'dart:io';

import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class UnsupportedTimelineStorageSchemaException extends FormatException {
  UnsupportedTimelineStorageSchemaException(Object? version)
      : super('Unsupported Timeline storage schema version: $version.');
}

class DuplicateTimelineItemIdException extends FormatException {
  DuplicateTimelineItemIdException(String id)
      : super('Duplicate Timeline item id: $id.');
}

class JsonFileTimelineRepository implements TimelineRepository {
  JsonFileTimelineRepository(this.file);

  static const int schemaVersion = 2;
  static const int legacySchemaVersion = 1;

  final File file;

  File get _temporaryFile => File('${file.path}.tmp');
  File get _backupFile => File('${file.path}.bak');

  @override
  Future<void> upsert(TimelineItem item) async {
    final items = await _readAll();
    final existingIndex = items.indexWhere((candidate) => candidate.id == item.id);

    if (existingIndex == -1) {
      items.add(item);
    } else {
      items[existingIndex] = item;
    }

    _sortNewestFirst(items);
    await _writeAll(items);
  }

  @override
  Future<bool> deleteById(String id) async {
    final items = await _readAll();
    final previousLength = items.length;
    items.removeWhere((item) => item.id == id);

    if (items.length == previousLength) {
      return false;
    }

    _sortNewestFirst(items);
    await _writeAll(items);
    return true;
  }

  @override
  Future<TimelineItem?> findById(String id) async {
    final items = await _readAll();
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async {
    final items = await _readAll();
    _sortNewestFirst(items);
    return List<TimelineItem>.unmodifiable(items);
  }

  Future<List<int>> readValidatedSnapshotBytes() async {
    final items = await _readAll();
    if (await file.exists()) {
      return file.readAsBytes();
    }
    return utf8.encode(_encodeItems(items));
  }

  Future<void> restoreValidatedSnapshotBytes(List<int> bytes) async {
    final raw = utf8.decode(bytes, allowMalformed: false);
    if (raw.trim().isEmpty) {
      throw const FormatException('Timeline backup cannot be empty.');
    }

    final items = _decodeItems(raw);
    final seenIds = <String>{};
    for (final item in items) {
      if (!seenIds.add(item.id)) {
        throw DuplicateTimelineItemIdException(item.id);
      }
    }

    _sortNewestFirst(items);
    await _writeAll(items);
  }

  Future<List<TimelineItem>> _readAll() async {
    await _recoverMissingPrimary();

    if (!await file.exists()) {
      return <TimelineItem>[];
    }

    try {
      final items = await _readItemsFrom(file);
      await _cleanupStagingFiles();
      return items;
    } on FormatException {
      if (!await _backupFile.exists()) {
        rethrow;
      }

      final backupItems = await _readItemsFrom(_backupFile);
      await file.delete();
      await _backupFile.rename(file.path);
      await _tryDelete(_temporaryFile);
      return backupItems;
    }
  }

  Future<void> _recoverMissingPrimary() async {
    if (await file.exists()) {
      return;
    }

    if (await _backupFile.exists()) {
      await _backupFile.rename(file.path);
      await _tryDelete(_temporaryFile);
      return;
    }

    if (!await _temporaryFile.exists()) {
      return;
    }

    try {
      await _readItemsFrom(_temporaryFile);
      await _temporaryFile.rename(file.path);
    } on FormatException {
      await _tryDelete(_temporaryFile);
    }
  }

  Future<List<TimelineItem>> _readItemsFrom(File source) async {
    final raw = await source.readAsString();
    if (raw.trim().isEmpty) {
      return <TimelineItem>[];
    }
    return _decodeItems(raw);
  }

  List<TimelineItem> _decodeItems(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Timeline storage root must be a JSON object.');
    }

    final version = decoded['schemaVersion'];
    if (version != schemaVersion && version != legacySchemaVersion) {
      throw UnsupportedTimelineStorageSchemaException(version);
    }

    final rawItems = decoded['items'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException('Timeline storage items must be a JSON list.');
    }

    return rawItems
        .map<TimelineItem>(
          (value) => _itemFromJson(value, sourceSchemaVersion: version as int),
        )
        .toList(growable: true);
  }

  Future<void> _writeAll(List<TimelineItem> items) async {
    await file.parent.create(recursive: true);
    final encoded = _encodeItems(items);

    await _tryDelete(_temporaryFile);
    await _temporaryFile.writeAsString(encoded, flush: true);

    // Validate the staged payload before moving the current primary aside.
    await _readItemsFrom(_temporaryFile);

    await _tryDelete(_backupFile);
    if (await file.exists()) {
      await file.rename(_backupFile.path);
    }

    try {
      await _temporaryFile.rename(file.path);
    } catch (_) {
      if (!await file.exists() && await _backupFile.exists()) {
        await _backupFile.rename(file.path);
      }
      rethrow;
    }

    await _tryDelete(_backupFile);
  }

  String _encodeItems(List<TimelineItem> items) {
    final payload = <String, Object>{
      'schemaVersion': schemaVersion,
      'items': items.map<Map<String, Object?>>(_itemToJson).toList(),
    };
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(payload);
  }

  Future<void> _cleanupStagingFiles() async {
    await _tryDelete(_temporaryFile);
    await _tryDelete(_backupFile);
  }

  Future<void> _tryDelete(File candidate) async {
    try {
      if (await candidate.exists()) {
        await candidate.delete();
      }
    } on FileSystemException {
      // Staging cleanup is best-effort. A later read can safely retry it.
    }
  }

  TimelineItem _itemFromJson(
    dynamic value, {
    required int sourceSchemaVersion,
  }) {
    if (value is! Map<String, dynamic>) {
      throw const FormatException('Timeline item must be a JSON object.');
    }

    final id = _requiredString(value, 'id');
    final typeName = _requiredString(value, 'type');
    final text = _requiredString(value, 'text');
    final createdAt = _requiredDateTime(value, 'createdAt');

    TimelineItemType? type;
    for (final candidate in TimelineItemType.values) {
      if (candidate.name == typeName) {
        type = candidate;
        break;
      }
    }
    if (type == null) {
      throw FormatException('Unknown Timeline item type: $typeName.');
    }

    final occurredAt = _optionalDateTime(value, 'occurredAt');
    final reminderAt = sourceSchemaVersion >= schemaVersion
        ? _optionalDateTime(value, 'reminderAt')
        : null;

    return TimelineItem(
      id: id,
      type: type,
      text: text,
      createdAt: createdAt,
      occurredAt: occurredAt,
      reminderAt: reminderAt,
    );
  }

  Map<String, Object?> _itemToJson(TimelineItem item) {
    return <String, Object?>{
      'id': item.id,
      'type': item.type.name,
      'text': item.text,
      'createdAt': item.createdAt.toIso8601String(),
      'occurredAt': item.occurredAt?.toIso8601String(),
      'reminderAt': item.reminderAt?.toIso8601String(),
    };
  }

  String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String) {
      throw FormatException('$key must be a string.');
    }
    return value;
  }

  DateTime _requiredDateTime(Map<String, dynamic> json, String key) {
    final raw = _requiredString(json, key);
    final value = DateTime.tryParse(raw);
    if (value == null) {
      throw FormatException('$key must be a valid ISO-8601 value.');
    }
    return value;
  }

  DateTime? _optionalDateTime(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw == null) {
      return null;
    }
    if (raw is! String) {
      throw FormatException('$key must be an ISO-8601 string.');
    }
    final value = DateTime.tryParse(raw);
    if (value == null) {
      throw FormatException('Invalid $key value: $raw.');
    }
    return value;
  }

  void _sortNewestFirst(List<TimelineItem> items) {
    items.sort((left, right) {
      final timelineOrder = right.timelineAt.compareTo(left.timelineAt);
      if (timelineOrder != 0) {
        return timelineOrder;
      }

      final createdOrder = right.createdAt.compareTo(left.createdAt);
      if (createdOrder != 0) {
        return createdOrder;
      }

      return left.id.compareTo(right.id);
    });
  }
}
