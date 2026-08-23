import 'dart:math';
import 'dart:typed_data';

import 'package:afaan_koo_app/models/coloring_artwork.dart';
import 'package:afaan_koo_app/models/educational_image_asset.dart';
import 'package:afaan_koo_app/providers/coloring_catalog_provider.dart';
import 'package:afaan_koo_app/services/coloring_catalog_repository.dart';
import 'package:afaan_koo_app/services/educational_image_discovery_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'random page prioritises age-appropriate lesson pages and avoids repeats',
      () async {
    final assets = [
      _asset('animal', 'assets/images/animals/lion.png', 'Bineensota', '3-5',
          'animals'),
      _asset(
          'fruit', 'assets/images/fruits/apple.png', 'Muduraa', '8-10', 'food'),
    ];
    final repository = _MemoryRepository(assets);
    final discovery = EducationalImageDiscoveryService(
      assetPathsLoader: () async =>
          assets.map((asset) => asset.sourcePath).toList(),
    );
    final provider = ColoringCatalogProvider(
      repository: repository,
      discovery: discovery,
      random: Random(3),
    );

    await provider.initialize(initialConversionBudget: 0);
    final page =
        provider.randomPage(age: 4, currentLessonIds: const ['animals']);

    expect(page, isNotNull);
    expect(page!.id, 'animal');
    expect(page.ages, contains(4));
  });
}

EducationalImageAsset _asset(
  String id,
  String path,
  String category,
  String ageGroup,
  String lessonId,
) =>
    EducationalImageAsset(
      id: id,
      sourcePath: path,
      title: id,
      category: category,
      ageGroup: ageGroup,
      lessonIds: [lessonId],
      lessonTitles: [lessonId],
      format: ImageFormat.png,
      source: EducationalImageSource.bundledAsset,
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
      conversionStatus: ColoringConversionStatus.published,
      generatedSvgPath: 'cache://generated/$id.svg',
    );

class _MemoryRepository implements ColoringCatalogRepository {
  _MemoryRepository(this.assets);

  List<EducationalImageAsset> assets;

  @override
  Future<List<EducationalImageAsset>> loadAssets() async => assets;

  @override
  Future<String?> loadGeneratedSvg(String assetId) async =>
      '<svg><path id="${assetId}_body" d="M0 0H10V10H0Z"/></svg>';

  @override
  Future<List<ColoringArtwork>> loadArtworks() async => const [];

  @override
  Future<void> saveAssets(List<EducationalImageAsset> value) async =>
      assets = value;

  @override
  Future<void> saveGeneratedSvg(String assetId, String svg) async {}

  @override
  Future<void> saveArtworks(List<ColoringArtwork> artworks) async {}

  @override
  Future<String?> saveArtworkImage(
          String artworkId, Uint8List imageBytes) async =>
      null;
}
