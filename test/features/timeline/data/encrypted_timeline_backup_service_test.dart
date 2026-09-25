import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/data/encrypted_timeline_backup_service.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';

void main() {
  late Directory tempDirectory;
  late JsonFileTimelineRepository repository;
  late EncryptedTimelineBackupService service;

  setUp(() async {
    tempDirectory =
        await Directory.systemTemp.createTemp('yadnegar_encrypted_backup_test_');
    repository = JsonFileTimelineRepository(
      File('${tempDirectory.path}/timeline.json'),
    );
    service = EncryptedTimelineBackupService(repository: repository);
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  Future<void> seed() async {
    await repository.upsert(
      TimelineItem(
        id: 'subject-1',
        type: TimelineItemType.note,
        text: 'اطلاعات محرمانه یادنگار',
        createdAt: DateTime.utc(2026, 9, 25, 10),
      ),
    );
  }

  test('round trips an existing validated snapshot with a password', () async {
    await seed();
    final snapshot = await repository.readValidatedSnapshotBytes();

    final encrypted = await service.encryptSnapshot(
      snapshot,
      password: 'correct-horse-battery',
    );
    final clear = await service.decryptSnapshot(
      encrypted,
      password: 'correct-horse-battery',
    );

    expect(utf8.decode(clear), utf8.decode(snapshot));
    expect(utf8.decode(encrypted), isNot(contains('اطلاعات محرمانه یادنگار')));
  });

  test('uses a fresh salt and nonce for each encrypted backup', () async {
    await seed();
    final snapshot = await repository.readValidatedSnapshotBytes();

    final first = jsonDecode(utf8.decode(await service.encryptSnapshot(
      snapshot,
      password: 'correct-horse-battery',
    ))) as Map<String, dynamic>;
    final second = jsonDecode(utf8.decode(await service.encryptSnapshot(
      snapshot,
      password: 'correct-horse-battery',
    ))) as Map<String, dynamic>;

    expect(first['salt'], isNot(equals(second['salt'])));
    expect(first['nonce'], isNot(equals(second['nonce'])));
  });

  test('rejects a wrong password without restoring data', () async {
    await seed();
    final snapshot = await repository.readValidatedSnapshotBytes();
    final encrypted = await service.encryptSnapshot(
      snapshot,
      password: 'correct-horse-battery',
    );

    await expectLater(
      service.decryptSnapshot(
        encrypted,
        password: 'wrong-password',
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects ciphertext tampering without restoring data', () async {
    await seed();
    final snapshot = await repository.readValidatedSnapshotBytes();
    final envelope = jsonDecode(
      utf8.decode(await service.encryptSnapshot(
        snapshot,
        password: 'correct-horse-battery',
      )),
    ) as Map<String, dynamic>;
    final cipherText = base64Decode(envelope['cipherText'] as String);
    cipherText[0] ^= 1;
    envelope['cipherText'] = base64Encode(cipherText);

    await expectLater(
      service.decryptSnapshot(
        utf8.encode(const JsonEncoder.withIndent('  ').convert(envelope)),
        password: 'correct-horse-battery',
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('restores the encrypted snapshot through the existing repository',
      () async {
    await seed();
    final snapshot = await repository.readValidatedSnapshotBytes();
    final encrypted = await service.encryptSnapshot(
      snapshot,
      password: 'correct-horse-battery',
    );

    final otherRepository = JsonFileTimelineRepository(
      File('${tempDirectory.path}/restored.json'),
    );
    final otherService = EncryptedTimelineBackupService(
      repository: otherRepository,
    );
    await otherService.restoreEncryptedSnapshot(
      encrypted,
      password: 'correct-horse-battery',
    );

    final restored = await otherRepository.listNewestFirst();
    expect(restored.single.text, 'اطلاعات محرمانه یادنگار');
  });

  test('rejects passwords shorter than eight characters', () {
    expect(
      () => service.encryptSnapshot(
        const <int>[],
        password: 'short',
      ),
      throwsArgumentError,
    );
  });
}
