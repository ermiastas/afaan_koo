import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Core engine for coloring raster/PNG line-art images.
class PngColoringEngine {
  const PngColoringEngine();

  /// Decodes image bytes into an editable raster image.
  img.Image? decode(Uint8List bytes) {
    if (bytes.isEmpty) {
      return null;
    }

    return img.decodeImage(bytes);
  }

  /// Encodes a raster image as PNG bytes.
  Uint8List encodePng(img.Image image) {
    return Uint8List.fromList(
      img.encodePng(image),
    );
  }

  /// Detects light-colored regions completely enclosed by darker boundaries.
  ///
  /// Regions touching the image border are treated as background and ignored.
  List<PngColoringRegion> detectEnclosedRegions({
    required img.Image image,
    int backgroundTolerance = 40,
    int minimumPixels = 16,
  }) {
    if (image.width <= 0 || image.height <= 0) {
      return const <PngColoringRegion>[];
    }

    final visited = <int>{};
    final regions = <PngColoringRegion>[];

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final index = y * image.width + x;

        if (visited.contains(index)) {
          continue;
        }

        final pixel = image.getPixel(x, y);

        if (!_isBackgroundPixel(pixel, backgroundTolerance)) {
          visited.add(index);
          continue;
        }

        final component = _collectBackgroundComponent(
          image: image,
          startX: x,
          startY: y,
          visited: visited,
          tolerance: backgroundTolerance,
        );

        if (component.touchesBorder) {
          continue;
        }

        if (component.pixelCount < minimumPixels) {
          continue;
        }

        regions.add(
          PngColoringRegion(
            seedX: component.seedX,
            seedY: component.seedY,
            pixelCount: component.pixelCount,
            left: component.minX,
            top: component.minY,
            right: component.maxX,
            bottom: component.maxY,
          ),
        );
      }
    }

    return List<PngColoringRegion>.unmodifiable(regions);
  }

  /// Fills the connected region containing [startX], [startY].
  int floodFill({
    required img.Image image,
    required int startX,
    required int startY,
    required img.Color fillColor,
    int tolerance = 24,
  }) {
    if (image.width <= 0 || image.height <= 0) {
      return 0;
    }

    if (startX < 0 ||
        startY < 0 ||
        startX >= image.width ||
        startY >= image.height) {
      return 0;
    }

    final targetPixel = image.getPixel(startX, startY);

    final targetR = targetPixel.r.toInt();
    final targetG = targetPixel.g.toInt();
    final targetB = targetPixel.b.toInt();

    final fillR = fillColor.r.toInt();
    final fillG = fillColor.g.toInt();
    final fillB = fillColor.b.toInt();

    if ((targetR - fillR).abs() <= tolerance &&
        (targetG - fillG).abs() <= tolerance &&
        (targetB - fillB).abs() <= tolerance) {
      return 0;
    }

    final queue = <_Pixel>[
      _Pixel(startX, startY),
    ];

    final visited = <int>{};
    var changed = 0;

    while (queue.isNotEmpty) {
      final pixel = queue.removeLast();
      final x = pixel.x;
      final y = pixel.y;

      if (x < 0 || y < 0 || x >= image.width || y >= image.height) {
        continue;
      }

      final index = y * image.width + x;

      if (!visited.add(index)) {
        continue;
      }

      final current = image.getPixel(x, y);

      final dr = (current.r.toInt() - targetR).abs();
      final dg = (current.g.toInt() - targetG).abs();
      final db = (current.b.toInt() - targetB).abs();

      if (dr > tolerance || dg > tolerance || db > tolerance) {
        continue;
      }

      image.setPixel(
        x,
        y,
        fillColor,
      );

      changed++;

      queue.add(_Pixel(x + 1, y));
      queue.add(_Pixel(x - 1, y));
      queue.add(_Pixel(x, y + 1));
      queue.add(_Pixel(x, y - 1));
    }

    return changed;
  }

  bool _isBackgroundPixel(
    img.Color pixel,
    int tolerance,
  ) {
    return pixel.r.toInt() >= 255 - tolerance &&
        pixel.g.toInt() >= 255 - tolerance &&
        pixel.b.toInt() >= 255 - tolerance;
  }

  _BackgroundComponent _collectBackgroundComponent({
    required img.Image image,
    required int startX,
    required int startY,
    required Set<int> visited,
    required int tolerance,
  }) {
    final queue = <_Pixel>[
      _Pixel(startX, startY),
    ];

    var pixelCount = 0;
    var touchesBorder = false;

    var minX = startX;
    var minY = startY;
    var maxX = startX;
    var maxY = startY;

    while (queue.isNotEmpty) {
      final pixel = queue.removeLast();
      final x = pixel.x;
      final y = pixel.y;

      if (x < 0 || y < 0 || x >= image.width || y >= image.height) {
        continue;
      }

      final index = y * image.width + x;

      if (!visited.add(index)) {
        continue;
      }

      final current = image.getPixel(x, y);

      if (!_isBackgroundPixel(current, tolerance)) {
        continue;
      }

      pixelCount++;

      if (x == 0 || y == 0 || x == image.width - 1 || y == image.height - 1) {
        touchesBorder = true;
      }

      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;

      queue.add(_Pixel(x + 1, y));
      queue.add(_Pixel(x - 1, y));
      queue.add(_Pixel(x, y + 1));
      queue.add(_Pixel(x, y - 1));
    }

    return _BackgroundComponent(
      seedX: startX,
      seedY: startY,
      pixelCount: pixelCount,
      touchesBorder: touchesBorder,
      minX: minX,
      minY: minY,
      maxX: maxX,
      maxY: maxY,
    );
  }
}

/// A colorable region detected inside a PNG line-art image.
class PngColoringRegion {
  const PngColoringRegion({
    required this.seedX,
    required this.seedY,
    required this.pixelCount,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final int seedX;
  final int seedY;
  final int pixelCount;
  final int left;
  final int top;
  final int right;
  final int bottom;

  int get width => right - left + 1;

  int get height => bottom - top + 1;
}

class _BackgroundComponent {
  const _BackgroundComponent({
    required this.seedX,
    required this.seedY,
    required this.pixelCount,
    required this.touchesBorder,
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  final int seedX;
  final int seedY;
  final int pixelCount;
  final bool touchesBorder;
  final int minX;
  final int minY;
  final int maxX;
  final int maxY;
}

class _Pixel {
  const _Pixel(
    this.x,
    this.y,
  );

  final int x;
  final int y;
}
