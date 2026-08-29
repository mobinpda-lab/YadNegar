import 'dart:convert';
import 'dart:io';

import 'package:yadnegar/features/timeline/domain/project_repository.dart';
import 'package:yadnegar/features/timeline/domain/taxonomy_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_taxonomy.dart';

class UnsupportedTimelineStorageSchemaException extends FormatException {
  UnsupportedTimelineStorageSchemaException(Object? version)
      : super('Unsupported Timeline storage schema version: $version.');
}

class DuplicateTimelineItemIdException extends FormatException {
  DuplicateTimelineItemIdException(String id)
      : super('Duplicate Timeline item id: $id.');
}

class DuplicateProjectIdException extends FormatException {
  DuplicateProjectIdException(String id)
      : super('Duplicate Project id: $id.');
}

class DuplicateCategoryIdException extends FormatException {
  DuplicateCategoryIdException(String id)
      : super('Duplicate Category id: $id.');
}

class DuplicateTagIdException extends FormatException {
  DuplicateTagIdException(String id) : super('Duplicate Tag id: $id.');
}

class JsonFileTimelineRepository
    implements TimelineRepository, ProjectRepository, TaxonomyRepository {
  JsonFileTimelineRepository(this.file);

  static const int schemaVersion = 8;
  static const int nextActionSchemaVersion = 7;
  static const int projectSchemaVersion = 6;
  static const int descriptionSchemaVersion = 5;
  static const int followUpSchemaVersion = 4;
  static const int recurrenceSchemaVersion = 3;
  static const int reminderSchemaVersion = 2;
  static const int legacySchemaVersion = 1;

  final File file;

  File get _temporaryFile => File('${file.path}.tmp');
  File get _backupFile => File('${file.path}.bak');

  @override
  Future<void> upsert(TimelineItem item) async {
    final storage = await _readStorage();
    final items = List<TimelineItem>.of(storage.items);
    final existingIndex = items.indexWhere((candidate) => candidate.id == item.id);
    if (existingIndex == -1) {
      items.add(item);
    } else {
      items[existingIndex] = item;
    }
    _sortNewestFirst(items);
    await _writeStorage(storage.copyWith(items: items));
  }

  @override
  Future<bool> deleteById(String id) async {
    final storage = await _readStorage();
    final items = List<TimelineItem>.of(storage.items);
    final previousLength = items.length;
    items.removeWhere((item) => item.id == id);
    if (items.length == previousLength) return false;
    _sortNewestFirst(items);
    await _writeStorage(storage.copyWith(items: items));
    return true;
  }

  @override
  Future<TimelineItem?> findById(String id) async {
    final storage = await _readStorage();
    for (final item in storage.items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<TimelineItem>> listNewestFirst() async {
    final storage = await _readStorage();
    final items = List<TimelineItem>.of(storage.items);
    _sortNewestFirst(items);
    return List<TimelineItem>.unmodifiable(items);
  }

  @override
  Future<List<YadNegarProject>> listProjects() async {
    final storage = await _readStorage();
    final projects = List<YadNegarProject>.of(storage.projects)
      ..sort((left, right) => left.title.compareTo(right.title));
    return List<YadNegarProject>.unmodifiable(projects);
  }

  @override
  Future<YadNegarProject?> findProjectById(String id) async {
    final storage = await _readStorage();
    for (final project in storage.projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  @override
  Future<void> upsertProject(YadNegarProject project) async {
    final storage = await _readStorage();
    final projects = List<YadNegarProject>.of(storage.projects);
    final index = projects.indexWhere((candidate) => candidate.id == project.id);
    if (index == -1) {
      projects.add(project);
    } else {
      projects[index] = project;
    }
    await _writeStorage(storage.copyWith(projects: projects));
  }

  @override
  Future<bool> deleteProjectById(String id) async {
    final storage = await _readStorage();
    final projects = List<YadNegarProject>.of(storage.projects);
    final previousLength = projects.length;
    projects.removeWhere((project) => project.id == id);
    if (projects.length == previousLength) return false;
    await _writeStorage(storage.copyWith(projects: projects));
    return true;
  }

  @override
  Future<List<YadNegarCategory>> listCategories() async {
    final storage = await _readStorage();
    final categories = List<YadNegarCategory>.of(storage.categories)
      ..sort((left, right) => left.title.compareTo(right.title));
    return List<YadNegarCategory>.unmodifiable(categories);
  }

  @override
  Future<List<YadNegarTag>> listTags() async {
    final storage = await _readStorage();
    final tags = List<YadNegarTag>.of(storage.tags)
      ..sort((left, right) => left.title.compareTo(right.title));
    return List<YadNegarTag>.unmodifiable(tags);
  }

  @override
  Future<YadNegarCategory?> findCategoryById(String id) async {
    final storage = await _readStorage();
    for (final category in storage.categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  @override
  Future<YadNegarTag?> findTagById(String id) async {
    final storage = await _readStorage();
    for (final tag in storage.tags) {
      if (tag.id == id) return tag;
    }
    return null;
  }

  @override
  Future<void> upsertCategory(YadNegarCategory category) async {
    final storage = await _readStorage();
    final categories = List<YadNegarCategory>.of(storage.categories);
    final index = categories.indexWhere((candidate) => candidate.id == category.id);
    if (index == -1) {
      categories.add(category);
    } else {
      categories[index] = category;
    }
    await _writeStorage(storage.copyWith(categories: categories));
  }

  @override
  Future<void> upsertTag(YadNegarTag tag) async {
    final storage = await _readStorage();
    final tags = List<YadNegarTag>.of(storage.tags);
    final index = tags.indexWhere((candidate) => candidate.id == tag.id);
    if (index == -1) {
      tags.add(tag);
    } else {
      tags[index] = tag;
    }
    await _writeStorage(storage.copyWith(tags: tags));
  }

  @override
  Future<bool> deleteCategoryById(String id) async {
    final storage = await _readStorage();
    if (storage.items.any((item) => item.isTrackedSubject && item.categoryId == id)) {
      return false;
    }
    final categories = List<YadNegarCategory>.of(storage.categories);
    final previousLength = categories.length;
    categories.removeWhere((category) => category.id == id);
    if (categories.length == previousLength) return false;
    await _writeStorage(storage.copyWith(categories: categories));
    return true;
  }

  @override
  Future<bool> deleteTagById(String id) async {
    final storage = await _readStorage();
    if (storage.items.any((item) => item.isTrackedSubject && item.tagIds.contains(id))) {
      return false;
    }
    final tags = List<YadNegarTag>.of(storage.tags);
    final previousLength = tags.length;
    tags.removeWhere((tag) => tag.id == id);
    if (tags.length == previousLength) return false;
    await _writeStorage(storage.copyWith(tags: tags));
    return true;
  }

  Future<List<int>> readValidatedSnapshotBytes() async {
    final storage = await _readStorage();
    if (await file.exists()) return file.readAsBytes();
    return utf8.encode(_encodeStorage(storage));
  }

  Future<void> restoreValidatedSnapshotBytes(List<int> bytes) async {
    final raw = utf8.decode(bytes, allowMalformed: false);
    if (raw.trim().isEmpty) {
      throw const FormatException('Timeline backup cannot be empty.');
    }
    final storage = _decodeStorage(raw);
    _validateUniqueIds(storage);
    final items = List<TimelineItem>.of(storage.items);
    _sortNewestFirst(items);
    await _writeStorage(storage.copyWith(items: items));
  }

  Future<_TimelineStorage> _readStorage() async {
    await _recoverMissingPrimary();
    if (!await file.exists()) return const _TimelineStorage.empty();
    try {
      final storage = await _readStorageFrom(file);
      await _cleanupStagingFiles();
      return storage;
    } on FormatException {
      if (!await _backupFile.exists()) rethrow;
      final backupStorage = await _readStorageFrom(_backupFile);
      await file.delete();
      await _backupFile.rename(file.path);
      await _tryDelete(_temporaryFile);
      return backupStorage;
    }
  }

  Future<void> _recoverMissingPrimary() async {
    if (await file.exists()) return;
    if (await _backupFile.exists()) {
      await _backupFile.rename(file.path);
      await _tryDelete(_temporaryFile);
      return;
    }
    if (!await _temporaryFile.exists()) return;
    try {
      await _readStorageFrom(_temporaryFile);
      await _temporaryFile.rename(file.path);
    } on FormatException {
      await _tryDelete(_temporaryFile);
    }
  }

  Future<_TimelineStorage> _readStorageFrom(File source) async {
    final raw = await source.readAsString();
    if (raw.trim().isEmpty) return const _TimelineStorage.empty();
    return _decodeStorage(raw);
  }

  _TimelineStorage _decodeStorage(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Timeline storage root must be a JSON object.');
    }
    final version = decoded['schemaVersion'];
    if (version != schemaVersion &&
        version != nextActionSchemaVersion &&
        version != projectSchemaVersion &&
        version != descriptionSchemaVersion &&
        version != followUpSchemaVersion &&
        version != recurrenceSchemaVersion &&
        version != reminderSchemaVersion &&
        version != legacySchemaVersion) {
      throw UnsupportedTimelineStorageSchemaException(version);
    }

    final rawItems = decoded['items'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException('Timeline storage items must be a JSON list.');
    }
    final items = rawItems
        .map<TimelineItem>((value) => _itemFromJson(value, sourceSchemaVersion: version as int))
        .toList(growable: true);

    final projects = <YadNegarProject>[];
    if (version >= projectSchemaVersion) {
      final rawProjects = decoded['projects'];
      if (rawProjects is! List<dynamic>) {
        throw const FormatException('Timeline storage projects must be a JSON list.');
      }
      projects.addAll(rawProjects.map<YadNegarProject>(_projectFromJson));
    }

    final categories = <YadNegarCategory>[];
    final tags = <YadNegarTag>[];
    if (version >= schemaVersion) {
      final rawCategories = decoded['categories'];
      final rawTags = decoded['tags'];
      if (rawCategories is! List<dynamic>) {
        throw const FormatException('Timeline storage categories must be a JSON list.');
      }
      if (rawTags is! List<dynamic>) {
        throw const FormatException('Timeline storage tags must be a JSON list.');
      }
      categories.addAll(rawCategories.map<YadNegarCategory>(_categoryFromJson));
      tags.addAll(rawTags.map<YadNegarTag>(_tagFromJson));
    }

    final storage = _TimelineStorage(
      items: items,
      projects: projects,
      categories: categories,
      tags: tags,
    );
    _validateUniqueIds(storage);
    return storage;
  }

  void _validateUniqueIds(_TimelineStorage storage) {
    final seenItemIds = <String>{};
    for (final item in storage.items) {
      if (!seenItemIds.add(item.id)) throw DuplicateTimelineItemIdException(item.id);
    }
    final seenProjectIds = <String>{};
    for (final project in storage.projects) {
      if (!seenProjectIds.add(project.id)) throw DuplicateProjectIdException(project.id);
    }
    final seenCategoryIds = <String>{};
    for (final category in storage.categories) {
      if (!seenCategoryIds.add(category.id)) throw DuplicateCategoryIdException(category.id);
    }
    final seenTagIds = <String>{};
    for (final tag in storage.tags) {
      if (!seenTagIds.add(tag.id)) throw DuplicateTagIdException(tag.id);
    }
  }

  Future<void> _writeStorage(_TimelineStorage storage) async {
    await file.parent.create(recursive: true);
    final encoded = _encodeStorage(storage);
    await _tryDelete(_temporaryFile);
    await _temporaryFile.writeAsString(encoded, flush: true);
    await _readStorageFrom(_temporaryFile);
    await _tryDelete(_backupFile);
    if (await file.exists()) await file.rename(_backupFile.path);
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

  String _encodeStorage(_TimelineStorage storage) {
    final payload = <String, Object>{
      'schemaVersion': schemaVersion,
      'projects': storage.projects.map<Map<String, Object?>>(_projectToJson).toList(),
      'categories': storage.categories.map<Map<String, Object?>>(_categoryToJson).toList(),
      'tags': storage.tags.map<Map<String, Object?>>(_tagToJson).toList(),
      'items': storage.items.map<Map<String, Object?>>(_itemToJson).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> _cleanupStagingFiles() async {
    await _tryDelete(_temporaryFile);
    await _tryDelete(_backupFile);
  }

  Future<void> _tryDelete(File candidate) async {
    try {
      if (await candidate.exists()) await candidate.delete();
    } on FileSystemException {
      // Best-effort cleanup; recovery will retry safely.
    }
  }

  TimelineItem _itemFromJson(dynamic value, {required int sourceSchemaVersion}) {
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
    if (type == null) throw FormatException('Unknown Timeline item type: $typeName.');

    final description = sourceSchemaVersion >= descriptionSchemaVersion ? _optionalString(value, 'description') : null;
    final projectId = sourceSchemaVersion >= projectSchemaVersion ? _optionalString(value, 'projectId') : null;
    final categoryId = sourceSchemaVersion >= schemaVersion ? _optionalString(value, 'categoryId') : null;
    final tagIds = sourceSchemaVersion >= schemaVersion ? _optionalStringList(value, 'tagIds') : const <String>[];
    final nextActionAt = sourceSchemaVersion >= nextActionSchemaVersion ? _optionalDateTime(value, 'nextActionAt') : null;
    final parentId = sourceSchemaVersion >= followUpSchemaVersion ? _optionalString(value, 'parentId') : null;
    final occurredAt = _optionalDateTime(value, 'occurredAt');
    final reminderAt = sourceSchemaVersion >= reminderSchemaVersion ? _optionalDateTime(value, 'reminderAt') : null;
    final reminderRecurrence = sourceSchemaVersion >= recurrenceSchemaVersion
        ? _requiredReminderRecurrence(value, 'reminderRecurrence')
        : TimelineReminderRecurrence.none;

    if (parentId != null && projectId != null) {
      throw const FormatException('FollowUps cannot own projectId.');
    }
    if (parentId != null && nextActionAt != null) {
      throw const FormatException('FollowUps cannot own nextActionAt.');
    }
    if (parentId != null && categoryId != null) {
      throw const FormatException('FollowUps cannot own categoryId.');
    }
    if (parentId != null && tagIds.isNotEmpty) {
      throw const FormatException('FollowUps cannot own tagIds.');
    }

    return TimelineItem(
      id: id,
      type: type,
      text: text,
      description: description,
      projectId: projectId,
      categoryId: categoryId,
      tagIds: tagIds,
      nextActionAt: nextActionAt,
      createdAt: createdAt,
      parentId: parentId,
      occurredAt: occurredAt,
      reminderAt: reminderAt,
      reminderRecurrence: reminderRecurrence,
    );
  }

  Map<String, Object?> _itemToJson(TimelineItem item) => <String, Object?>{
        'id': item.id,
        'type': item.type.name,
        'text': item.text,
        'description': item.description,
        'projectId': item.isTrackedSubject ? item.projectId : null,
        'categoryId': item.isTrackedSubject ? item.categoryId : null,
        'tagIds': item.isTrackedSubject ? item.tagIds : const <String>[],
        'nextActionAt': item.isTrackedSubject ? item.nextActionAt?.toIso8601String() : null,
        'createdAt': item.createdAt.toIso8601String(),
        'parentId': item.parentId,
        'occurredAt': item.occurredAt?.toIso8601String(),
        'reminderAt': item.reminderAt?.toIso8601String(),
        'reminderRecurrence': item.reminderRecurrence.name,
      };

  YadNegarProject _projectFromJson(dynamic value) {
    if (value is! Map<String, dynamic>) throw const FormatException('Project must be a JSON object.');
    return YadNegarProject(
      id: _requiredString(value, 'id'),
      title: _requiredString(value, 'title'),
      colorValue: _requiredColor(value, 'Project'),
    );
  }

  Map<String, Object?> _projectToJson(YadNegarProject value) => <String, Object?>{
        'id': value.id,
        'title': value.title,
        'colorValue': value.colorValue,
      };

  YadNegarCategory _categoryFromJson(dynamic value) {
    if (value is! Map<String, dynamic>) throw const FormatException('Category must be a JSON object.');
    return YadNegarCategory(
      id: _requiredString(value, 'id'),
      title: _requiredString(value, 'title'),
      colorValue: _requiredColor(value, 'Category'),
    );
  }

  Map<String, Object?> _categoryToJson(YadNegarCategory value) => <String, Object?>{
        'id': value.id,
        'title': value.title,
        'colorValue': value.colorValue,
      };

  YadNegarTag _tagFromJson(dynamic value) {
    if (value is! Map<String, dynamic>) throw const FormatException('Tag must be a JSON object.');
    return YadNegarTag(
      id: _requiredString(value, 'id'),
      title: _requiredString(value, 'title'),
      colorValue: _requiredColor(value, 'Tag'),
    );
  }

  Map<String, Object?> _tagToJson(YadNegarTag value) => <String, Object?>{
        'id': value.id,
        'title': value.title,
        'colorValue': value.colorValue,
      };

  int _requiredColor(Map<String, dynamic> json, String entity) {
    final colorValue = json['colorValue'];
    if (colorValue is! int) throw FormatException('$entity colorValue must be an integer.');
    return colorValue;
  }

  String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('$key must be a non-empty string.');
    }
    return value;
  }

  String? _optionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is! String || value.isEmpty) {
      throw FormatException('$key must be a non-empty string when present.');
    }
    return value;
  }

  List<String> _optionalStringList(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return const <String>[];
    if (value is! List<dynamic>) throw FormatException('$key must be a JSON list.');
    final result = <String>[];
    final seen = <String>{};
    for (final entry in value) {
      if (entry is! String || entry.isEmpty) {
        throw FormatException('$key entries must be non-empty strings.');
      }
      if (seen.add(entry)) result.add(entry);
    }
    return List<String>.unmodifiable(result);
  }

  DateTime _requiredDateTime(Map<String, dynamic> json, String key) {
    final raw = _requiredString(json, key);
    final value = DateTime.tryParse(raw);
    if (value == null) throw FormatException('$key must be a valid ISO-8601 value.');
    return value;
  }

  DateTime? _optionalDateTime(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw == null) return null;
    if (raw is! String) throw FormatException('$key must be an ISO-8601 string.');
    final value = DateTime.tryParse(raw);
    if (value == null) throw FormatException('Invalid $key value: $raw.');
    return value;
  }

  TimelineReminderRecurrence _requiredReminderRecurrence(Map<String, dynamic> json, String key) {
    final name = _requiredString(json, key);
    for (final candidate in TimelineReminderRecurrence.values) {
      if (candidate.name == name) return candidate;
    }
    throw FormatException('Unknown Timeline reminder recurrence: $name.');
  }

  void _sortNewestFirst(List<TimelineItem> items) {
    items.sort((left, right) {
      final timelineOrder = right.timelineAt.compareTo(left.timelineAt);
      if (timelineOrder != 0) return timelineOrder;
      final createdOrder = right.createdAt.compareTo(left.createdAt);
      if (createdOrder != 0) return createdOrder;
      return left.id.compareTo(right.id);
    });
  }
}

class _TimelineStorage {
  const _TimelineStorage({
    required this.items,
    required this.projects,
    required this.categories,
    required this.tags,
  });

  const _TimelineStorage.empty()
      : items = const <TimelineItem>[],
        projects = const <YadNegarProject>[],
        categories = const <YadNegarCategory>[],
        tags = const <YadNegarTag>[];

  final List<TimelineItem> items;
  final List<YadNegarProject> projects;
  final List<YadNegarCategory> categories;
  final List<YadNegarTag> tags;

  _TimelineStorage copyWith({
    List<TimelineItem>? items,
    List<YadNegarProject>? projects,
    List<YadNegarCategory>? categories,
    List<YadNegarTag>? tags,
  }) {
    return _TimelineStorage(
      items: items ?? this.items,
      projects: projects ?? this.projects,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
    );
  }
}
