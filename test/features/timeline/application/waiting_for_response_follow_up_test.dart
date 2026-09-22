import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/add_timeline_follow_up.dart';
import 'package:yadnegar/features/timeline/application/edit_timeline_item.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';

class _Repository implements TimelineRepository {
  final Map<String, TimelineItem> items = <String, TimelineItem>{};

  @override
  Future<bool> deleteById(String id) async => items.remove(id) != null;

  @override
  Future<TimelineItem?> findById(String id) async => items[id];

  @override
  Future<List<TimelineItem>> listNewestFirst() async => items.values.toList();

  @override
  Future<void> upsert(TimelineItem item) async => items[item.id] = item;
}

void main() {
  test('follow-up can be created as waiting for response', () async {
    final repository = _Repository();
    final root = TimelineItem(
      id: 'root',
      type: TimelineItemType.activity,
      text: 'تماس با مشتری',
      createdAt: DateTime(2026, 9, 20, 9),
    );
    repository.items[root.id] = root;

    final saved = await AddTimelineFollowUp(
      repository: repository,
      clock: () => DateTime(2026, 9, 20, 10),
      idGenerator: () => 'follow-up',
    ).add(
      subject: root,
      text: 'ارسال پیشنهاد',
      followUpStatus: TimelineFollowUpStatus.waitingForResponse,
    );

    expect(saved.isFollowUp, isTrue);
    expect(saved.isWaitingForResponse, isTrue);
    expect(saved.followUpStatus, TimelineFollowUpStatus.waitingForResponse);
  });

  test('follow-up status can be changed without changing sibling history', () async {
    final repository = _Repository();
    final root = TimelineItem(
      id: 'root',
      type: TimelineItemType.activity,
      text: 'پیگیری قرارداد',
      createdAt: DateTime(2026, 9, 20, 8),
    );
    final sibling = TimelineItem(
      id: 'sibling',
      parentId: root.id,
      type: root.type,
      text: 'تماس اول',
      createdAt: DateTime(2026, 9, 20, 9),
    );
    final target = TimelineItem(
      id: 'target',
      parentId: root.id,
      type: root.type,
      text: 'ارسال پیش‌نویس',
      createdAt: DateTime(2026, 9, 20, 10),
    );
    repository.items.addAll({root.id: root, sibling.id: sibling, target.id: target});

    final updated = await EditTimelineItem(repository: repository).update(
      id: target.id,
      text: target.text,
      replaceFollowUpStatus: true,
      followUpStatus: TimelineFollowUpStatus.waitingForResponse,
    );

    expect(updated.followUpStatus, TimelineFollowUpStatus.waitingForResponse);
    expect(repository.items[sibling.id]?.followUpStatus, TimelineFollowUpStatus.open);
  });

  test('schema v9 follow-ups remain open and are upgraded on next write', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar_waiting_status_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    await file.writeAsString(jsonEncode({
      'schemaVersion': 9,
      'projects': <dynamic>[],
      'categories': <dynamic>[],
      'tags': <dynamic>[],
      'items': [
        {
          'id': 'root',
          'type': 'activity',
          'text': 'کار',
          'createdAt': '2026-09-20T08:00:00.000Z',
          'parentId': null,
          'occurredAt': null,
          'reminderAt': null,
          'reminderRecurrence': 'none',
          'reminderKind': 'standard',
          'medicationName': null,
          'medicationAmount': null,
          'medicationUnit': null,
          'medicationIntervalMs': null,
          'scheduledAt': null,
          'actualTakenAt': null,
          'description': null,
          'projectId': null,
          'categoryId': null,
          'tagIds': <dynamic>[],
          'nextActionAt': null,
        },
        {
          'id': 'follow',
          'type': 'activity',
          'text': 'تماس شد',
          'createdAt': '2026-09-20T09:00:00.000Z',
          'parentId': 'root',
          'occurredAt': '2026-09-20T09:00:00.000Z',
          'reminderAt': null,
          'reminderRecurrence': 'none',
          'reminderKind': 'standard',
          'medicationName': null,
          'medicationAmount': null,
          'medicationUnit': null,
          'medicationIntervalMs': null,
          'scheduledAt': null,
          'actualTakenAt': null,
          'description': null,
          'projectId': null,
          'categoryId': null,
          'tagIds': <dynamic>[],
          'nextActionAt': null,
        },
      ],
    }), flush: true);

    final repository = JsonFileTimelineRepository(file);
    final follow = await repository.findById('follow');
    expect(follow?.followUpStatus, TimelineFollowUpStatus.open);

    await repository.upsert(follow!);
    final decoded = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], JsonFileTimelineRepository.schemaVersion);
    final items = (decoded['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    expect(items.singleWhere((item) => item['id'] == 'follow')['followUpStatus'], 'open');
  });

  test('waiting status survives JSON round trip', () async {
    final directory = await Directory.systemTemp.createTemp('yadnegar_waiting_round_trip_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/timeline.json');
    final repository = JsonFileTimelineRepository(file);
    final root = TimelineItem(
      id: 'root',
      type: TimelineItemType.activity,
      text: 'درخواست',
      createdAt: DateTime.utc(2026, 9, 20, 8),
    );
    final follow = TimelineItem(
      id: 'follow',
      parentId: root.id,
      type: root.type,
      text: 'منتظر پاسخ',
      createdAt: DateTime.utc(2026, 9, 20, 9),
      followUpStatus: TimelineFollowUpStatus.waitingForResponse,
    );
    await repository.upsert(root);
    await repository.upsert(follow);

    final reloaded = await JsonFileTimelineRepository(file).findById('follow');
    expect(reloaded?.followUpStatus, TimelineFollowUpStatus.waitingForResponse);
    expect(reloaded?.isWaitingForResponse, isTrue);
  });
}
