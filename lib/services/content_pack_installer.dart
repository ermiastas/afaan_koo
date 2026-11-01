import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/content_pack.dart';
import '../models/content_pack_manifest.dart';
import 'content_pack_validator.dart';

class ContentPackInstaller {
  ContentPackInstaller({
    ContentPackValidator? validator,
    Future<Directory> Function()? rootDirectoryProvider,
  })  : _validator = validator ?? const ContentPackValidator(),
        _rootDirectoryProvider =
            rootDirectoryProvider ?? getApplicationSupportDirectory;

  final ContentPackValidator _validator;
  final Future<Directory> Function() _rootDirectoryProvider;

  static const String _packsDirectoryName = 'content_packs';
  static const String _installedDirectoryName = 'installed';
  static const String _temporaryDirectoryName = 'temporary';

  Future<Directory> getRootDirectory() async {
    final applicationDirectory = await _rootDirectoryProvider();

    final directory = Directory(
      _join(applicationDirectory.path, _packsDirectoryName),
    );

    await directory.create(recursive: true);

    return directory;
  }

  Future<Directory> getInstalledRootDirectory() async {
    final root = await getRootDirectory();

    final directory = Directory(
      _join(root.path, _installedDirectoryName),
    );

    await directory.create(recursive: true);

    return directory;
  }

  Future<Directory> getTemporaryRootDirectory() async {
    final root = await getRootDirectory();

    final directory = Directory(
      _join(root.path, _temporaryDirectoryName),
    );

    await directory.create(recursive: true);

    return directory;
  }

  Future<Directory> getInstallationDirectory({
    required String packId,
    required int version,
  }) async {
    _validatePackId(packId);
    _validateVersion(version);

    final root = await getInstalledRootDirectory();

    return Directory(
      _join(
        root.path,
        '${_safeName(packId)}_v$version',
      ),
    );
  }

  Future<String> install({
    required File archiveFile,
    required ContentPack pack,
  }) async {
    _validatePack(pack);

    if (!await archiveFile.exists()) {
      throw const ContentPackInstallationException(
        'The downloaded content-pack file does not exist.',
      );
    }

    final validation =
        await _validator.validateArchiveForInstallation(
      archiveFile: archiveFile,
      expectedPack: pack,
    );

    final manifest = validation.manifest;

    _validator.verifyManifestContentChecksumForArchive(
      archive: validation.archive,
      manifest: manifest,
    );

    final temporaryRoot = await getTemporaryRootDirectory();

    final installationId =
        '${_safeName(pack.id)}_v${pack.version}_${DateTime.now().microsecondsSinceEpoch}';

    final temporaryDirectory = Directory(
      _join(
        temporaryRoot.path,
        '$installationId.installing',
      ),
    );

    final finalDirectory = await getInstallationDirectory(
      packId: pack.id,
      version: pack.version,
    );

    try {
      await temporaryDirectory.create(recursive: true);

      await _extractArchive(
        archive: validation.archive,
        destination: temporaryDirectory,
      );

      await _verifyExtractedInstallation(
        directory: temporaryDirectory,
        pack: pack,
        manifest: manifest,
      );

      await _writeInstallationMarker(
        directory: temporaryDirectory,
        pack: pack,
        manifest: manifest,
      );

      await _activate(
        temporaryDirectory: temporaryDirectory,
        finalDirectory: finalDirectory,
      );

      return finalDirectory.path;
    } catch (error) {
      await _deleteDirectoryIfExists(temporaryDirectory);

      if (error is ContentPackInstallationException) {
        rethrow;
      }

      throw ContentPackInstallationException(
        'Content-pack installation failed.',
        error,
      );
    }
  }

  Future<void> removeInstalledVersion({
    required String packId,
    required int version,
  }) async {
    final directory = await getInstallationDirectory(
      packId: packId,
      version: version,
    );

    await _deleteDirectoryIfExists(directory);
  }

  Future<void> cleanupTemporaryFiles() async {
    final root = await getTemporaryRootDirectory();

    if (!await root.exists()) {
      return;
    }

    await for (final entity in root.list()) {
      try {
        if (entity is Directory) {
          await entity.delete(recursive: true);
        } else if (entity is File) {
          await entity.delete();
        }
      } catch (_) {
        // Best-effort cleanup.
      }
    }
  }

  Future<void> _extractArchive({
    required Archive archive,
    required Directory destination,
  }) async {
    for (final entry in archive) {
      final normalizedPath =
          _normalizeArchivePath(entry.name);

      if (normalizedPath.isEmpty) {
        continue;
      }

      _validateArchivePath(normalizedPath);

      final targetPath = _join(
        destination.path,
        normalizedPath,
      );

      if (entry.isFile) {
        final target = File(targetPath);

        await target.parent.create(
          recursive: true,
        );

        await target.writeAsBytes(
          entry.content,
          flush: true,
        );
      } else {
        await Directory(targetPath).create(
          recursive: true,
        );
      }
    }
  }

