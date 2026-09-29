import '../models/content_pack.dart';
import '../models/content_pack_installation.dart';
import 'content_pack_registry.dart';

/// Coordinates the local lifecycle of downloadable lesson-content packs.
///
/// Catalog discovery, network transfer, archive verification, and content-file
/// installation are intentionally added in later phases. This class owns only
/// the safe registry transitions those operations will use.
class ContentPackManager {
  ContentPackManager({ContentPackRegistry? registry})
    : _registry = registry ?? ContentPackRegistry();

  final ContentPackRegistry _registry;
  Future<void>? _initialization;

  Future<void> initialize() {
    return _initialization ??= _registry.load();
  }

  Future<bool> isInstalled(String packId) async {
    await initialize();
    return _registry.isInstalled(packId);
  }

  Future<ContentPackInstallationStatus> getStatus(String packId) async {
    await initialize();
    return _registry.getStatus(packId);
  }

  Future<int?> getInstalledVersion(String packId) async {
    await initialize();
    return _registry.getInstalledVersion(packId);
  }

  Future<ContentPackInstallation?> getInstallation(String packId) async {
    await initialize();
    return _registry.getInstallation(packId);
  }

  Future<List<ContentPackInstallation>> getInstalledPacks() async {
    await initialize();
    return _registry.installations.values
        .where((installation) => installation.isUsable)
        .toList(growable: false);
  }

  /// Begins a first-time local installation.
  ///
  /// Updating a usable pack is intentionally deferred until the downloader can
  /// stage a replacement without making the current version unavailable.
  Future<void> beginInstallation(ContentPack pack) async {
    await initialize();
    _validateInstallablePack(pack);

    final existing = _registry.getInstallation(pack.id);
    if (existing?.isUsable ?? false) {
      throw StateError(
        'A usable content pack cannot be replaced outside an atomic update.',
      );
    }

    await _registry.recordStatus(
      packId: pack.id,
      version: pack.version,
      status: ContentPackInstallationStatus.installing,
      sizeBytes: pack.sizeBytes,
      checksum: pack.checksum,
    );
  }

  /// Records a completed local installation after a future downloader has
  /// verified the archive and installed its files atomically.
  Future<void> completeInstallation({
    required ContentPack pack,
    required String verifiedChecksum,
    required String localPath,
    DateTime? installedAt,
  }) async {
    await initialize();
    _validateInstallablePack(pack);
    _validateRequiredValue(verifiedChecksum, 'verifiedChecksum');
    _validateRequiredValue(localPath, 'localPath');

    if (_registry.getStatus(pack.id) !=
        ContentPackInstallationStatus.installing) {
      throw StateError('The content pack is not awaiting installation.');
    }

    await _registry.markInstalled(
      packId: pack.id,
      version: pack.version,
      sizeBytes: pack.sizeBytes,
      checksum: verifiedChecksum,
      localPath: localPath,
      installedAt: installedAt,
    );
  }

  /// Records a failed first-time installation without marking the pack usable.
  Future<void> failInstallation(ContentPack pack) async {
    await initialize();
    _validateInstallablePack(pack);

    if (_registry.getStatus(pack.id) !=
        ContentPackInstallationStatus.installing) {
      throw StateError('The content pack is not being installed.');
    }

    await _registry.recordStatus(
      packId: pack.id,
      version: pack.version,
      status: ContentPackInstallationStatus.failed,
      sizeBytes: pack.sizeBytes,
      checksum: pack.checksum,
    );
  }

  /// Marks an existing installation as having a newer catalog version.
  ///
  /// The installed record keeps its current version and remains usable.
  Future<void> markUpdateAvailable(ContentPack availablePack) async {
    await initialize();
    _validateInstallablePack(availablePack);

    final existing = _registry.getInstallation(availablePack.id);
    if (existing == null ||
        !existing.isUsable ||
        availablePack.version <= existing.version) {
      return;
    }

    await _registry.recordStatus(
      packId: existing.packId,
      version: existing.version,
      status: ContentPackInstallationStatus.updateAvailable,
    );
  }

  /// Removes only the local installation record in this phase.
  ///
  /// Content-file deletion will be added together with atomic file management.
  /// Lesson progress is never stored in, or removed with, this registry record.
  Future<void> removePack(String packId) async {
    await initialize();
    await _registry.remove(packId);
  }

  void _validateInstallablePack(ContentPack pack) {
    _validateRequiredValue(pack.id, 'pack.id');
    if (!pack.isActive) {
      throw ArgumentError.value(pack.isActive, 'pack.isActive', 'Must be true.');
    }
    if (pack.version < 1) {
      throw ArgumentError.value(pack.version, 'pack.version', 'Must be positive.');
    }
    if (pack.sizeBytes < 0) {
      throw ArgumentError.value(
        pack.sizeBytes,
        'pack.sizeBytes',
        'Must not be negative.',
      );
    }
  }

  void _validateRequiredValue(String value, String name) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, name, 'Must not be empty.');
    }
  }
}
