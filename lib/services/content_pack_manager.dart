import 'dart:io';

import '../models/content_pack.dart';
import '../models/content_pack_installation.dart';
import 'content_pack_downloader.dart';
import 'content_pack_installer.dart';
import 'content_pack_registry.dart';
import 'content_pack_validator.dart';

/// Coordinates downloading, validating, installing and activating
/// downloadable lesson-content packs.
///
/// The currently active installation is never replaced until the new
/// installation has completed successfully.
///
/// Lesson progress and rewards are completely independent of this service.
class ContentPackManager {
  ContentPackManager({
    ContentPackRegistry? registry,
    ContentPackDownloader? downloader,
    ContentPackValidator? validator,
    ContentPackInstaller? installer,
    Future<void> Function()? initializationCleanup,
  })  : _registry = registry ?? ContentPackRegistry(),
        _downloader = downloader ?? ContentPackDownloader(),
        _validator = validator ?? const ContentPackValidator(),
        _installer = installer ?? ContentPackInstaller(),
        _initializationCleanup =
            initializationCleanup ?? _defaultInitializationCleanup;

  final ContentPackRegistry _registry;
  final ContentPackDownloader _downloader;
  final ContentPackValidator _validator;
  final ContentPackInstaller _installer;
  final Future<void> Function() _initializationCleanup;

  Future<void>? _initialization;

  bool get isDownloading => _downloader.isDownloading;

  Future<void> initialize() {
    return _initialization ??= _initialize();
  }

  Future<void> _initialize() async {
    await _registry.load();
    await _initializationCleanup();
  }

  static Future<void> _defaultInitializationCleanup() async {
    final installer = ContentPackInstaller();
    await installer.cleanupTemporaryFiles();
  }

  Future<bool> isInstalled(String packId) async {
    await initialize();
    return _registry.isInstalled(packId);
  }

  Future<ContentPackInstallationStatus> getStatus(
    String packId,
  ) async {
    await initialize();
    return _registry.getStatus(packId);
  }

  Future<int?> getInstalledVersion(
    String packId,
  ) async {
    await initialize();
    return _registry.getInstalledVersion(packId);
  }

  Future<ContentPackInstallation?> getInstallation(
    String packId,
  ) async {
    await initialize();
    return _registry.getInstallation(packId);
  }

  Future<List<ContentPackInstallation>> getInstalledPacks() async {
    await initialize();

    return _registry.installations.values
        .where(
          (installation) => installation.isUsable,
        )
        .toList(growable: false);
  }

