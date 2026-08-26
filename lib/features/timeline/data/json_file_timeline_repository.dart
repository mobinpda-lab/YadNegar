import 'dart:convert';
import 'dart:io';

import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class JsonFileTimelineRepository implements TimelineRepository {
  JsonFileTimelineRepository(this.file);

  static const int schemaVersion = 1;

  final File file;

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

  Future<List<TimelineItem>> _readAll() async {
    if (!await file.exists()) {
      return <TimelineItem>[];
    }

    final raw = await file.readAsString();
    if (raw.trim().isEmpty) {
      return <TimelineItem>[];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Timeline storage root must be a JSON object.');
    }

    final version = decoded['schemaVersion'];
    if (version != schemaVersion) {
      throw FormatException(
        'Unsupported Timeline storage schema version: $version.',
      );
    }

    final rawItems = decoded['items'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException('Timeline storage items must be a JSON list.');
    }

    return rawItems.map<TimelineItem>(_itemFromJson).toList(growable: true);
  }

  Future<void> _writeAll(List<TimelineItem> items) async {
    await file.parent.create(recursive: true);

    final payload = <String, Object>{
      'schemaVersion': schemaVersion,
      'items': items.map<Map<String, Object?>>(_itemToJson).toList(),
    };

    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(payload), flush: true);
  }

  TimelineItem _itemFromJson(dynamic value) {
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

    DateTime? occurredAt;
    final rawOccurredAt = value['occurredAt'];
    if (rawOccurredAt != null) {
      if (rawOccurredAt is! String) {
        throw const FormatException('occurredAt must be an ISO-8601 string.');
      }
      occurredAt = DateTime.tryParse(rawOccurredAt);
      if (occurredAt == null) {
        throw FormatException('Invalid occurredAt value: $rawOccurredAt.');
      }
    }

    return TimelineItem(
      id: id,
      type: type,
      text: text,
      createdAt: createdAt,
      occurredAt: occurredAt,
    );
  }

  Map<String, Object?> _itemToJson(TimelineItem item) {
    return <String, Object?>{
      'id': item.id,
      'type': item.type.name,
      'text': item.text,
      'createdAt': item.createdAt.toIso8601String(),
      'occurredAt': item.occurredAt?.toIso8601String(),
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
