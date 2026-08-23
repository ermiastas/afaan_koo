import 'dart:convert';
import 'dart:typed_data';

import '../models/coloring_artwork.dart';
import '../models/educational_image_asset.dart';
import 'coloring_cache_store.dart';

abstract class ColoringCatalogRepository {
  Future<List<EducationalImageAsset>> loadAssets();
  Future<void> saveAssets(List<EducationalImageAsset> assets);
  Future<String?> loadGeneratedSvg(String assetId);
  Future<void> saveGeneratedSvg(String assetId, String svg);
  Future<List<ColoringArtwork>> loadArtworks();
  Future<void> saveArtworks(List<ColoringArtwork> artworks);
  Future<String?> saveArtworkImage(String artworkId, Uint8List imageBytes);
}

class LocalColoringCatalogRepository implements ColoringCatalogRepository {
  LocalColoringCatalogRepository({ColoringCacheStore? store})
      : _store = store ?? ColoringCacheStore();

  static const _catalogKey = 'educational_image_catalog_v1';
  static const _artworkKey = 'coloring_artwork_v1';
  final ColoringCacheStore _store;

  @override
  Future<List<EducationalImageAsset>> loadAssets() async {
    final raw = await _store.readText(_catalogKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((item) => EducationalImageAsset.fromJson(
              Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      // A corrupt derived cache must never block the original app content.
      return const [];
    }
  }

  @override
  Future<void> saveAssets(List<EducationalImageAsset> assets) {
    return _store.writeText(
      _catalogKey,
      jsonEncode(assets.map((asset) => asset.toJson()).toList()),
    );
  }

  @override
  Future<String?> loadGeneratedSvg(String assetId) =>
      _store.readText('generated_svg_$assetId');

  @override
  Future<void> saveGeneratedSvg(String assetId, String svg) =>
      _store.writeText('generated_svg_$assetId', svg);

  @override
  Future<List<ColoringArtwork>> loadArtworks() async {
    final raw = await _store.readText(_artworkKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((item) =>
              ColoringArtwork.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveArtworks(List<ColoringArtwork> artworks) => _store.writeText(
        _artworkKey,
        jsonEncode(artworks.map((item) => item.toJson()).toList()),
      );

  @override
  Future<String?> saveArtworkImage(String artworkId, Uint8List imageBytes) =>
      _store.writeBytes('artwork_image_$artworkId', imageBytes);
}
