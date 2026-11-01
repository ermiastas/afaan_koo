
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

import '../models/content_pack.dart';
import '../models/content_pack_manifest.dart';

/// ZIP archive validation that does not depend on dart:io.
///
/// This class can be used by both Flutter Web and native platforms.
class ContentPackArchiveValidator {
  const ContentPackArchiveValidator();

  /// Decodes and validates an archive supplied as bytes.
  ContentPackValidationResult validateArchiveBytes({
    required List<int> bytes,
    required ContentPack expectedPack,
  }) {
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

    late Map<String, dynamic> json;

    try {
      final decoded = jsonDecode(utf8.decode(manifestEntry.content));

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

  /// Computes SHA-256 for an entire downloaded ZIP file.
  String calculateBytesSha256(List<int> bytes) {
    return sha256.convert(bytes).toString().toLowerCase();
  }

  /// Verifies the logical content checksum declared in manifest.json.
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

  /// Calculates a deterministic checksum of all files except root manifest.
  String calculateArchiveContentChecksum(Archive archive) {
    final entries = archive
        .where((entry) => entry.isFile)
        .where((entry) => !_isManifestPath(entry.name))
        .map(
          (entry) => _ContentEntry(
            path: _normalizePath(entry.name),
            bytes: entry.content,
          ),
        )
        .toList();

    entries.sort((a, b) => a.path.compareTo(b.path));

    final accumulator = BytesBuilder(copy: false);

    for (final entry in entries) {
      final pathBytes = utf8.encode(entry.path);

      accumulator.add(_int64Bytes(pathBytes.length));
      accumulator.add(pathBytes);

      accumulator.add(_int64Bytes(entry.bytes.length));
      accumulator.add(entry.bytes);
    }

    return sha256
        .convert(accumulator.takeBytes())
        .toString()
        .toLowerCase();
  }

  ArchiveFile? _findRootManifest(Archive archive) {
    for (final entry in archive) {
      if (entry.isFile &&
          _normalizePath(entry.name) == 'manifest.json') {
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
      if (entry.isFile) {
        files.add(_normalizePath(entry.name));
      }
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
    var remaining = BigInt.from(value) &
        ((BigInt.one << 64) - BigInt.one);

    final bytes = Uint8List(8);

    for (var i = 7; i >= 0; i--) {
      bytes[i] = (remaining & BigInt.from(0xff)).toInt();
      remaining = remaining >> 8;
    }

    return bytes;
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
  String toString() => 'ContentPackValidationException: $message';
}

class ContentPackChecksumException
    extends ContentPackValidationException {
  ContentPackChecksumException({
    required this.expected,
    required this.actual,
    required this.source,
  }) : super('Content-pack checksum verification failed.');

  final String expected;
  final String actual;
  final String source;
}
