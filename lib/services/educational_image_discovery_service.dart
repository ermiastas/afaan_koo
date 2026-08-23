import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/educational_image_asset.dart';

typedef AssetPathLoader = Future<List<String>> Function();
typedef AssetTextLoader = Future<String> Function(String path);
typedef AssetBytesLoader = Future<Uint8List> Function(String path);

class EducationalImageReference {
  const EducationalImageReference({
    required this.path,
    this.title,
    this.description,
    this.category,
    this.lessonId,
    this.lessonTitle,
  });

  final String path;
  final String? title;
  final String? description;
  final String? category;
  final String? lessonId;
  final String? lessonTitle;
}

/// Finds bundled images and image references in the content JSON files. Dart
/// source code is compiled away at runtime, so a developer-time source scanner
/// complements this service; the runtime catalog remains authoritative for
/// every packaged asset and all data-driven lesson content.
class EducationalImageDiscoveryService {
  EducationalImageDiscoveryService({
    AssetPathLoader? assetPathsLoader,
    AssetTextLoader? assetTextLoader,
    AssetBytesLoader? assetBytesLoader,
  })  : _assetPathsLoader = assetPathsLoader ?? _loadAssetPaths,
        _assetTextLoader = assetTextLoader ?? rootBundle.loadString,
        _assetBytesLoader = assetBytesLoader ?? _loadAssetBytes;

  static const discoveryVersion = 1;
  static const contentJsonPaths = <String>[
    'lib/content/alphabet/letters.json',
    'lib/content/animals/animals.json',
    'lib/content/words/words.json',
    'lib/content/colors/colors.json',
    'lib/content/numbers/numbers.json',
    'lib/content/stories/stories.json',
    'lib/content/songs/songs.json',
    'lib/content/quizzes/quizzes.json',
  ];

  final AssetPathLoader _assetPathsLoader;
  final AssetTextLoader _assetTextLoader;
  final AssetBytesLoader _assetBytesLoader;

  Future<List<EducationalImageAsset>> discover({
    Iterable<EducationalImageAsset> existing = const [],
  }) async {
    final paths = await _assetPathsLoader();
    final imagePaths = paths.where(_isSupportedImage).toList()..sort();
    final references = await _discoverJsonReferences(paths, imagePaths);
    final existingByPath = {
      for (final asset in existing) asset.sourcePath: asset,
    };
    final referencesByPath = <String, List<EducationalImageReference>>{};
    for (final reference in references) {
      final resolved = _resolvePath(reference.path, imagePaths);
      if (resolved == null || resolved.startsWith('http')) continue;
      referencesByPath.putIfAbsent(resolved, () => []).add(reference);
    }

    final now = DateTime.now();
    final assets = <EducationalImageAsset>[];
    for (final path in imagePaths) {
      final metadata = referencesByPath[path] ?? const [];
      final current = existingByPath[path];
      assets.add(_buildAsset(
        sourcePath: path,
        metadata: metadata,
        now: now,
        existing: current,
      ));
    }

    // Remote sources referenced by future content are catalogued too. They are
    // deliberately not downloaded during discovery; a repository can cache
    // them later when the product has a consented sync policy.
    for (final reference
        in references.where((item) => item.path.startsWith('http'))) {
      final current = existing.firstWhereOrNull(
        (asset) => asset.remoteUrl == reference.path,
      );
      assets.add(_buildAsset(
        sourcePath: '',
        remoteUrl: reference.path,
        metadata: [reference],
        now: now,
        existing: current,
      ));
    }
    return assets;
  }

  Future<Uint8List> loadOriginalBytes(EducationalImageAsset asset) {
    if (asset.source != EducationalImageSource.bundledAsset ||
        asset.sourcePath.isEmpty) {
      throw UnsupportedError(
          'This source must be downloaded before conversion.');
    }
    return _assetBytesLoader(asset.sourcePath);
  }

