import '../models/content_pack.dart';
import '../models/content_pack_installation.dart';
import 'content_pack_storage.dart';

/// In-memory view of locally recorded content-pack installations.
///
/// This registry neither downloads content nor deletes content files. A future
/// manager will own those operations; removing a registry entry cannot remove
/// lesson progress because progress is stored independently.
class ContentPackRegistry {
  ContentPackRegistry({ContentPackStorage? storage})
    : _storage = storage ?? ContentPackStorage();

  final ContentPackStorage _storage;
  Map<String, ContentPackInstallation> _installations = {};
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Map<String, ContentPackInstallation> get installations =>
      Map.unmodifiable(_installations);

  Future<void> load() async {
    _installations = await _storage.read();
    _isLoaded = true;
  }

  bool isInstalled(String packId) {
    return _installations[packId]?.isUsable ?? false;
  }

  ContentPackInstallationStatus getStatus(String packId) {
    return _installations[packId]?.status ??
        ContentPackInstallationStatus.notInstalled;
  }

  int? getInstalledVersion(String packId) {
    final installation = _installations[packId];
    if (installation == null || !installation.isUsable) {
      return null;
    }
    return installation.version;
  }

  ContentPackInstallation? getInstallation(String packId) {
    return _installations[packId];
  }

  Future<void> markInstalled({
    required String packId,
    required int version,
    required int sizeBytes,
    required String checksum,
    required String localPath,
    DateTime? installedAt,
  }) {
    return recordStatus(
      packId: packId,
      version: version,
      status: ContentPackInstallationStatus.installed,
      sizeBytes: sizeBytes,
      checksum: checksum,
      localPath: localPath,
      installedAt: installedAt,
    );
  }

  Future<void> recordStatus({
    required String packId,
    required int version,
    required ContentPackInstallationStatus status,
    int? sizeBytes,
    String? checksum,
    String? localPath,
    DateTime? installedAt,
  }) async {
    await _ensureLoaded();
    _validatePackId(packId);
    if (version < 1) {
      throw ArgumentError.value(version, 'version', 'Must be positive.');
    }

    if (status == ContentPackInstallationStatus.notInstalled) {
      await remove(packId);
      return;
    }

    final existing = _installations[packId];
    final installation = ContentPackInstallation(
      packId: packId,
      version: version,
      status: status,
      installedAt: status == ContentPackInstallationStatus.installed
          ? (installedAt ?? existing?.installedAt ?? DateTime.now().toUtc())
          : existing?.installedAt,
      sizeBytes: sizeBytes ?? existing?.sizeBytes,
      checksum: checksum ?? existing?.checksum,
      localPath: localPath ?? existing?.localPath,
    );

    _installations[packId] = installation;
    await _persist();
  }

  Future<void> remove(String packId) async {
    await _ensureLoaded();
    _validatePackId(packId);
    if (_installations.remove(packId) != null) {
      await _persist();
    }
  }

  Future<void> _persist() {
    if (_installations.isEmpty) {
      return _storage.clear();
    }
    return _storage.write(_installations);
  }

  Future<void> _ensureLoaded() {
    return _isLoaded ? Future.value() : load();
  }

  void _validatePackId(String packId) {
    if (packId.trim().isEmpty) {
      throw ArgumentError.value(packId, 'packId', 'Must not be empty.');
    }
  }
}
