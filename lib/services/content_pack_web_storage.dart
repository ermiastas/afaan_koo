
import 'package:flutter/foundation.dart';
import 'package:idb_shim/idb_browser.dart';

/// Persistent browser storage for downloaded AfaanKoo lesson-pack files.
///
/// This service is intended for Flutter Web. It uses real browser IndexedDB,
/// not in-memory storage or SharedPreferences.
class ContentPackWebStorage {
  ContentPackWebStorage({IdbFactory? factory})
      : _factory = factory ?? idbFactoryBrowser;

  static const String _databaseName = 'afaankoo_content_packs';
  static const int _databaseVersion = 1;
  static const String _fileStore = 'pack_files';

  final IdbFactory _factory;

  Future<Database> _openDatabase() {
    return _factory.open(
      _databaseName,
      version: _databaseVersion,
      onUpgradeNeeded: (event) {
        final database = event.database;

        if (!database.objectStoreNames.contains(_fileStore)) {
          database.createObjectStore(_fileStore);
        }
      },
    );
  }

  String _makeKey({
    required String packId,
    required String version,
    required String relativePath,
  }) {
    _validateSegment(packId, 'packId');
    _validateSegment(version, 'version');

    final normalizedPath = _normalizeRelativePath(relativePath);

    return '$packId::$version::$normalizedPath';
  }

  void _validateSegment(String value, String name) {
    if (value.trim().isEmpty ||
        value.contains('..') ||
        value.contains('/') ||
        value.contains(r'\')) {
      throw ArgumentError.value(value, name, 'Invalid value.');
    }
  }

  String _normalizeRelativePath(String path) {
    final normalized = path.replaceAll(r'\', '/').trim();

    if (normalized.isEmpty ||
        normalized.startsWith('/') ||
        normalized.contains(':') ||
        normalized.split('/').any(
          (part) => part.isEmpty || part == '.' || part == '..',
        )) {
      throw ArgumentError.value(
        path,
        'relativePath',
        'Expected a safe relative file path.',
      );
    }

    return normalized;
  }

  /// Stores a file's bytes for one pack version.
  ///
  /// Repeated writes to the same pack/version/path replace the existing file.
  Future<void> writeFile({
    required String packId,
    required String version,
    required String relativePath,
    required List<int> bytes,
    String? contentType,
  }) async {
    _ensureWeb();

    final key = _makeKey(
      packId: packId,
      version: version,
      relativePath: relativePath,
    );

    final database = await _openDatabase();

    try {
      final transaction = database.transaction(
        _fileStore,
        idbModeReadWrite,
      );

      await transaction.objectStore(_fileStore).put(
        <String, Object?>{
          'packId': packId,
          'version': version,
          'path': _normalizeRelativePath(relativePath),
          'bytes': Uint8List.fromList(bytes),
          'contentType': contentType,
        },
        key,
      );

      await transaction.completed;
    } finally {
      database.close();
    }
  }

  /// Returns the stored bytes, or null if the file is not installed.
  Future<Uint8List?> readFile({
    required String packId,
    required String version,
    required String relativePath,
  }) async {
    _ensureWeb();

    final key = _makeKey(
      packId: packId,
      version: version,
      relativePath: relativePath,
    );

    final database = await _openDatabase();

    try {
      final transaction = database.transaction(
        _fileStore,
        idbModeReadOnly,
      );

      final record = await transaction
          .objectStore(_fileStore)
          .getObject(key);

      await transaction.completed;

      if (record == null) {
        return null;
      }

      if (record is! Map) {
        throw const ContentPackWebStorageException(
          'Stored content-pack record has an invalid format.',
        );
      }

      final storedBytes = record['bytes'];

      if (storedBytes is Uint8List) {
        return Uint8List.fromList(storedBytes);
      }

      if (storedBytes is List) {
        return Uint8List.fromList(
          storedBytes.map((value) {
            if (value is! int || value < 0 || value > 255) {
              throw const ContentPackWebStorageException(
                'Stored file contains invalid byte data.',
              );
            }
            return value;
          }).toList(),
        );
      }

      throw const ContentPackWebStorageException(
        'Stored file bytes are missing or invalid.',
      );
    } finally {
      database.close();
    }
  }

  /// Deletes a single file from a pack version.
  Future<void> deleteFile({
    required String packId,
    required String version,
    required String relativePath,
  }) async {
    _ensureWeb();

    final key = _makeKey(
      packId: packId,
      version: version,
      relativePath: relativePath,
    );

    final database = await _openDatabase();

    try {
      final transaction = database.transaction(
        _fileStore,
        idbModeReadWrite,
      );

      await transaction.objectStore(_fileStore).delete(key);
      await transaction.completed;
    } finally {
      database.close();
    }
  }

  /// Deletes all files belonging to a pack version.
  ///
  /// Keys are checked before deletion so another pack/version is untouched.
  Future<void> deletePackVersion({
    required String packId,
    required String version,
  }) async {
    _ensureWeb();
    _validateSegment(packId, 'packId');
    _validateSegment(version, 'version');

    final prefix = '$packId::$version::';
    final database = await _openDatabase();

    try {
      final transaction = database.transaction(
        _fileStore,
        idbModeReadWrite,
      );

      final store = transaction.objectStore(_fileStore);
      final keys = await store.getAllKeys();

      for (final key in keys) {
        if (key is String && key.startsWith(prefix)) {
          await store.delete(key);
        }
      }

      await transaction.completed;
    } finally {
      database.close();
    }
  }

  void _ensureWeb() {
    if (!kIsWeb) {
      throw UnsupportedError(
        'ContentPackWebStorage is only available on Flutter Web.',
      );
    }
  }
}

class ContentPackWebStorageException implements Exception {
  const ContentPackWebStorageException(this.message);

  final String message;

  @override
  String toString() => 'ContentPackWebStorageException: $message';
}
