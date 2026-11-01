import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:afaan_koo_app/services/png_coloring_engine.dart';

void main() {
  group('PngColoringEngine', () {
    const engine = PngColoringEngine();

    test('decodes and encodes a PNG image', () {
      final source = img.Image(
        width: 20,
        height: 20,
      );

      final bytes = Uint8List.fromList(
        img.encodePng(source),
      );

      final decoded = engine.decode(bytes);

      expect(decoded, isNotNull);
      expect(decoded!.width, 20);
      expect(decoded.height, 20);

      final encoded = engine.encodePng(decoded);

      expect(encoded, isNotEmpty);
      expect(engine.decode(encoded), isNotNull);
    });

    test('flood fills a connected region', () {
      final image = img.Image(
        width: 10,
        height: 10,
      );

      final black = img.ColorRgb8(0, 0, 0);
      final white = img.ColorRgb8(255, 255, 255);
      final red = img.ColorRgb8(255, 0, 0);

      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width; x++) {
          image.setPixel(x, y, white);
        }
      }

      for (var x = 0; x < image.width; x++) {
        image.setPixel(x, 0, black);
        image.setPixel(x, image.height - 1, black);
      }

      for (var y = 0; y < image.height; y++) {
        image.setPixel(0, y, black);
        image.setPixel(image.width - 1, y, black);
      }

      final changed = engine.floodFill(
        image: image,
        startX: 5,
        startY: 5,
        fillColor: red,
        tolerance: 10,
      );

      expect(changed, greaterThan(1));
      expect(
        image.getPixel(5, 5).r.toInt(),
        255,
      );
      expect(
        image.getPixel(5, 5).g.toInt(),
        0,
      );
      expect(
        image.getPixel(5, 5).b.toInt(),
        0,
      );

      expect(
        image.getPixel(0, 0).r.toInt(),
        0,
      );
    });

    test('detects enclosed regions but ignores outside background', () {
      final image = img.Image(
        width: 20,
        height: 20,
      );

      final black = img.ColorRgb8(0, 0, 0);
      final white = img.ColorRgb8(255, 255, 255);

      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width; x++) {
          image.setPixel(x, y, white);
        }
      }

      for (var x = 5; x <= 14; x++) {
        image.setPixel(x, 5, black);
        image.setPixel(x, 14, black);
      }

      for (var y = 5; y <= 14; y++) {
        image.setPixel(5, y, black);
        image.setPixel(14, y, black);
      }

      final regions = engine.detectEnclosedRegions(
        image: image,
        minimumPixels: 10,
      );

      expect(regions, hasLength(1));

      final region = regions.single;

      expect(region.seedX, greaterThanOrEqualTo(6));
      expect(region.seedX, lessThanOrEqualTo(13));
      expect(region.seedY, greaterThanOrEqualTo(6));
      expect(region.seedY, lessThanOrEqualTo(13));
      expect(region.pixelCount, 64);
      expect(region.width, 8);
      expect(region.height, 8);
    });
    test('does not cross a closed boundary', () {
      final image = img.Image(
        width: 9,
        height: 9,
      );

      final black = img.ColorRgb8(0, 0, 0);
      final white = img.ColorRgb8(255, 255, 255);
      final blue = img.ColorRgb8(0, 0, 255);

      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width; x++) {
          image.setPixel(x, y, white);
        }
      }

      for (var x = 2; x <= 6; x++) {
        image.setPixel(x, 2, black);
        image.setPixel(x, 6, black);
      }

      for (var y = 2; y <= 6; y++) {
        image.setPixel(2, y, black);
        image.setPixel(6, y, black);
      }

      engine.floodFill(
        image: image,
        startX: 4,
        startY: 4,
        fillColor: blue,
        tolerance: 10,
      );

      expect(
        image.getPixel(4, 4).b.toInt(),
        255,
      );

      expect(
        image.getPixel(1, 1).r.toInt(),
        255,
      );

      expect(
        image.getPixel(4, 1).r.toInt(),
        255,
      );
    });
  });
}