  Future<void> _verifyExtractedInstallation({
    required Directory directory,
    required ContentPack pack,
    required ContentPackManifest manifest,
  }) async {
    final manifestFile = File(
      _join(directory.path, 'manifest.json'),
    );

    if (!await manifestFile.exists()) {
      throw const ContentPackInstallationException(
        'Installed pack is missing manifest.json.',
      );
    }

    final extractedManifest = await _readManifest(
      manifestFile,
    );

    if (extractedManifest.id != pack.id) {
      throw const ContentPackInstallationException(
        'Installed manifest has an unexpected pack ID.',
      );
    }

    if (extractedManifest.version != pack.version) {
      throw const ContentPackInstallationException(
        'Installed manifest has an unexpected version.',
      );
    }

    if (extractedManifest.checksum != manifest.checksum) {
      throw const ContentPackInstallationException(
        'Installed manifest checksum changed during extraction.',
      );
    }

    final lessonDirectory = Directory(
      _join(directory.path, 'lessons'),
    );

    final lessonsFile = File(
      _join(directory.path, 'lessons.json'),
    );

    if (!await lessonDirectory.exists() &&
        !await lessonsFile.exists()) {
      throw const ContentPackInstallationException(
        'Installed pack does not contain lesson content.',
      );
    }
  }

  Future<ContentPackManifest> _readManifest(
    File file,
  ) async {
    try {
      final content = await file.readAsString();
      final decoded = jsonDecode(content);

      if (decoded is! Map) {
        throw const FormatException(
          'Manifest root must be an object.',
        );
      }

      return ContentPackManifest.fromJson(
        Map<String, dynamic>.from(decoded),
      );
    } catch (error) {
      throw ContentPackInstallationException(
        'The installed manifest cannot be read.',
        error,
      );
    }
  }

  Future<void> _writeInstallationMarker({
    required Directory directory,
    required ContentPack pack,
    required ContentPackManifest manifest,
  }) async {
    final marker = File(
      _join(directory.path, '.installed'),
    );

    final content = [
      'pack_id=${pack.id}',
      'version=${pack.version}',
      'manifest_checksum=${manifest.checksum}',
      'installed_at=${DateTime.now().toUtc().toIso8601String()}',
    ].join('\n');

    await marker.writeAsString(
      content,
      flush: true,
    );
  }

  Future<void> _activate({
    required Directory temporaryDirectory,
    required Directory finalDirectory,
  }) async {
    await finalDirectory.parent.create(
      recursive: true,
    );

    if (await finalDirectory.exists()) {
      throw const ContentPackInstallationException(
        'The target installation directory already exists.',
      );
    }

    try {
      await temporaryDirectory.rename(
        finalDirectory.path,
      );
    } on FileSystemException catch (error) {
      throw ContentPackInstallationException(
        'Could not activate the installed content pack.',
        error,
      );
    }
  }

  void _validatePack(ContentPack pack) {
    _validatePackId(pack.id);

    if (pack.version < 1) {
      throw ArgumentError.value(
        pack.version,
        'pack.version',
        'Version must be positive.',
      );
    }

    if (!pack.isActive) {
      throw ArgumentError.value(
        pack.isActive,
        'pack.isActive',
        'Pack must be active.',
      );
    }
  }

  void _validatePackId(String packId) {
    if (packId.trim().isEmpty) {
      throw ArgumentError.value(
        packId,
        'packId',
        'Pack ID must not be empty.',
      );
    }

    if (!_isSafePathComponent(packId)) {
      throw ArgumentError.value(
        packId,
        'packId',
        'Pack ID contains unsafe path characters.',
      );
    }
  }

  void _validateVersion(int version) {
    if (version < 1) {
      throw ArgumentError.value(
        version,
        'version',
        'Version must be positive.',
      );
    }
  }

  bool _isSafePathComponent(String value) {
    return RegExp(
      r'^[a-zA-Z0-9._-]+$',
    ).hasMatch(value);
  }

  String _safeName(String value) {
    return value.replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );
  }

  String _normalizeArchivePath(String path) {
    var normalized = path.replaceAll('\\', '/');

    normalized = normalized.replaceFirst(
      RegExp(r'^/+'),
      '',
    );

    while (normalized.contains('//')) {
      normalized = normalized.replaceAll('//', '/');
    }

    if (normalized.endsWith('/')) {
      normalized = normalized.substring(
        0,
        normalized.length - 1,
      );
    }

    return normalized;
  }

  void _validateArchivePath(String path) {
    if (path.startsWith('/') ||
        path.startsWith('\\') ||
        path.contains(':')) {
      throw ContentPackInstallationException(
        'Unsafe archive path detected: $path',
      );
    }

    for (final part in path.split('/')) {
      if (part == '..') {
        throw ContentPackInstallationException(
          'Unsafe archive path detected: $path',
        );
      }
    }
  }

  String _join(String first, String second) {
    final separator = Platform.pathSeparator;

    if (first.endsWith(separator)) {
      return '$first$second';
    }

    return '$first$separator$second';
  }

  Future<void> _deleteDirectoryIfExists(
    Directory directory,
  ) async {
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }
}

class ContentPackInstallationException implements Exception {
  const ContentPackInstallationException(
    this.message, [
    this.cause,
  ]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    return 'ContentPackInstallationException: $message';
  }
}
