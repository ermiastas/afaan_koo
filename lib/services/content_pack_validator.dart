import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

import '../models/content_pack.dart';
import '../models/content_pack_manifest.dart';
import 'content_pack_archive_validator.dart';

/// Validates downloaded content-pack archives before installation.
class ContentPackValidator {
  const ContentPackValidator()
      : _archiveValidator = const ContentPackArchiveValidator();

  final ContentPackArchiveValidator _archiveValidator;

  Future<String> calculateSha256(File file) async {
    if (!await file.exists()) {
      throw const ContentPackValidationException(
        'Downloaded pack file does not exist.',
      );
    }

    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString().toLowerCase();
  }

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

  /// Reads and validates the ZIP once.
  ///
  /// The returned archive can be passed directly to the installer so the
  /// archive does not need to be decoded a second time.
  Future<ContentPackValidationResult> validateArchiveForInstallation({
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

    final manifestEntry = _findRootManifest(archive);

    if (manifestEntry == null) {
      throw const ContentPackValidationException(
        'The content pack must contain manifest.json at its root.',
      );
    }

    final manifestBytes = manifestEntry.content;

    late Map<String, dynamic> json;

    try {
      final decoded = jsonDecode(
        utf8.decode(manifestBytes),
      );

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

    return ContentPackValidationResult(
      archive: archive,
      manifest: manifest,
    );
  }

  Future<ContentPackManifest> validateArchive({
    required File archiveFile,
    required ContentPack expectedPack,
  }) async {
    final result = await validateArchiveForInstallation(
      archiveFile: archiveFile,
      expectedPack: expectedPack,
    );

    return result.manifest;
  }

  void verifyManifestContentChecksumForArchive({
    required Archive archive,
    required ContentPackManifest manifest,
  }) {
    final expected = manifest.checksum.trim().toLowerCase();

    if (!_isSha256(expected)) {
      throw const ContentPackValidationException(
        'The manifest content checksum is invalid.',
      );
    }

    final actual = calculateArchiveContentChecksum(archive);

    if (actual != expected) {
      throw ContentPackChecksumException(
        expected: expected,
        actual: actual,
        source: 'manifest content',
      );
    }
  }

  Future<void> verifyManifestContentChecksum({
    required File archiveFile,
    required ContentPackManifest manifest,
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

    verifyManifestContentChecksumForArchive(
      archive: archive,
      manifest: manifest,
    );
  }

  String calculateArchiveContentChecksum(Archive archive) {
    return _archiveValidator.calculateArchiveContentChecksum(archive);
  }

  ArchiveFile? _findRootManifest(Archive archive) {
    for (final entry in archive) {
      if (!entry.isFile) {
        continue;
      }

      if (_normalizePath(entry.name) == 'manifest.json') {
        return entry;
      }
    }

    return null;
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
      throw const ContentPackValidationException(
        'Manifest lesson count does not match the catalog.',
      );
    }

    if (manifest.language != expectedPack.language) {
      throw const ContentPackValidationException(
        'Manifest language does not match the catalog.',
      );
    }

    if (!manifest.isActive) {
      throw const ContentPackValidationException(
        'The content pack is not active.',
      );
    }
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

    if (!files.contains('manifest.json')) {
      throw const ContentPackValidationException(
        'The content pack is missing root manifest.json.',
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
    return _normalizePath(path) == 'manifest.json';
  }

  static String _normalizePath(String path) {
    var normalized = path.replaceAll('\\', '/');

    normalized = normalized.replaceFirst(
      RegExp(r'^/+'),
      '',
    );

    while (normalized.contains('//')) {
      normalized = normalized.replaceAll('//', '/');
    }

    return normalized;
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

class ContentPackValidationResult {
  const ContentPackValidationResult({
    required this.archive,
    required this.manifest,
  });

  final Archive archive;
  final ContentPackManifest manifest;
}

class _ContentEntry {
  const _ContentEntry({
    required this.path,
    required this.bytes,
  });

  final String path;
  final Uint8List bytes;
}

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


