import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:yadnegar/features/timeline/data/json_file_timeline_repository.dart';

class EncryptedTimelineBackupService {
  EncryptedTimelineBackupService({
    required this.repository,
    Cryptography? cryptography,
  }) : _cryptography = cryptography ?? Cryptography.instance;

  static const int envelopeVersion = 1;
  static const int saltLength = 16;
  static const int nonceLength = 12;
  static const int keyLength = 32;
  static const int argon2MemoryKiB = 19 * 1024;
  static const int argon2Parallelism = 1;
  static const int argon2Iterations = 2;

  final JsonFileTimelineRepository repository;
  final Cryptography _cryptography;

  Future<File> createEncryptedSnapshot(
    Directory destinationDirectory, {
    required String password,
    DateTime Function()? clock,
  }) async {
    _validatePassword(password);
    final bytes = await repository.readValidatedSnapshotBytes();
    await destinationDirectory.create(recursive: true);

    final encrypted = await encryptSnapshot(bytes, password: password);
    final timestamp = (clock ?? DateTime.now)().toUtc();
    final name =
        'yadnegar-backup-${timestamp.toIso8601String().replaceAll(':', '-')}.ydb';
    final file = File('${destinationDirectory.path}/$name');
    await file.writeAsBytes(encrypted, flush: true);
    return file;
  }

  Future<List<int>> encryptSnapshot(
    List<int> snapshotBytes, {
    required String password,
  }) async {
    _validatePassword(password);

    final salt = randomBytes(saltLength);
    final algorithm = Argon2id(
      memory: argon2MemoryKiB,
      parallelism: argon2Parallelism,
      iterations: argon2Iterations,
      hashLength: keyLength,
    );
    final secretKey = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    final cipher = AesGcm.with256bits(nonceLength: nonceLength);
    final nonce = cipher.newNonce();
    final associatedData = utf8.encode(_associatedData());
    final box = await cipher.encrypt(
      snapshotBytes,
      secretKey: secretKey,
      nonce: nonce,
      aad: associatedData,
    );

    final envelope = <String, Object>{
      'format': 'yadnegar-encrypted-backup',
      'version': envelopeVersion,
      'kdf': <String, Object>{
        'algorithm': 'argon2id',
        'memoryKiB': argon2MemoryKiB,
        'parallelism': argon2Parallelism,
        'iterations': argon2Iterations,
        'hashLength': keyLength,
      },
      'cipher': <String, Object>{
        'algorithm': 'aes-256-gcm',
        'nonceLength': nonceLength,
      },
      'salt': base64Encode(salt),
      'nonce': base64Encode(box.nonce),
      'cipherText': base64Encode(box.cipherText),
      'mac': base64Encode(box.mac.bytes),
    };
    return utf8.encode(const JsonEncoder.withIndent('  ').convert(envelope));
  }

  Future<List<int>> decryptSnapshot(
    List<int> encryptedBytes, {
    required String password,
  }) async {
    _validatePassword(password);

    final raw = utf8.decode(encryptedBytes, allowMalformed: false);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Encrypted backup root must be a JSON object.');
    }
    if (decoded['format'] != 'yadnegar-encrypted-backup') {
      throw const FormatException('Unsupported encrypted backup format.');
    }
    if (decoded['version'] != envelopeVersion) {
      throw const FormatException('Unsupported encrypted backup version.');
    }

    final kdf = _map(decoded, 'kdf');
    final cipherMeta = _map(decoded, 'cipher');
    if (kdf['algorithm'] != 'argon2id' ||
        kdf['memoryKiB'] != argon2MemoryKiB ||
        kdf['parallelism'] != argon2Parallelism ||
        kdf['iterations'] != argon2Iterations ||
        kdf['hashLength'] != keyLength) {
      throw const FormatException('Unsupported Argon2id parameters.');
    }
    if (cipherMeta['algorithm'] != 'aes-256-gcm' ||
        cipherMeta['nonceLength'] != nonceLength) {
      throw const FormatException('Unsupported AES-GCM parameters.');
    }

    final salt = _decodeBase64(decoded, 'salt');
    final nonce = _decodeBase64(decoded, 'nonce');
    final cipherText = _decodeBase64(decoded, 'cipherText');
    final mac = _decodeBase64(decoded, 'mac');
    if (salt.length != saltLength ||
        nonce.length != nonceLength ||
        mac.length != 16) {
      throw const FormatException('Invalid encrypted backup envelope.');
    }

    final algorithm = Argon2id(
      memory: argon2MemoryKiB,
      parallelism: argon2Parallelism,
      iterations: argon2Iterations,
      hashLength: keyLength,
    );
    final secretKey = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final cipher = AesGcm.with256bits(nonceLength: nonceLength);

    try {
      final clearText = await cipher.decrypt(
        SecretBox(cipherText, nonce: nonce, mac: Mac(mac)),
        secretKey: secretKey,
        aad: utf8.encode(_associatedData()),
      );
      await _validateSnapshot(clearText);
      return clearText;
    } on SecretBoxAuthenticationError {
      throw const FormatException(
        'Encrypted backup password is incorrect or data was tampered with.',
      );
    }
  }

  Future<void> restoreEncryptedSnapshot(
    List<int> encryptedBytes, {
    required String password,
  }) async {
    final snapshot = await decryptSnapshot(
      encryptedBytes,
      password: password,
    );
    await repository.restoreValidatedSnapshotBytes(snapshot);
  }

  Future<void> _validateSnapshot(List<int> bytes) async {
    final temporaryDirectory = await Directory.systemTemp.createTemp(
      'yadnegar_encrypted_backup_validation_',
    );
    try {
      final file = File(temporaryDirectory.path + '/snapshot.json');
      await file.writeAsBytes(bytes, flush: true);
      await JsonFileTimelineRepository(file).listNewestFirst();
    } finally {
      if (await temporaryDirectory.exists()) {
        await temporaryDirectory.delete(recursive: true);
      }
    }
  }

  Map<String, dynamic> _map(Map<String, dynamic> value, String key) {
    final nested = value[key];
    if (nested is! Map<String, dynamic>) {
      throw FormatException('$key must be a JSON object.');
    }
    return nested;
  }

  List<int> _decodeBase64(Map<String, dynamic> value, String key) {
    final raw = value[key];
    if (raw is! String || raw.isEmpty) {
      throw FormatException('$key must be a non-empty base64 string.');
    }
    try {
      return base64Decode(raw);
    } on FormatException {
      throw FormatException('Invalid base64 in $key.');
    }
  }

  String _associatedData() =>
      'yadnegar-encrypted-backup:v$envelopeVersion:argon2id:aes-256-gcm';

  void _validatePassword(String password) {
    if (password.trim().length < 8) {
      throw ArgumentError.value(
        password,
        'password',
        'Backup password must contain at least 8 characters.',
      );
    }
  }
}
