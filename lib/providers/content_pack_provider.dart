import 'package:flutter/foundation.dart';

import '../models/content_pack.dart';
import '../services/content_pack_catalog_service.dart';
import '../services/content_pack_downloader.dart';
import '../services/content_pack_manager.dart';

class ContentPackProvider extends ChangeNotifier {
  ContentPackProvider({
    ContentPackManager? manager,
    ContentPackCatalogService? catalogService,
  })  : _manager = manager ?? ContentPackManager(),
        _catalogService = catalogService ?? const ContentPackCatalogService();

  final ContentPackManager _manager;
  final ContentPackCatalogService _catalogService;

  final Map<String, ContentPack> _packs = {};
  final Map<String, ContentPackInstallationStatus> _statuses = {};
  final Map<String, ContentPackDownloadProgress> _progress = {};

  /// Tracks active operations per pack.
  ///
  /// This prevents multiple UI actions from starting concurrent downloads
  /// or updates for the same content pack.
  final Map<String, Future<void>> _operations = {};

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Whether at least one content-pack operation is currently running.
  bool get hasActiveOperation => _operations.isNotEmpty;

  List<ContentPack> get packs =>
      List.unmodifiable(_packs.values.toList(growable: false));

  ContentPack? getPack(String packId) => _packs[packId];

  ContentPackDownloadProgress? progressFor(String? packId) {
    if (packId == null || packId.trim().isEmpty) {
      return null;
    }

    return _progress[packId];
  }

  ContentPackInstallationStatus statusFor(String? packId) {
    if (packId == null || packId.trim().isEmpty) {
      return ContentPackInstallationStatus.installed;
    }

    return _statuses[packId] ?? ContentPackInstallationStatus.notInstalled;
  }

  bool isAvailable(String? packId) {
    if (packId == null || packId.trim().isEmpty) {
      return true;
    }

    final status = statusFor(packId);

    return status == ContentPackInstallationStatus.installed ||
        status == ContentPackInstallationStatus.updateAvailable;
  }

  bool isDownloading(String? packId) {
    return statusFor(packId) == ContentPackInstallationStatus.downloading;
  }

  bool isInstalling(String? packId) {
    return statusFor(packId) == ContentPackInstallationStatus.installing;
  }

  bool hasFailed(String? packId) {
    return statusFor(packId) == ContentPackInstallationStatus.failed;
  }

  bool hasActiveOperationFor(String? packId) {
    if (packId == null || packId.trim().isEmpty) {
      return false;
    }

    return _operations.containsKey(packId);
  }

