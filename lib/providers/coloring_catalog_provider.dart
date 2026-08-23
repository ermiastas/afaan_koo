import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/coloring_action.dart';
import '../models/coloring_artwork.dart';
import '../models/coloring_page.dart';
import '../models/educational_image_asset.dart';
import '../services/coloring_catalog_repository.dart';
import '../services/educational_image_analyzer.dart';
import '../services/educational_image_discovery_service.dart';
import '../services/image_vectorization_service.dart';

/// The single state owner for discovered assets, derived SVGs, approvals and
/// saved artwork. UI code accesses this provider; it never talks directly to a
/// cloud client or to the filesystem.
class ColoringCatalogProvider extends ChangeNotifier {
  ColoringCatalogProvider({
    ColoringCatalogRepository? repository,
    EducationalImageDiscoveryService? discovery,
    EducationalImageAnalyzer? analyzer,
    ImageVectorizationService? vectorizer,
    Random? random,
  })  : _repository = repository ?? LocalColoringCatalogRepository(),
        _discovery = discovery ?? EducationalImageDiscoveryService(),
        _analyzer = analyzer ?? const EducationalImageAnalyzer(),
        _vectorizer = vectorizer ?? ImageVectorizationService(),
        _random = random ?? Random();

  final ColoringCatalogRepository _repository;
  final EducationalImageDiscoveryService _discovery;
  final EducationalImageAnalyzer _analyzer;
  final ImageVectorizationService _vectorizer;
  final Random _random;

  final List<EducationalImageAsset> _assets = [];
  final Map<String, String> _svgByAssetId = {};
  final List<ColoringArtwork> _artworks = [];
  final List<String> _recentPageIds = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  List<EducationalImageAsset> get assets => List.unmodifiable(_assets);
  List<ColoringArtwork> get artworks {
    final sorted = List<ColoringArtwork>.from(_artworks)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(sorted);
  }

  List<EducationalImageAsset> get pendingReview =>
      List.unmodifiable(_assets.where((asset) =>
          asset.conversionStatus == ColoringConversionStatus.pendingReview));

  List<ColoringPage> get pages => _assets
      .where(
          (asset) => asset.isPublished && _svgByAssetId.containsKey(asset.id))
      .map(_pageFromAsset)
      .toList(growable: false);

