import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'content_pack_manager.dart';
import 'content_pack_web_storage.dart';

/// Reads JSON and media from installed content packs.
///
/// Web: browser IndexedDB.
/// Windows/Android: installed filesystem directory.
class ContentPackContentService {
  ContentPackContentService({
    required ContentPackManager contentPackManager,
    ContentPackWebStorage? webStorage,
  })  : _contentPackManager = contentPackManager,
        _webStorage = webStorage ?? ContentPackWebStorage();

  final ContentPackManager _contentPackManager;
  final ContentPackWebStorage _webStorage;

  Future<List<dynamic>?> readLessonList(
    String packId,
    String fileName,
  ) async {
    final normalized = _normalizeRelativePath('lessons/$fileName');

    if (normalized == null) {
      throw ArgumentError.value(fileName, 'fileName');
    }

    final bytes = await _readPackBytes(
      packId: packId,
      relativePath: normalized,
    );

    if (bytes == null) return null;

    try {
      final decoded = jsonDecode(utf8.decode(bytes));

      if (decoded is List) return decoded;

      throw const FormatException(
        'Lesson JSON must contain a JSON list.',
      );
    } on FormatException {
      rethrow;
    } catch (error) {
      throw ContentPackContentException(
        'Unable to read lesson JSON from pack "$packId".',
        error,
      );
    }
  }

  /// Reads media bytes on Web and native platforms.
  ///
  /// The path must begin with media/.
  Future<List<int>?> readMediaBytes(
    String packId,
    String relativeMediaPath,
  ) async {
    final normalized = _normalizeRelativePath(
      relativeMediaPath,
    );

    if (normalized == null || !normalized.startsWith('media/')) {
      throw ArgumentError.value(
        relativeMediaPath,
        'relativeMediaPath',
        'Media paths must begin with "media/".',
      );
    }

    return _readPackBytes(
      packId: packId,
      relativePath: normalized,
    );
  }

  /// Native filesystem API retained for existing callers and tests.
  ///
  /// On Web, use readMediaBytes instead.
  Future<File?> resolveMediaFile(
    String packId,
    String relativeMediaPath,
  ) async {
    if (kIsWeb) return null;

    final normalized = _normalizeRelativePath(
      relativeMediaPath,
    );

    if (normalized == null || !normalized.startsWith('media/')) {
      throw ArgumentError.value(
        relativeMediaPath,
        'relativeMediaPath',
        'Media paths must begin with "media/".',
      );
    }

    return _resolvePackFile(
      packId: packId,
      relativePath: normalized,
    );
  }

  Future<List<int>?> _readPackBytes({
    required String packId,
    required String relativePath,
  }) async {
    final installation =
        await _contentPackManager.getInstallation(packId);

    if (installation == null || !installation.isUsable) {
      return null;
    }

    final normalized = _normalizeRelativePath(relativePath);

    if (normalized == null) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'The relative path is unsafe.',
      );
    }

    if (kIsWeb) {
      return _webStorage.readFile(
        packId: packId,
        version: installation.version.toString(),
        relativePath: normalized,
      );
    }

    final localPath = installation.localPath?.trim();

    if (localPath == null || localPath.isEmpty) {
      return null;
    }

    final file = await _resolvePackFile(
      packId: packId,
      relativePath: normalized,
    );

    if (file == null) return null;

    return file.readAsBytes();
  }

  Future<File?> _resolvePackFile({
    required String packId,
    required String relativePath,
  }) async {
    if (kIsWeb) return null;

    final installation =
        await _contentPackManager.getInstallation(packId);

    if (installation == null || !installation.isUsable) {
      return null;
    }

    final localPath = installation.localPath?.trim();

    if (localPath == null || localPath.isEmpty) {
      return null;
    }

    final normalized = _normalizeRelativePath(relativePath);

    if (normalized == null) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'The relative path is unsafe.',
      );
    }

    final root = Directory(localPath).absolute;
    final target = File(
      _joinPath(root.path, normalized),
    ).absolute;

    if (!_isInsideDirectory(root.path, target.path)) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'The requested path escapes the installed pack.',
      );
    }

    if (!await target.exists()) return null;

    return target;
  }

  String? _normalizeRelativePath(String input) {
    if (input.trim().isEmpty) return null;

    final value = input.replaceAll(r'\', '/');

    if (value.startsWith('/') ||
        value.startsWith('//') ||
        RegExp(r'^[a-zA-Z]:').hasMatch(value)) {
      return null;
    }

    final segments = value.split('/');

    if (segments.any(
      (segment) =>
          segment.isEmpty ||
          segment == '.' ||
          segment == '..' ||
          segment.contains(':'),
    )) {
      return null;
    }

    return segments.join('/');
  }

  String _joinPath(String root, String relativePath) {
    final separator = Platform.pathSeparator;
    final relative = relativePath.replaceAll('/', separator);

    return root.endsWith(separator)
        ? '$root$relative'
        : '$root$separator$relative';
  }

  bool _isInsideDirectory(String rootPath, String targetPath) {
    final separator = Platform.pathSeparator;
    final root = _normalizeAbsolutePath(rootPath);
    final target = _normalizeAbsolutePath(targetPath);

    return target.startsWith(
      root.endsWith(separator) ? root : '$root$separator',
    );
  }

  String _normalizeAbsolutePath(String value) {
    var result = value.replaceAll(
      '/',
      Platform.pathSeparator,
    );

    if (Platform.isWindows) result = result.toLowerCase();

    while (result.length > 1 &&
        result.endsWith(Platform.pathSeparator)) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }
}

class ContentPackContentException implements Exception {
  const ContentPackContentException(
    this.message, [
    this.cause,
  ]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'ContentPackContentException: $message';
}