  Future<void> load() async {
    if (_loading) {
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _manager.initialize();

      final catalog = await _catalogService.fetchActivePacks();

      _packs
        ..clear()
        ..addEntries(
          catalog.map(
            (pack) => MapEntry(pack.id, pack),
          ),
        );

      _statuses.clear();
      _progress.clear();

      for (final pack in catalog) {
        final installation = await _manager.getInstallation(pack.id);

        if (installation == null) {
          _statuses[pack.id] = ContentPackInstallationStatus.notInstalled;
          continue;
        }

        _statuses[pack.id] = installation.status;

        if (installation.version < pack.version && installation.isUsable) {
          _statuses[pack.id] = ContentPackInstallationStatus.updateAvailable;
        }
      }
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPack(String packId) async {
    final pack = _packs[packId];

    if (pack == null) {
      return;
    }

    final installation = await _manager.getInstallation(packId);

    if (installation == null) {
      _statuses[packId] = ContentPackInstallationStatus.notInstalled;
    } else {
      _statuses[packId] = installation.status;

      if (installation.version < pack.version && installation.isUsable) {
        _statuses[packId] = ContentPackInstallationStatus.updateAvailable;
      }
    }

    notifyListeners();
  }

  Future<void> download(
    String packId, {
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) {
    return _runOperation(
      packId,
      () => _download(
        packId,
        onProgress: onProgress,
      ),
    );
  }

  Future<void> _download(
    String packId, {
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) async {
    final pack = _packs[packId];

    if (pack == null) {
      throw ContentPackPipelineException(
        'Content pack "$packId" was not found in the catalog.',
      );
    }

    final currentStatus = statusFor(packId);

    if (currentStatus == ContentPackInstallationStatus.installed ||
        currentStatus == ContentPackInstallationStatus.updateAvailable) {
      return;
    }

    _statuses[packId] = ContentPackInstallationStatus.downloading;
    _progress.remove(packId);
    _error = null;
    notifyListeners();

    try {
      await _manager.downloadAndInstall(
        pack: pack,
        onProgress: (progress) {
          _progress[packId] = progress;
          onProgress?.call(progress);
          notifyListeners();
        },
      );

      _statuses[packId] = ContentPackInstallationStatus.installed;
    } catch (error) {
      _statuses[packId] = ContentPackInstallationStatus.failed;
      _error = error.toString();
      rethrow;
    } finally {
      _progress.remove(packId);
      notifyListeners();
    }
  }

  Future<void> update(
    String packId, {
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) {
    return _runOperation(
      packId,
      () => _update(
        packId,
        onProgress: onProgress,
      ),
    );
  }

  Future<void> _update(
    String packId, {
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) async {
    final pack = _packs[packId];

    if (pack == null) {
      throw ContentPackPipelineException(
        'Content pack "$packId" was not found in the catalog.',
      );
    }

    _statuses[packId] = ContentPackInstallationStatus.downloading;
    _progress.remove(packId);
    _error = null;
    notifyListeners();

    try {
      await _manager.updatePack(
        pack: pack,
        onProgress: (progress) {
          _progress[packId] = progress;
          onProgress?.call(progress);
          notifyListeners();
        },
      );

      _statuses[packId] = ContentPackInstallationStatus.installed;
    } catch (error) {
      _error = error.toString();

      // An unsuccessful update must not hide a usable installed version.
      try {
        final installation = await _manager.getInstallation(packId);

        if (installation != null && installation.isUsable) {
          _statuses[packId] =
              pack.version > installation.version
                  ? ContentPackInstallationStatus.updateAvailable
                  : ContentPackInstallationStatus.installed;
        } else {
          _statuses[packId] = ContentPackInstallationStatus.failed;
        }
      } catch (_) {
        _statuses[packId] = ContentPackInstallationStatus.failed;
      }

      rethrow;
    } finally {
      _progress.remove(packId);
      notifyListeners();
    }
  }

  Future<void> retry(
    String packId, {
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) {
    return _runOperation(
      packId,
      () => _retry(
        packId,
        onProgress: onProgress,
      ),
    );
  }

  Future<void> _retry(
    String packId, {
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) async {
    final pack = _packs[packId];

    if (pack == null) {
      throw ContentPackPipelineException(
        'Content pack "$packId" was not found in the catalog.',
      );
    }

    final installation = await _manager.getInstallation(packId);

    if (installation != null &&
        installation.isUsable &&
        pack.version > installation.version) {
      await _update(
        packId,
        onProgress: onProgress,
      );
      return;
    }

    await _download(
      packId,
      onProgress: onProgress,
    );
  }

  /// Cancels the active content-pack download.
  ///
  /// The manager delegates cancellation to the downloader. The current
  /// operation then completes with its cancellation exception and the
  /// provider records the operation as failed/retryable.
  Future<void> cancel(String packId) async {
    if (!_operations.containsKey(packId)) {
      return;
    }

    await _manager.cancelDownload();
  }

  Future<void> remove(String packId) async {
    if (_operations.containsKey(packId)) {
      throw StateError(
        'Cannot remove content pack "$packId" while an operation '
        'is in progress.',
      );
    }

    await _manager.removePack(packId);

    _statuses[packId] = ContentPackInstallationStatus.notInstalled;
    _progress.remove(packId);

    notifyListeners();
  }

  /// Runs exactly one operation for a given pack.
  ///
  /// A second request for the same pack receives the already-running
  /// operation instead of starting another download.
  Future<void> _runOperation(
    String packId,
    Future<void> Function() operation,
  ) {
    final existing = _operations[packId];

    if (existing != null) {
      return existing;
    }

    final future = operation();

    _operations[packId] = future;

    return future.whenComplete(() {
      _operations.remove(packId);
    });
  }
}