  List<String> get categories => pages
      .map((page) => page.category)
      .where((category) => category.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  Future<void> initialize({int initialConversionBudget = 6}) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final storedAssets = await _repository.loadAssets();
      _assets
        ..clear()
        ..addAll(await _discovery.discover(existing: storedAssets));
      await _repository.saveAssets(_assets);
      _artworks
        ..clear()
        ..addAll(await _repository.loadArtworks());
      for (final asset in _assets.where((asset) => asset.isPublished)) {
        final svg = await _repository.loadGeneratedSvg(asset.id);
        if (svg != null) _svgByAssetId[asset.id] = svg;
      }
      _isInitialized = true;
      await processNextBatch(maximum: initialConversionBudget, notify: false);
    } catch (error, stackTrace) {
      debugPrint('Coloring catalog initialization error: $error\n$stackTrace');
      _error = 'Suuraawwan haaromsuun hin milkoofne.';
      _isInitialized = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Processes a deliberately small batch. This prevents hundreds of bundled
  /// images being vectorised again whenever a child opens the screen.
  Future<void> processNextBatch({int maximum = 3, bool notify = true}) async {
    if (_isLoading && !_isInitialized) return;
    var processed = 0;
    final queue = _assets
        .where((asset) =>
            asset.source == EducationalImageSource.bundledAsset &&
            asset.conversionStatus == ColoringConversionStatus.discovered)
        .toList()
      ..sort((a, b) => _priorityFor(b).compareTo(_priorityFor(a)));
    for (final asset in queue) {
      if (processed >= maximum) break;
      processed++;
      await _analyzeAndMaybeConvert(asset);
    }
    if (processed > 0) await _repository.saveAssets(_assets);
    if (notify && processed > 0) notifyListeners();
  }

  Future<void> _analyzeAndMaybeConvert(EducationalImageAsset asset) async {
    try {
      _replace(asset.copyWith(
        conversionStatus: ColoringConversionStatus.queued,
        updatedAt: DateTime.now(),
      ));
      final bytes = await _discovery.loadOriginalBytes(asset);
      if (asset.format == ImageFormat.svg) {
        // Existing SVGs are treated as supplied derived assets only after a
        // separate validator/review path; no untrusted SVG is auto-published.
        _replace(asset.copyWith(
          isColoringCandidate: false,
          conversionStatus: ColoringConversionStatus.pendingReview,
          candidateReason: 'Existing SVG needs an adult safety review.',
          fileSizeBytes: bytes.length,
          updatedAt: DateTime.now(),
        ));
        return;
      }
      final analysis = await _analyzer.analyze(asset: asset, bytes: bytes);
      final analyzed = asset.copyWith(
        width: analysis.width,
        height: analysis.height,
        fileSizeBytes: bytes.length,
        colorCount: analysis.colorCount,
        hasTransparency: analysis.hasTransparency,
        contentFingerprint: analysis.contentFingerprint,
        perceptualHash: analysis.perceptualHash,
        isColoringCandidate: analysis.isColoringCandidate,
        conversionConfidence: analysis.confidence,
        candidateReason: analysis.reason,
        conversionStatus: analysis.isColoringCandidate
            ? ColoringConversionStatus.converting
            : ColoringConversionStatus.analyzed,
        updatedAt: DateTime.now(),
      );
      final duplicate = _canonicalDuplicateFor(analyzed);
      if (duplicate != null) {
        _replace(analyzed.copyWith(
          isCanonical: false,
          canonicalAssetId: duplicate.id,
          conversionStatus: ColoringConversionStatus.rejected,
          candidateReason:
              'Duplicate of ${duplicate.title}; lesson links were retained.',
        ));
        return;
      }
      if (!analysis.isColoringCandidate) {
        _replace(analyzed);
        return;
      }
      final vector = await _vectorizer.vectorize(asset: analyzed, bytes: bytes);
      await _repository.saveGeneratedSvg(analyzed.id, vector.svg);
      _svgByAssetId[analyzed.id] = vector.svg;
      final status = vector.confidence >= 0.74
          ? ColoringConversionStatus.published
          : ColoringConversionStatus.pendingReview;
      _replace(analyzed.copyWith(
        conversionConfidence: vector.confidence,
        generatedSvgPath: 'cache://generated/${analyzed.id}.svg',
        conversionStatus: status,
        errorReason: null,
        updatedAt: DateTime.now(),
      ));
    } catch (error, stackTrace) {
      debugPrint(
          'Coloring conversion failed for ${asset.sourcePath}: $error\n$stackTrace');
      _replace(asset.copyWith(
        conversionStatus: ColoringConversionStatus.failed,
        errorReason: error.toString(),
        updatedAt: DateTime.now(),
      ));
    }
  }

  Future<void> approve(String assetId) async {
    final asset = assetById(assetId);
    if (asset == null || !_svgByAssetId.containsKey(assetId)) return;
    _replace(asset.copyWith(
      conversionStatus: ColoringConversionStatus.published,
      isEnabled: true,
      updatedAt: DateTime.now(),
    ));
    await _repository.saveAssets(_assets);
    notifyListeners();
  }

  Future<void> reject(String assetId) async {
    final asset = assetById(assetId);
    if (asset == null) return;
    _replace(asset.copyWith(
      conversionStatus: ColoringConversionStatus.rejected,
      updatedAt: DateTime.now(),
    ));
    await _repository.saveAssets(_assets);
    notifyListeners();
  }

  Future<void> retry(String assetId) async {
    final asset = assetById(assetId);
    if (asset == null) return;
    _replace(asset.copyWith(
      conversionStatus: ColoringConversionStatus.discovered,
      errorReason: null,
      updatedAt: DateTime.now(),
    ));
    await _repository.saveAssets(_assets);
    await processNextBatch(maximum: 1);
  }

  Future<void> setEnabled(String assetId, bool enabled) async {
    final asset = assetById(assetId);
    if (asset == null) return;
    _replace(asset.copyWith(isEnabled: enabled, updatedAt: DateTime.now()));
    await _repository.saveAssets(_assets);
    notifyListeners();
  }

  ColoringPage? randomPage({
    required int age,
    Iterable<String> currentLessonIds = const [],
    Iterable<String> favouriteCategories = const [],
  }) {
    final available = pages;
    if (available.isEmpty) return null;
    final ageAppropriate =
        available.where((page) => page.ages.contains(age)).toList();
    final pool = ageAppropriate.isEmpty ? available : ageAppropriate;
    final current = currentLessonIds.toSet();
    final favourites = favouriteCategories.toSet();
    final completed = _artworks.map((item) => item.coloringPageId).toSet();
    final weighted = <ColoringPage>[];
    for (final page in pool) {
      var weight = 1;
      if (page.isNew) weight += 5;
      if (!completed.contains(page.id)) weight += 4;
      if (page.ages.contains(age)) weight += 3;
      if (page.lessonId != null && current.contains(page.lessonId)) weight += 4;
      if (favourites.contains(page.category)) weight += 2;
      if (_recentPageIds.contains(page.id)) weight = max(1, weight ~/ 6);
      for (var i = 0; i < weight; i++) {
        weighted.add(page);
      }
    }
    final selected = weighted[_random.nextInt(weighted.length)];
    _recentPageIds
      ..remove(selected.id)
      ..add(selected.id);
    if (_recentPageIds.length > 5) _recentPageIds.removeAt(0);
    return selected;
  }

  EducationalImageAsset? assetById(String id) =>
      _assets.firstWhereOrNull((asset) => asset.id == id);

  String? svgForPage(String pageId) {
    final page = assetById(pageId);
    if (page == null) return null;
    return _svgByAssetId[page.id];
  }

  Future<void> saveArtwork({
    required ColoringPage page,
    required String svgMarkup,
    required Map<String, int> colors,
    required List<ColoringAction> actions,
    required Duration timeSpent,
    Uint8List? previewBytes,
  }) async {
    final now = DateTime.now();
    final id = 'artwork_${now.microsecondsSinceEpoch}';
    final imagePath = previewBytes == null
        ? null
        : await _repository.saveArtworkImage(id, previewBytes);
    _artworks.add(ColoringArtwork(
      id: id,
      coloringPageId: page.id,
      title: page.titleOromo,
      createdAt: now,
      updatedAt: now,
      imagePath: imagePath,
      lessonId: page.lessonId,
      category: page.category,
      timeSpent: timeSpent,
      colorsUsed: colors.values.toSet().toList(),
      actions: actions,
      svgMarkup: svgMarkup,
    ));
    await _repository.saveArtworks(_artworks);
    notifyListeners();
  }

  Future<void> renameArtwork(String artworkId, String title) async {
    final index = _artworks.indexWhere((artwork) => artwork.id == artworkId);
    if (index < 0 || title.trim().isEmpty) return;
    _artworks[index] = _artworks[index].copyWith(
      title: title.trim(),
      updatedAt: DateTime.now(),
    );
    await _repository.saveArtworks(_artworks);
    notifyListeners();
  }

  Future<void> deleteArtwork(String artworkId) async {
    _artworks.removeWhere((artwork) => artwork.id == artworkId);
    await _repository.saveArtworks(_artworks);
    notifyListeners();
  }

  int _priorityFor(EducationalImageAsset asset) {
    final path = asset.sourcePath.toLowerCase();
    if (path.contains('/coloring/')) return 100;
    if (asset.lessonIds.isNotEmpty) return 80;
    if (asset.category != 'Other') return 60;
    return 0;
  }

  EducationalImageAsset? _canonicalDuplicateFor(EducationalImageAsset asset) {
    for (final other in _assets) {
      if (other.id == asset.id || !other.isCanonical) continue;
      if (asset.contentFingerprint != null &&
          asset.contentFingerprint == other.contentFingerprint) {
        return other;
      }
      if (asset.perceptualHash != null &&
          other.perceptualHash != null &&
          _hammingDistance(asset.perceptualHash!, other.perceptualHash!) <= 4) {
        return other;
      }
    }
    return null;
  }

  int _hammingDistance(String first, String second) {
    final length = min(first.length, second.length);
    var distance = (first.length - second.length).abs();
    for (var index = 0; index < length; index++) {
      if (first[index] != second[index]) distance++;
    }
    return distance;
  }

  ColoringPage _pageFromAsset(EducationalImageAsset asset) => ColoringPage(
        id: asset.id,
        category: asset.category ?? 'Other',
        titleOromo: asset.title,
        titleEnglish: asset.description ?? asset.title,
        image: asset.sourcePath,
        thumbnail: asset.thumbnailPath ?? asset.sourcePath,
        emoji: _emojiFor(asset.category),
        rewardXP: 10,
        ages: _agesFor(asset.ageGroup),
        tags: [asset.category ?? 'Other', ...asset.lessonIds],
        svgMarkup: _svgByAssetId[asset.id],
        lessonId: asset.lessonId,
        lessonTitle: asset.lessonTitle,
        sourceAssetId: asset.id,
        isNew: !_artworks.any((item) => item.coloringPageId == asset.id),
      );

  String _emojiFor(String? category) => switch (category) {
        'Qubee' => '🔤',
        'Lakkoofsa' => '🔢',
        'Bineensota' => '🐾',
        'Biqiltoota' || 'Uumama' => '🌿',
        'Muduraa' => '🍎',
        'Kuduraa' => '🥕',
        'Nyaata' => '🍽️',
        'Geejjibaa' => '🚗',
        'Aadaa' => '🏛️',
        _ => '🎨',
      };

  List<int> _agesFor(String? ageGroup) {
    final values = RegExp(r'\d+')
        .allMatches(ageGroup ?? '')
        .map((match) => int.parse(match.group(0)!))
        .toList();
    if (values.length < 2) return const [3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    final start = min(values[0], values[1]).toInt();
    final end = max(values[0], values[1]).toInt();
    return [for (var age = start; age <= end; age++) age];
  }

  void _replace(EducationalImageAsset asset) {
    final index = _assets.indexWhere((item) => item.id == asset.id);
    if (index >= 0) _assets[index] = asset;
  }
}

extension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T item) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