  EducationalImageAsset _buildAsset({
    required String sourcePath,
    required List<EducationalImageReference> metadata,
    required DateTime now,
    required EducationalImageAsset? existing,
    String? remoteUrl,
  }) {
    final first = metadata.isEmpty ? null : metadata.first;
    final category = first?.category ?? _categoryFor(sourcePath);
    final title = first?.title ??
        existing?.title ??
        _humanize(_basename(sourcePath.isEmpty ? remoteUrl! : sourcePath));
    final lessonIds = <String>{
      ...?existing?.lessonIds,
      ...metadata
          .map((item) => item.lessonId)
          .where((item) => item != null && item.isNotEmpty)
          .cast<String>(),
    }.toList();
    final lessonTitles = <String>{
      ...?existing?.lessonTitles,
      ...metadata
          .map((item) => item.lessonTitle)
          .where((item) => item != null && item.isNotEmpty)
          .cast<String>(),
    }.toList();
    final value = sourcePath.isEmpty ? remoteUrl! : sourcePath;
    return EducationalImageAsset(
      id: existing?.id ?? 'image_${_stableId(value)}',
      sourcePath: sourcePath,
      remoteUrl: remoteUrl,
      title: title,
      description: first?.description,
      category: category,
      subject: _subjectFor(category),
      ageGroup: first == null ? existing?.ageGroup ?? '3-12' : '3-10',
      lessonIds: lessonIds,
      lessonTitles: lessonTitles,
      format: _formatFor(value),
      source: sourcePath.isEmpty
          ? EducationalImageSource.remote
          : EducationalImageSource.bundledAsset,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      width: existing?.width,
      height: existing?.height,
      fileSizeBytes: existing?.fileSizeBytes,
      colorCount: existing?.colorCount,
      hasTransparency: existing?.hasTransparency,
      contentFingerprint: existing?.contentFingerprint,
      perceptualHash: existing?.perceptualHash,
      isColoringCandidate: existing?.isColoringCandidate ?? false,
      conversionConfidence: existing?.conversionConfidence ?? 0,
      candidateReason: existing?.candidateReason,
      conversionStatus:
          existing?.conversionStatus ?? ColoringConversionStatus.discovered,
      generatedSvgPath: existing?.generatedSvgPath,
      thumbnailPath: existing?.thumbnailPath,
      vectorizationVersion: existing?.vectorizationVersion ?? 1,
      errorReason: existing?.errorReason,
      isCanonical: existing?.isCanonical ?? true,
      canonicalAssetId: existing?.canonicalAssetId,
      isEnabled: existing?.isEnabled ?? true,
    );
  }

  Future<List<EducationalImageReference>> _discoverJsonReferences(
    List<String> assetPaths,
    List<String> imagePaths,
  ) async {
    final references = <EducationalImageReference>[];
    for (final jsonPath in contentJsonPaths.where(assetPaths.contains)) {
      try {
        final decoded = jsonDecode(await _assetTextLoader(jsonPath));
        _walkJson(
          decoded,
          jsonPath: jsonPath,
          imagePaths: imagePaths,
          references: references,
        );
      } catch (_) {
        // One malformed lesson must not prevent all other lessons indexing.
      }
    }
    return references;
  }

  void _walkJson(
    Object? value, {
    required String jsonPath,
    required List<String> imagePaths,
    required List<EducationalImageReference> references,
    Map<String, dynamic>? parent,
  }) {
    if (value is List) {
      for (final item in value) {
        _walkJson(item,
            jsonPath: jsonPath,
            imagePaths: imagePaths,
            references: references,
            parent: parent);
      }
      return;
    }
    if (value is! Map) return;
    final map = Map<String, dynamic>.from(value);
    for (final entry in map.entries) {
      if (entry.value is String && _isImageReferenceKey(entry.key)) {
        final path = entry.value as String;
        if (_resolvePath(path, imagePaths) != null || path.startsWith('http')) {
          final lessonId = _lessonForJson(jsonPath);
          references.add(EducationalImageReference(
            path: path,
            title: _string(map, ['nameOromo', 'word', 'title', 'name']),
            description:
                _string(map, ['nameEnglish', 'description', 'english']),
            category: _string(map, ['category']) ?? _categoryFor(jsonPath),
            lessonId: lessonId,
            lessonTitle: _lessonTitle(lessonId),
          ));
        }
      }
      _walkJson(entry.value,
          jsonPath: jsonPath,
          imagePaths: imagePaths,
          references: references,
          parent: map);
    }
  }

