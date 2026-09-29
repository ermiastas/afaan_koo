import '../models/content_pack.dart';
import '../models/content_pack_installation.dart';
import 'content_pack_storage.dart';

/// Local registry for content-pack installations.
///
/// The registry represents the version currently available to the app.
/// A pending download/install operation is kept separately so an existing
/// working version is never replaced prematurely.
class ContentPackRegistry {
  ContentPackRegistry({
    ContentPackStorage? storage,
  }) : _storage = storage ?? ContentPackStorage();

  final ContentPackStorage _storage;

  Map<String, ContentPackInstallation> _installations = {};
  Map<String, ContentPackInstallation> _pending = {};

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Map<String, ContentPackInstallation> get installations =>
      Map.unmodifiable(_installations);

  Map<String, ContentPackInstallation> get pending =>
      Map.unmodifiable(_pending);

  Future<void> load() async {
    final state = await _storage.readState();

    _installations = Map<String, ContentPackInstallation>.from(state.installations);
    _pending = Map<String, ContentPackInstallation>.from(state.pending);
    _isLoaded = true;
  }

  bool isInstalled(String packId) {
    return _installations[packId]?.isUsable ?? false;
  }

  ContentPackInstallationStatus getStatus(String packId) {
    final active = _installations[packId];

    if (active != null) {
      return active.status;
    }

    return _pending[packId]?.status ??
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

  ContentPackInstallation? getPendingInstallation(
    String packId,
  ) {
    return _pending[packId];
  }

  Future<void> markInstalled({
    required String packId,
    required int version,
    required int sizeBytes,
    required String checksum,
    required String localPath,
    DateTime? installedAt,
  }) async {
    await _ensureLoaded();

    _validatePackId(packId);
    _validateVersion(version);

    _installations[packId] = ContentPackInstallation(
      packId: packId,
      version: version,
      status: ContentPackInstallationStatus.installed,
      installedAt: installedAt ??
          DateTime.now().toUtc(),
      sizeBytes: sizeBytes,
      checksum: checksum,
      localPath: localPath,
    );

    _pending.remove(packId);

    await _persist();
  }

  /// Records the status of a pending download or installation.
  ///
  /// This method preserves the original registry API while storing the
  /// operation separately from the currently active installation.
  Future<void> recordStatus({
    required String packId,
    required int version,
    required ContentPackInstallationStatus status,
    int? sizeBytes,
    String? checksum,
    String? localPath,
    DateTime? installedAt,
  }) async {
    if (status == ContentPackInstallationStatus.installed) {
      if (localPath == null || localPath.trim().isEmpty) {
        throw ArgumentError.value(
          localPath,
          'localPath',
          'An installed pack requires a local path.',
        );
      }

      if (sizeBytes == null || sizeBytes < 0) {
        throw ArgumentError.value(
          sizeBytes,
          'sizeBytes',
          'An installed pack requires a valid size.',
        );
      }

      if (checksum == null || checksum.trim().isEmpty) {
        throw ArgumentError.value(
          checksum,
          'checksum',
          'An installed pack requires a checksum.',
        );
      }

      await markInstalled(
        packId: packId,
        version: version,
        sizeBytes: sizeBytes,
        checksum: checksum,
        localPath: localPath,
        installedAt: installedAt,
      );

      return;
    }

    if (status == ContentPackInstallationStatus.notInstalled) {
      await clearPending(packId);
      return;
    }

    if (status == ContentPackInstallationStatus.updateAvailable) {
      await updateActiveStatus(
        packId: packId,
        status: status,
      );
      return;
    }
    await recordPendingStatus(
      packId: packId,
      version: version,
      status: status,
      sizeBytes: sizeBytes,
      checksum: checksum,
      localPath: localPath,
    );
  }

  Future<void> recordPendingStatus({
    required String packId,
    required int version,
    required ContentPackInstallationStatus status,
    int? sizeBytes,
    String? checksum,
    String? localPath,
  }) async {
    await _ensureLoaded();

    _validatePackId(packId);
    _validateVersion(version);

    final existing = _pending[packId];

    _pending[packId] = ContentPackInstallation(
      packId: packId,
      version: version,
      status: status,
      installedAt: existing?.installedAt,
      sizeBytes: sizeBytes ?? existing?.sizeBytes,
      checksum: checksum ?? existing?.checksum,
      localPath: localPath ?? existing?.localPath,
    );

    await _persist();
  }

  Future<void> updateActiveStatus({
    required String packId,
    required ContentPackInstallationStatus status,
  }) async {
    await _ensureLoaded();

    _validatePackId(packId);

    final existing = _installations[packId];

    if (existing == null) {
      return;
    }

    if (!existing.isUsable) {
      return;
    }

    _installations[packId] = ContentPackInstallation(
      packId: existing.packId,
      version: existing.version,
      status: status,
      installedAt: existing.installedAt,
      sizeBytes: existing.sizeBytes,
      checksum: existing.checksum,
      localPath: existing.localPath,
    );

    await _persist();
  }

  Future<void> clearPending(String packId) async {
    await _ensureLoaded();

    _validatePackId(packId);

    if (_pending.remove(packId) != null) {
      await _persist();
    }
  }

  Future<void> remove(String packId) async {
    await _ensureLoaded();

    _validatePackId(packId);

    var changed = false;

    if (_installations.remove(packId) != null) {
      changed = true;
    }

    if (_pending.remove(packId) != null) {
      changed = true;
    }

    if (changed) {
      await _persist();
    }
  }

  Future<void> removeActiveOnly(String packId) async {
    await _ensureLoaded();

    _validatePackId(packId);

    if (_installations.remove(packId) != null) {
      await _persist();
    }
  }

  Future<void> _persist() async {
    await _storage.writeState(
      ContentPackRegistryState(
        installations: _installations,
        pending: _pending,
      ),
    );
  }

  Future<void> _ensureLoaded() {
    return _isLoaded
        ? Future.value()
        : load();
  }

  void _validatePackId(String packId) {
    if (packId.trim().isEmpty) {
      throw ArgumentError.value(
        packId,
        'packId',
        'Must not be empty.',
      );
    }
  }

  void _validateVersion(int version) {
    if (version < 1) {
      throw ArgumentError.value(
        version,
        'version',
        'Must be positive.',
      );
    }
  }
}
