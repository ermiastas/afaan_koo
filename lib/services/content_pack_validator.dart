import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

import '../models/content_pack.dart';
import '../models/content_pack_manifest.dart';

/// Validates downloaded content-pack archives before installation.
///
/// Integrity is checked at two levels:
///
/// 1. The catalog checksum verifies the complete downloaded ZIP.
/// 2. The manifest checksum verifies the logical extracted content.
///
/// The manifest itself is excluded from the content checksum so that the
/// checksum does not become circular.
class ContentPackValidator {
  const ContentPackValidator();

  /// Calculates SHA-256 for a file without loading the entire file into
  /// memory.
  Future<String> calculateSha256(File file) async {
    if (!await file.exists()) {
      throw const ContentPackValidationException(
        'Downloaded pack file does not exist.',
      );
    }

    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString().toLowerCase();
  }

  /// Verifies the complete downloaded ZIP against the catalog checksum.
  Future<void> verifyChecksum({
    required File file,
    required String expectedChecksum,
  }) async {
    final expected = expectedChecksum.trim().toLowerCase();

    if (!_isSha256(expected)) {
      throw const ContentPackValidationException(
        'The catalog checksum is invalid.',
      );
    }

    final actual = await calculateSha256(file);

    if (actual != expected) {
      throw ContentPackChecksumException(
        expected: expected,
        actual: actual,
        source: 'catalog',
      );
    }
  }

  /// Validates the ZIP archive and its embedded manifest.
  Future<ContentPackManifest> validateArchive({
    required File archiveFile,
    required ContentPack expectedPack,
  }) async {
    if (!await archiveFile.exists()) {
      throw const ContentPackValidationException(
        'Content-pack archive does not exist.',
      );
    }

    final bytes = await archiveFile.readAsBytes();

    late Archive archive;

    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (error) {
      throw ContentPackValidationException(
        'The content-pack archive is invalid.',
        error,
      );
    }

    final manifestEntry = _findManifest(archive);

    if (manifestEntry == null) {
      throw const ContentPackValidationException(
        'The content pack does not contain manifest.json.',
      );
    }

    final manifestBytes = _readArchiveEntry(manifestEntry);

    late Map<String, dynamic> json;

    try {
      final decoded = jsonDecode(utf8.decode(manifestBytes));

      if (decoded is! Map) {
        throw const FormatException(
          'Manifest root must be an object.',
        );
      }

      json = Map<String, dynamic>.from(decoded);
    } catch (error) {
      throw ContentPackValidationException(
        'The content-pack manifest is invalid JSON.',
        error,
      );
    }

    late ContentPackManifest manifest;

    try {
      manifest = ContentPackManifest.fromJson(json);
    } catch (error) {
      throw ContentPackValidationException(
        'The content-pack manifest is missing required fields.',
        error,
      );
    }

    _compareManifest(
      manifest: manifest,
      expectedPack: expectedPack,
    );

    _validateRequiredFiles(archive);

    return manifest;
  }

  /// Calculates the checksum of the logical pack content.
  ///
  /// `manifest.json` is intentionally excluded.
  ///
  /// Files are sorted by normalized path so that the checksum is deterministic
  /// regardless of ZIP entry order.
  String calculateArchiveContentChecksum(Archive archive) {
    final entries = archive
        .where((entry) => entry.isFile)
        .where((entry) => !_isManifestPath(entry.name))
        .map(
          (entry) => _ContentEntry(
            path: _normalizePath(entry.name),
            bytes: _readArchiveEntry(entry),
          ),
        )
        .toList();

    entries.sort((a, b) => a.path.compareTo(b.path));

    final accumulator = BytesBuilder(copy: false);

    for (final entry in entries) {
      final pathBytes = utf8.encode(entry.path);

      accumulator.add(
        _int64Bytes(pathBytes.length),
      );
      accumulator.add(pathBytes);

      accumulator.add(
        _int64Bytes(entry.bytes.length),
      );
      accumulator.add(entry.bytes);
    }

    return sha256.convert(accumulator.takeBytes()).toString().toLowerCase();
  }