  /// Downloads and installs a pack that is not currently installed.
  Future<ContentPackInstallation> downloadAndInstall({
    required ContentPack pack,
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) async {
    return _downloadAndInstall(
      pack: pack,
      onProgress: onProgress,
      allowUpdate: false,
    );
  }

  /// Downloads and safely installs a newer version.
  ///
  /// The existing active version remains registered and usable until the new
  /// version has been fully downloaded, validated and installed.
  Future<ContentPackInstallation> updatePack({
    required ContentPack pack,
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) async {
    return _downloadAndInstall(
      pack: pack,
      onProgress: onProgress,
      allowUpdate: true,
    );
  }

  Future<ContentPackInstallation> _downloadAndInstall({
    required ContentPack pack,
    required void Function(ContentPackDownloadProgress progress)? onProgress,
    required bool allowUpdate,
  }) async {
    await initialize();

    _validateInstallablePack(pack);

    final url = pack.downloadUrl?.trim();

    if (url == null || url.isEmpty) {
      throw const ContentPackPipelineException(
        'This content pack does not have a download URL.',
      );
    }

    final checksum = pack.checksum?.trim();

    if (checksum == null || checksum.isEmpty) {
      throw const ContentPackPipelineException(
        'This content pack does not have a checksum.',
      );
    }

    final existing = _registry.getInstallation(pack.id);

    if (existing != null && existing.isUsable) {
      if (!allowUpdate) {
        throw ContentPackPipelineException(
          'Content pack ${pack.id} is already installed '
          'at version ${existing.version}.',
        );
      }

      if (pack.version <= existing.version) {
        throw ContentPackPipelineException(
          'Content pack ${pack.id} version ${pack.version} is not newer '
          'than installed version ${existing.version}.',
        );
      }
    }

    final pending = _registry.getPendingInstallation(
      pack.id,
    );

    if (pending != null &&
        pending.version != pack.version) {
      throw const ContentPackPipelineException(
        'Another content-pack operation is already pending.',
      );
    }

    final temporaryRoot =
        await _installer.getTemporaryRootDirectory();

    final downloadPath = _join(
      temporaryRoot.path,
      '${_safeName(pack.id)}_v${pack.version}_'
      '${DateTime.now().microsecondsSinceEpoch}.zip',
    );

    File? downloadedFile;

    try {
      await _registry.recordPendingStatus(
        packId: pack.id,
        version: pack.version,
        status: ContentPackInstallationStatus.downloading,
        sizeBytes: pack.sizeBytes,
        checksum: checksum,
      );

      downloadedFile = await _downloader.download(
        url: url,
        destination: downloadPath,
        onProgress: onProgress,
      );

      await _validator.verifyChecksum(
        file: downloadedFile,
        expectedChecksum: checksum,
      );

      await _registry.recordPendingStatus(
        packId: pack.id,
        version: pack.version,
        status: ContentPackInstallationStatus.installing,
        sizeBytes: pack.sizeBytes,
        checksum: checksum,
      );

      final localPath = await _installer.install(
        archiveFile: downloadedFile,
        pack: pack,
      );

      // Only now does the new version become the active version.
      await _registry.markInstalled(
        packId: pack.id,
        version: pack.version,
        sizeBytes: pack.sizeBytes,
        checksum: checksum,
        localPath: localPath,
      );

      final installation = _registry.getInstallation(
        pack.id,
      );

      if (installation == null) {
        throw const ContentPackPipelineException(
          'Content pack was installed, but its registry entry could not be found.',
        );
      }

      return installation;
    } catch (error) {
      // The active installation is deliberately untouched.
      try {
        await _registry.clearPending(pack.id);
      } catch (_) {
        // Preserve the original error.
      }

      if (error is ContentPackPipelineException ||
          error is ContentPackDownloadException ||
          error is ContentPackDownloadCancelledException ||
          error is ContentPackValidationException ||
          error is ContentPackInstallationException) {
        rethrow;
      }

      throw ContentPackPipelineException(
        'Content-pack download and installation failed.',
        error,
      );
    } finally {
      if (downloadedFile != null) {
        await _deleteFileIfExists(downloadedFile);
      } else {
        await _deleteFileIfExists(
          File(downloadPath),
        );
      }
    }
  }

  /// Compatibility API for local/test-driven installation workflows.
  ///
  /// This records an installation as pending. It does not replace the
  /// currently active installation.
  Future<void> beginInstallation(
    ContentPack pack,
  ) async {
    await initialize();

    _validateInstallablePack(pack);

    await _registry.recordPendingStatus(
      packId: pack.id,
      version: pack.version,
      status: ContentPackInstallationStatus.installing,
      sizeBytes: pack.sizeBytes,
      checksum: pack.checksum,
    );
  }

  /// Compatibility API for completing a verified local installation.
  ///
  /// The installation becomes active only after all required metadata has
  /// been supplied. Existing lesson progress is never modified.
  Future<ContentPackInstallation> completeInstallation({
    required ContentPack pack,
    required String verifiedChecksum,
    required String localPath,
    DateTime? installedAt,
  }) async {
    await initialize();

    _validateInstallablePack(pack);

    if (verifiedChecksum.trim().isEmpty) {
      throw ArgumentError.value(
        verifiedChecksum,
        'verifiedChecksum',
        'Must not be empty.',
      );
    }

    if (localPath.trim().isEmpty) {
      throw ArgumentError.value(
        localPath,
        'localPath',
        'Must not be empty.',
      );
    }

    await _registry.markInstalled(
      packId: pack.id,
      version: pack.version,
      sizeBytes: pack.sizeBytes,
      checksum: verifiedChecksum,
      localPath: localPath,
      installedAt: installedAt,
    );

    final installation = _registry.getInstallation(
      pack.id,
    );

    if (installation == null) {
      throw const ContentPackPipelineException(
        'Installation was completed, but the registry entry could not be found.',
      );
    }

    return installation;
  }

  Future<void> cancelDownload() async {
    _downloader.cancel();
  }

  /// Removes the active installation.
  ///
  /// Lesson progress and rewards are never touched.
  Future<void> removePack(String packId) async {
    await initialize();

    final installation =
        _registry.getInstallation(packId);

    if (installation == null) {
      return;
    }

    final localPath = installation.localPath;

    if (localPath != null &&
        localPath.trim().isNotEmpty) {
      await _deleteDirectoryIfExists(
        Directory(localPath),
      );
    } else {
      await _installer.removeInstalledVersion(
        packId: packId,
        version: installation.version,
      );
    }

    await _registry.removeActiveOnly(packId);
  }

  Future<void> markUpdateAvailable(
    ContentPack availablePack,
  ) async {
    await initialize();

    _validateInstallablePack(
      availablePack,
    );

    final existing =
        _registry.getInstallation(
      availablePack.id,
    );

    if (existing == null ||
        !existing.isUsable ||
        availablePack.version <= existing.version) {
      return;
    }

    await _registry.updateActiveStatus(
      packId: existing.packId,
      status: ContentPackInstallationStatus.updateAvailable,
    );
  }

  void _validateInstallablePack(
    ContentPack pack,
  ) {
    if (pack.id.trim().isEmpty) {
      throw ArgumentError.value(
        pack.id,
        'pack.id',
        'Must not be empty.',
      );
    }

    if (!_isSafePathComponent(pack.id)) {
      throw ArgumentError.value(
        pack.id,
        'pack.id',
        'Contains unsafe path characters.',
      );
    }

    if (pack.version < 1) {
      throw ArgumentError.value(
        pack.version,
        'pack.version',
        'Must be positive.',
      );
    }

    if (pack.sizeBytes < 0) {
      throw ArgumentError.value(
        pack.sizeBytes,
        'pack.sizeBytes',
        'Must not be negative.',
      );
    }

    if (!pack.isActive) {
      throw ArgumentError.value(
        pack.isActive,
        'pack.isActive',
        'Must be true.',
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

  String _join(
    String first,
    String second,
  ) {
    final separator = Platform.pathSeparator;

    if (first.endsWith(separator)) {
      return '$first$second';
    }

    return '$first$separator$second';
  }

  Future<void> _deleteFileIfExists(
    File file,
  ) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Best-effort cleanup.
    }
  }

  Future<void> _deleteDirectoryIfExists(
    Directory directory,
  ) async {
    try {
      if (await directory.exists()) {
        await directory.delete(
          recursive: true,
        );
      }
    } catch (_) {
      // Best-effort cleanup.
    }
  }
}

class ContentPackPipelineException
    implements Exception {
  const ContentPackPipelineException(
    this.message, [
    this.cause,
  ]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    return 'ContentPackPipelineException: $message';
  }
}
