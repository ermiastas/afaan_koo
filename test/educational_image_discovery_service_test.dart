import 'dart:convert';

import 'package:afaan_koo_app/models/educational_image_asset.dart';
import 'package:afaan_koo_app/services/educational_image_discovery_service.dart';
import 'package:afaan_koo_app/services/svg_safety_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EducationalImageDiscoveryService', () {
    test('finds raster, SVG, JSON references and remote references', () async {
      final json = jsonEncode([
        {
          'nameOromo': 'Arba',
          'nameEnglish': 'Elephant',
          'category': 'Bineensota',
          'image': 'assets/images/animals/elephant.png',
        },
        {
          'nameOromo': 'Remote',
          'image_url': 'https://cdn.example.test/remote.webp',
        },
      ]);
      final service = EducationalImageDiscoveryService(
        assetPathsLoader: () async => [
          'lib/content/animals/animals.json',
          'assets/images/animals/elephant.png',
          'assets/images/fruits/apple.jpg',
          'assets/images/food/egg.webp',
          'assets/coloring/outline.svg',
        ],
        assetTextLoader: (_) async => json,
      );

      final assets = await service.discover();

      expect(
          assets.where((asset) => asset.format == ImageFormat.png), isNotEmpty);
      expect(
          assets.where((asset) => asset.format == ImageFormat.jpg), isNotEmpty);
      expect(assets.where((asset) => asset.format == ImageFormat.webp),
          isNotEmpty);
      expect(
          assets.where((asset) => asset.format == ImageFormat.svg), isNotEmpty);
      final elephant = assets.singleWhere(
        (asset) => asset.sourcePath == 'assets/images/animals/elephant.png',
      );
      expect(elephant.title, 'Arba');
      expect(elephant.lessonIds, contains('animals'));
      expect(assets.singleWhere((asset) => asset.remoteUrl != null).remoteUrl,
          'https://cdn.example.test/remote.webp');
    });

    test('preserves existing generated state while refreshing metadata',
        () async {
      final previous = EducationalImageAsset(
        id: 'saved',
        sourcePath: 'assets/images/animals/elephant.png',
        title: 'Arba',
        format: ImageFormat.png,
        source: EducationalImageSource.bundledAsset,
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
        conversionStatus: ColoringConversionStatus.published,
        generatedSvgPath: 'cache://generated/saved.svg',
      );
      final service = EducationalImageDiscoveryService(
        assetPathsLoader: () async => ['assets/images/animals/elephant.png'],
      );
      final refreshed = await service.discover(existing: [previous]);
      expect(refreshed.single.id, 'saved');
      expect(refreshed.single.conversionStatus,
          ColoringConversionStatus.published);
      expect(refreshed.single.generatedSvgPath, 'cache://generated/saved.svg');
    });
  });

  group('SvgSafetyValidator', () {
    const validator = SvgSafetyValidator();

    test('accepts closed, uniquely identified vector regions', () {
      const svg = '<svg><path id="body" d="M0 0H10V10H0Z"/>'
          '<path id="eye" d="M2 2H3V3H2Z"/></svg>';
      final result = validator.validate(svg);
      expect(result.isValid, isTrue);
      expect(result.regionIds, ['body', 'eye']);
    });

    test('rejects embedded raster and duplicate regions', () {
      expect(
        validator.validate('<svg><image href="x.png"/></svg>').isValid,
        isFalse,
      );
      expect(
        validator
            .validate('<svg><path id="a" d="M0 0H1V1H0Z"/>'
                '<path id="a" d="M0 0H1V1H0Z"/></svg>')
            .isValid,
        isFalse,
      );
    });
  });
}