  /// Verifies the manifest checksum against the actual archive content.
  Future<void> verifyManifestContentChecksum({
    required File archiveFile,
    required ContentPackManifest manifest,
  }) async {
    final bytes = await archiveFile.readAsBytes();

    late Archive archive;

    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (error) {
      throw ContentPackValidationException(
        'The content-pack archive is invalid.',
        error,
      );
    }

    final actual = calculateArchiveContentChecksum(archive);
    final expected = manifest.checksum.trim().toLowerCase();

    if (!_isSha256(expected)) {
      throw const ContentPackValidationException(
        'The manifest content checksum is invalid.',
      );
    }

    if (actual != expected) {
      throw ContentPackChecksumException(
        expected: expected,
        actual: actual,
        source: 'manifest content',
      );
    }
  }

  ArchiveFile? _findManifest(Archive archive) {
    for (final file in archive) {
      if (!file.isFile) {
        continue;
      }

      if (_isManifestPath(file.name)) {
        return file;
      }
    }

    return null;
  }

  Uint8List _readArchiveEntry(ArchiveFile file) {
    return file.content;
  }

  void _compareManifest({
    required ContentPackManifest manifest,
    required ContentPack expectedPack,
  }) {
    if (manifest.id != expectedPack.id) {
      throw ContentPackValidationException(
        'Manifest pack ID "${manifest.id}" does not match '
        'catalog pack ID "${expectedPack.id}".',
      );
    }

    if (manifest.version != expectedPack.version) {
      throw ContentPackValidationException(
        'Manifest version ${manifest.version} does not match '
        'catalog version ${expectedPack.version}.',
      );
    }

    if (manifest.minAppVersion != expectedPack.minAppVersion) {
      throw const ContentPackValidationException(
        'Manifest minimum app version does not match the catalog.',
      );
    }

    if (manifest.lessonCount != expectedPack.lessonCount) {
      throw ContentPackValidationException(
        'Manifest lesson count does not match the catalog.',
      );
    }

    if (manifest.language != expectedPack.language) {
      throw ContentPackValidationException(
        'Manifest language does not match the catalog.',
      );
    }

    if (!manifest.isActive) {
      throw const ContentPackValidationException(
        'The content pack is not active.',
      );
    }

    /*
     * IMPORTANT:
     *
     * manifest.sizeBytes represents the uncompressed logical content size.
     * catalog.sizeBytes represents the downloaded ZIP size.
     *
     * They intentionally are NOT compared here.
     */
  }

  void _validateRequiredFiles(Archive archive) {
    final files = <String>{};

    for (final entry in archive) {
      if (!entry.isFile) {
        continue;
      }

      files.add(
        _normalizePath(entry.name),
      );
    }

    if (!files.any(_isManifestPath)) {
      throw const ContentPackValidationException(
        'The content pack is missing manifest.json.',
      );
    }

    final hasLessonContent = files.any(
      (path) =>
          path.startsWith('lessons/') ||
          path.startsWith('lesson/') ||
          path == 'lessons.json',
    );

    if (!hasLessonContent) {
      throw const ContentPackValidationException(
        'The content pack does not contain lesson content.',
      );
    }
  }

  static bool _isManifestPath(String path) {
    final normalized = _normalizePath(path);

    return normalized == 'manifest.json' ||
        normalized.endsWith('/manifest.json');
  }

  static String _normalizePath(String path) {
    return path.replaceAll('\\', '/').replaceFirst(
          RegExp(r'^/+'),
          '',
        );
  }

  static bool _isSha256(String value) {
    return RegExp(r'^[a-f0-9]{64}$').hasMatch(value);
  }

  static Uint8List _int64Bytes(int value) {
    final data = ByteData(8);
    data.setUint64(
      0,
      value,
      Endian.big,
    );

    return data.buffer.asUint8List();
  }
}

class _ContentEntry {
  const _ContentEntry({
    required this.path,
    required this.bytes,
  });

  final String path;
  final Uint8List bytes;
}

/// General content-pack validation failure.
class ContentPackValidationException implements Exception {
  const ContentPackValidationException(
    this.message, [
    this.cause,
  ]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    return 'ContentPackValidationException: $message';
  }
}

/// Raised when a downloaded archive or its logical content does not match
/// the expected checksum.
class ContentPackChecksumException
    extends ContentPackValidationException {
  ContentPackChecksumException({
    required this.expected,
    required this.actual,
    required this.source,
  }) : super(
          'Content-pack checksum verification failed.',
        );

  final String expected;
  final String actual;
  final String source;
}