  static Future<List<String>> _loadAssetPaths() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    return manifest.listAssets();
  }

  static Future<Uint8List> _loadAssetBytes(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  bool _isSupportedImage(String path) =>
      RegExp(r'\.(png|jpe?g|webp|svg)$', caseSensitive: false).hasMatch(path);

  bool _isImageReferenceKey(String key) => RegExp(
          r'(^|_)(image|thumbnail|illustration|cover|picture|imageurl|image_url)$',
          caseSensitive: false)
      .hasMatch(key);

  String? _resolvePath(String value, List<String> available) {
    if (value.startsWith('http')) return value;
    if (available.contains(value)) return value;
    final basename = _basename(value).toLowerCase();
    final matches =
        available.where((path) => _basename(path).toLowerCase() == basename);
    if (matches.isEmpty) return null;
    // A JSON file's own topic is the safest tie-breaker for short names such
    // as `a.png` and `bird.png` that appear in several lesson folders.
    return matches.reduce((best, candidate) =>
        _pathAffinity(candidate, value) > _pathAffinity(best, value)
            ? candidate
            : best);
  }

  int _pathAffinity(String candidate, String reference) {
    var score = 0;
    for (final token in reference.toLowerCase().split('/')) {
      if (token.length > 2 && candidate.toLowerCase().contains(token)) {
        score++;
      }
    }
    return score;
  }

  ImageFormat _formatFor(String value) {
    final lower = value.toLowerCase();
    if (lower.endsWith('.png')) return ImageFormat.png;
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return ImageFormat.jpg;
    }
    if (lower.endsWith('.webp')) return ImageFormat.webp;
    if (lower.endsWith('.svg')) return ImageFormat.svg;
    return ImageFormat.unknown;
  }

  String _categoryFor(String value) {
    final text = value.toLowerCase();
    const map = <String, String>{
      'alphabet': 'Qubee',
      'numbers': 'Lakkoofsa',
      'animals': 'Bineensota',
      'plants': 'Biqiltoota',
      'fruits': 'Muduraa',
      'vegetables': 'Kuduraa',
      'food': 'Nyaata',
      'family': 'Maatii',
      'home': 'Mana',
      'school': 'Mana Barumsaa',
      'transport': 'Geejjibaa',
      'clothing': 'Uffata',
      'body': 'Qaama Nama',
      'occupation': 'Hojii',
      'weather': 'Qilleensa',
      'environment': 'Uumama',
      'culture': 'Aadaa',
      'stories': 'Seenaa',
      'shapes': 'Shapes',
      'coloring': 'Other',
    };
    for (final entry in map.entries) {
      if (text.contains(entry.key)) return entry.value;
    }
    return 'Other';
  }

  String _subjectFor(String? category) => switch (category) {
        'Qubee' || 'Lakkoofsa' => 'Afaan fi Lakkoofsa',
        'Bineensota' || 'Biqiltoota' || 'Uumama' || 'Qilleensa' => 'Uumama',
        'Aadaa' || 'Seenaa' => 'Aadaa Oromoo',
        _ => 'Jireenya Guyyaa Guyyaa',
      };

  String _lessonForJson(String path) {
    final parts = path.split('/');
    return parts.length > 2 ? parts[2] : 'content';
  }

  String _lessonTitle(String id) => switch (id) {
        'animals' => 'Bineensa Koo',
        'alphabet' => 'Qubee Koo',
        'numbers' => 'Lakkoofsa Koo',
        'words' => 'Jechoota Koo',
        'stories' => 'Oduu Durii',
        _ => id,
      };

  String _stableId(String input) {
    var hash = 0x811c9dc5;
    for (final codeUnit in input.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }

  String _basename(String path) => path.split('/').last.split('.').first;
  String _humanize(String value) =>
      value.replaceAll(RegExp(r'[_-]+'), ' ').replaceAllMapped(
          RegExp(r'\b\w'), (match) => match.group(0)!.toUpperCase());
  String? _string(Map<String, dynamic> value, List<String> keys) {
    for (final key in keys) {
      final result = value[key];
      if (result is String && result.trim().isNotEmpty) return result;
    }
    return null;
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
