import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../models/educational_image_asset.dart';
import 'svg_safety_validator.dart';

class ImageVectorizationResult {
  const ImageVectorizationResult({
    required this.svg,
    required this.regionIds,
    required this.confidence,
    required this.width,
    required this.height,
    required this.validation,
  });

  final String svg;
  final List<String> regionIds;
  final double confidence;
  final int width;
  final int height;
  final SvgValidationResult validation;
}

/// Converts raster educational images into compact, safe SVG coloring pages.
///
/// Pipeline:
///
/// PNG/JPG/WebP
///      ↓
/// raster decoding
///      ↓
/// 96×96 logical grid
///      ↓
/// background detection
///      ↓
/// color quantization
///      ↓
/// connected-component segmentation
///      ↓
/// boundary extraction
///      ↓
/// polygon simplification
///      ↓
/// SVG path generation
///      ↓
/// SVG safety validation
///
/// The generated SVG contains only static vector paths.
/// No embedded raster images, scripts, external resources, animation,
/// JavaScript or HTML are allowed.
class ImageVectorizationService {
  ImageVectorizationService({
    SvgSafetyValidator? validator,
  }) : _validator = validator ?? const SvgSafetyValidator();

  static const int vectorizationVersion = 2;

  /// Logical rasterization grid.
  ///
  /// 96×96 gives a good balance between:
  /// - processing speed
  /// - SVG size
  /// - shape quality
  /// - mobile performance
  static const int _gridSize = 96;

  /// Maximum number of coloring regions.
  static const int _maxRegions = 40;

  /// Minimum component size.
  static const int _minimumRegionCells = 8;

  /// Background color distance threshold.
  static const double _backgroundThreshold = 52;

  /// Number of color buckets.
  ///
  /// Lower values produce larger regions.
  static const int _hueBuckets = 12;

  static const int _brightnessBuckets = 4;

  /// Maximum number of points retained after simplification.
  static const int _maximumPointsPerLoop = 500;

  /// Douglas-Peucker simplification tolerance.
  static const double _simplificationTolerance = 0.65;

  final SvgSafetyValidator _validator;

  Future<ImageVectorizationResult> vectorize({
    required EducationalImageAsset asset,
    required Uint8List bytes,
  }) async {
    if (!{
      ImageFormat.png,
      ImageFormat.jpg,
      ImageFormat.webp,
    }.contains(asset.format)) {
      throw UnsupportedError(
        'Only PNG, JPG, and WebP raster images can be converted to SVG.',
      );
    }

    final image = await _decode(bytes);

    try {
      final raw = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (raw == null) {
        throw StateError(
          'Could not access raster pixels for ${asset.id}.',
        );
      }

      final sourceWidth = image.width;
      final sourceHeight = image.height;

      if (sourceWidth <= 1 || sourceHeight <= 1) {
        throw StateError(
          'Image ${asset.id} is too small to vectorize.',
        );
      }

      final cells = _sampleAndClassify(
        raw.buffer.asUint8List(),
        sourceWidth: sourceWidth,
        sourceHeight: sourceHeight,
      );

      _removeSmallNoise(cells);

      final regions = _extractRegions(cells);

      if (regions.isEmpty) {
        throw StateError(
          'No colourable regions survived vectorization for ${asset.id}.',
        );
      }

      final svg = _buildSvg(
        asset: asset,
        regions: regions,
      );

      final validation = _validator.validate(svg);

      if (!validation.isValid) {
        throw StateError(
          'SVG validation failed for ${asset.id}: '
          '${validation.reason ?? 'unknown validation error'}',
        );
      }

      final coverage = _calculateCoverage(
        regions,
      );

      final confidence = _calculateConfidence(
        asset: asset,
        regions: regions,
        coverage: coverage,
      );

      return ImageVectorizationResult(
        svg: svg,
        regionIds: validation.regionIds,
        confidence: confidence,
        width: sourceWidth,
        height: sourceHeight,
        validation: validation,
      );
    } finally {
      image.dispose();
    }
  }

Future<ui.Image> _decode(Uint8List bytes) async {
  if (bytes.isEmpty) {
    throw StateError('Image data is empty.');
  }

  final codec = await ui.instantiateImageCodec(bytes);

  try {
    final frame = await codec.getNextFrame();
    return frame.image;
  } finally {
    codec.dispose();
  }
}

  // ---------------------------------------------------------------------------
  // RASTER SAMPLING
  // ---------------------------------------------------------------------------

  List<_Cell> _sampleAndClassify(
    Uint8List pixels, {
    required int sourceWidth,
    required int sourceHeight,
  }) {
    final sampled = <_Cell>[];

    final borderColors = <_Rgba>[];

    for (var y = 0; y < _gridSize; y++) {
      for (var x = 0; x < _gridSize; x++) {
        final sx = ((x * (sourceWidth - 1)) /
                math.max(1, _gridSize - 1))
            .round();

        final sy = ((y * (sourceHeight - 1)) /
                math.max(1, _gridSize - 1))
            .round();

        final index = (sy * sourceWidth + sx) * 4;

        final rgba = _Rgba(
          pixels[index],
          pixels[index + 1],
          pixels[index + 2],
          pixels[index + 3],
        );

        if (x == 0 ||
            y == 0 ||
            x == _gridSize - 1 ||
            y == _gridSize - 1) {
          if (rgba.a > 20) {
            borderColors.add(rgba);
          }
        }

        sampled.add(
          _Cell(
            x: x,
            y: y,
            rgba: rgba,
          ),
        );
      }
    }

    final background = _detectBackground(borderColors);

    for (final cell in sampled) {
      final rgba = cell.rgba;

      if (rgba.a < 20) {
        cell.isForeground = false;
        continue;
      }

      final distance = rgba.distanceTo(background);

      if (distance <= _backgroundThreshold) {
        cell.isForeground = false;
        continue;
      }

      cell.isForeground = true;

      cell.bucket = _bucketFor(rgba);
    }

    return sampled;
  }

  _Rgba _detectBackground(
    List<_Rgba> borderColors,
  ) {
    if (borderColors.isEmpty) {
      return const _Rgba(
        255,
        255,
        255,
        255,
      );
    }

    // Instead of a simple average, choose the most common coarse
    // border color. This handles white backgrounds much better when
    // the image contains colorful objects touching the border.
    final buckets = <int, List<_Rgba>>{};

    for (final color in borderColors) {
      final key =
          ((color.r ~/ 16) << 16) |
          ((color.g ~/ 16) << 8) |
          (color.b ~/ 16);

      buckets.putIfAbsent(
        key,
        () => <_Rgba>[],
      ).add(color);
    }

    List<_Rgba>? largest;

    for (final group in buckets.values) {
      if (largest == null || group.length > largest.length) {
        largest = group;
      }
    }

    return _average(
      largest ?? borderColors,
    );
  }

  _Rgba _average(
    Iterable<_Rgba> colors,
  ) {
    var r = 0;
    var g = 0;
    var b = 0;
    var a = 0;
    var count = 0;

    for (final color in colors) {
      r += color.r;
      g += color.g;
      b += color.b;
      a += color.a;
      count++;
    }

    if (count == 0) {
      return const _Rgba(
        255,
        255,
        255,
        255,
      );
    }

    return _Rgba(
      r ~/ count,
      g ~/ count,
      b ~/ count,
      a ~/ count,
    );
  }

  // ---------------------------------------------------------------------------
  // COLOR QUANTIZATION
  // ---------------------------------------------------------------------------

  int _bucketFor(
    _Rgba color,
  ) {
    final maxChannel = math.max(
      color.r,
      math.max(
        color.g,
        color.b,
      ),
    );

    final minChannel = math.min(
      color.r,
      math.min(
        color.g,
        color.b,
      ),
    );

    final brightness =
        ((color.r + color.g + color.b) / 3).floor();

    final saturationRange =
        maxChannel - minChannel;

    // Neutral colors:
    // black, grey, white-ish areas.
    if (saturationRange < 24) {
      final neutralBrightness =
          (brightness ~/ 64).clamp(
        0,
        3,
      );

      return 100 + neutralBrightness;
    }

    final hue = _hue(color);

    final hueBucket =
        ((hue / 360) * _hueBuckets)
            .floor()
            .clamp(
              0,
              _hueBuckets - 1,
            );

    final brightnessBucket =
        (brightness ~/ 64).clamp(
      0,
      _brightnessBuckets - 1,
    );

    return hueBucket +
        brightnessBucket * _hueBuckets;
  }

  int _hue(
    _Rgba color,
  ) {
    final r = color.r / 255;
    final g = color.g / 255;
    final b = color.b / 255;

    final maxChannel = math.max(
      r,
      math.max(
        g,
        b,
      ),
    );

    final minChannel = math.min(
      r,
      math.min(
        g,
        b,
      ),
    );

    if (maxChannel == minChannel) {
      return 0;
    }

    final delta = maxChannel - minChannel;

    double hue;

    if (maxChannel == r) {
      hue = 60 * ((g - b) / delta);

      if (hue < 0) {
        hue += 360;
      }
    } else if (maxChannel == g) {
      hue = 60 * ((b - r) / delta + 2);
    } else {
      hue = 60 * ((r - g) / delta + 4);
    }

    return hue.round().clamp(
          0,
          359,
        );
  }

  // ---------------------------------------------------------------------------
  // NOISE REMOVAL
  // ---------------------------------------------------------------------------

void _removeSmallNoise(List<_Cell> cells) {
  final foreground = <_Cell>[];

  for (final cell in cells) {
    if (cell.isForeground) {
      foreground.add(cell);
    }
  }

  // Do not aggressively delete thin structures.
  //
  // Fruits, leaves, stems, letters and other educational illustrations
  // can contain narrow areas that would otherwise disappear.
  //
  // We only remove completely isolated pixels.
  for (final cell in foreground) {
    var neighbours = 0;

    for (final point in _neighbourPositions(cell)) {
      final parts = point.split(':');

      final x = int.parse(parts[0]);
      final y = int.parse(parts[1]);

      if (x < 0 ||
          x >= _gridSize ||
          y < 0 ||
          y >= _gridSize) {
        continue;
      }

      final neighbour =
          cells[y * _gridSize + x];

      if (neighbour.isForeground) {
        neighbours++;
      }
    }

    if (neighbours == 0) {
      cell.isForeground = false;
    }
  }
}


Iterable<String> _neighbourPositions(_Cell cell) sync* {
  const directions = <(int, int)>[
    (1, 0),
    (-1, 0),
    (0, 1),
    (0, -1),
  ];

  for (final direction in directions) {
    final x = cell.x + direction.$1;
    final y = cell.y + direction.$2;

    if (x >= 0 &&
        x < _gridSize &&
        y >= 0 &&
        y < _gridSize) {
      yield '$x:$y';
    }
  }
}
  // ---------------------------------------------------------------------------
  // REGION EXTRACTION
  // ---------------------------------------------------------------------------

  List<_Region> _extractRegions(
    List<_Cell> cells,
  ) {
    final components = _findComponents(
      cells,
      minimumSize: _minimumRegionCells,
    );

    final regions = <_Region>[];

    for (final component in components) {
      final boundaryLoops = _extractBoundaryLoops(
        component,
      );

      if (boundaryLoops.isEmpty) {
        continue;
      }

      final simplifiedLoops = <List<_Point>>[];

      for (final loop in boundaryLoops) {
        if (loop.length < 3) {
          continue;
        }

        final simplified = _simplifyClosedLoop(
          loop,
          tolerance: _simplificationTolerance,
        );

        if (simplified.length >= 3) {
          simplifiedLoops.add(simplified);
        }
      }

      if (simplifiedLoops.isEmpty) {
        continue;
      }

      regions.add(
        _Region(
          cells: component,
          loops: simplifiedLoops,
          bucket: component.first.bucket,
        ),
      );
    }

    regions.sort(
      (a, b) => b.cells.length.compareTo(
        a.cells.length,
      ),
    );

    return regions
        .take(_maxRegions)
        .toList(growable: false);
  }

  List<List<_Cell>> _findComponents(
    List<_Cell> cells, {
    required int minimumSize,
  }) {
    final byPosition = <String, _Cell>{
      for (final cell in cells)
        _positionKey(
          cell.x,
          cell.y,
        ): cell,
    };

    final visited = <_Cell>{};
    final components = <List<_Cell>>[];

    for (final cell in cells) {
      if (!cell.isForeground) {
        continue;
      }

      if (visited.contains(cell)) {
        continue;
      }

      final stack = <_Cell>[cell];
      final component = <_Cell>[];

      visited.add(cell);

      while (stack.isNotEmpty) {
        final current = stack.removeLast();

        component.add(current);

        for (final neighbour in _neighbours(
          current,
        )) {
          final next = byPosition[
            _positionKey(
              neighbour.x,
              neighbour.y,
            )
          ];

          if (next == null) {
            continue;
          }

          if (!next.isForeground) {
            continue;
          }

          if (next.bucket != current.bucket) {
            continue;
          }

          if (visited.add(next)) {
            stack.add(next);
          }
        }
      }

      if (component.length >= minimumSize) {
        components.add(component);
      }
    }

    return components;
  }

  Iterable<_Cell> _neighbours(
    _Cell cell,
  ) sync* {
    yield _Cell(
      x: cell.x + 1,
      y: cell.y,
      rgba: cell.rgba,
    );

    yield _Cell(
      x: cell.x - 1,
      y: cell.y,
      rgba: cell.rgba,
    );

    yield _Cell(
      x: cell.x,
      y: cell.y + 1,
      rgba: cell.rgba,
    );

    yield _Cell(
      x: cell.x,
      y: cell.y - 1,
      rgba: cell.rgba,
    );
  }

  String _positionKey(
    int x,
    int y,
  ) {
    return '$x:$y';
  }

  // ---------------------------------------------------------------------------
  // BOUNDARY EXTRACTION
  // ---------------------------------------------------------------------------

  List<List<_Point>> _extractBoundaryLoops(
    List<_Cell> component,
  ) {
    final occupied = <String>{
      for (final cell in component)
        _positionKey(
          cell.x,
          cell.y,
        ),
    };

    final edges = <_BoundaryEdge>[];

    for (final cell in component) {
      final x = cell.x.toDouble();
      final y = cell.y.toDouble();

      // Top
      if (!occupied.contains(
        _positionKey(
          cell.x,
          cell.y - 1,
        ),
      )) {
        edges.add(
          _BoundaryEdge(
            _Point(x, y),
            _Point(x + 1, y),
          ),
        );
      }

      // Right
      if (!occupied.contains(
        _positionKey(
          cell.x + 1,
          cell.y,
        ),
      )) {
        edges.add(
          _BoundaryEdge(
            _Point(x + 1, y),
            _Point(x + 1, y + 1),
          ),
        );
      }

      // Bottom
      if (!occupied.contains(
        _positionKey(
          cell.x,
          cell.y + 1,
        ),
      )) {
        edges.add(
          _BoundaryEdge(
            _Point(x + 1, y + 1),
            _Point(x, y + 1),
          ),
        );
      }

      // Left
      if (!occupied.contains(
        _positionKey(
          cell.x - 1,
          cell.y,
        ),
      )) {
        edges.add(
          _BoundaryEdge(
            _Point(x, y + 1),
            _Point(x, y),
          ),
        );
      }
    }

    return _stitchBoundaryEdges(
      edges,
    );
  }

  List<List<_Point>> _stitchBoundaryEdges(
    List<_BoundaryEdge> edges,
  ) {
    final remaining = <_BoundaryEdge>[
      ...edges,
    ];

    final loops = <List<_Point>>[];

    while (remaining.isNotEmpty) {
      final first = remaining.removeAt(
        remaining.length - 1,
      );

      final loop = <_Point>[
        first.start,
        first.end,
      ];

      var current = first.end;

      while (!_samePoint(
        current,
        first.start,
      )) {
        final index = remaining.indexWhere(
          (edge) => _samePoint(
            edge.start,
            current,
          ),
        );

        if (index == -1) {
          break;
        }

        final next = remaining.removeAt(
          index,
        );

        current = next.end;

        if (!_samePoint(
          loop.last,
          current,
        )) {
          loop.add(current);
        }

        if (loop.length >
            edges.length + 2) {
          break;
        }
      }

      if (loop.length >= 4 &&
          _samePoint(
            loop.first,
            loop.last,
          )) {
        loop.removeLast();

        loops.add(loop);
      }
    }

    return loops;
  }

  bool _samePoint(
    _Point a,
    _Point b,
  ) {
    return a.x == b.x && a.y == b.y;
  }

  // ---------------------------------------------------------------------------
  // POLYGON SIMPLIFICATION
  // ---------------------------------------------------------------------------

  List<_Point> _simplifyClosedLoop(
    List<_Point> points, {
    required double tolerance,
  }) {
    if (points.length <= 3) {
      return points;
    }

    final open = <_Point>[
      ...points,
      points.first,
    ];

    final simplified = _douglasPeucker(
      open,
      tolerance,
    );

    if (simplified.length > 1 &&
        _samePoint(
          simplified.first,
          simplified.last,
        )) {
      simplified.removeLast();
    }

    if (simplified.length >
        _maximumPointsPerLoop) {
      return _resampleLoop(
        simplified,
        _maximumPointsPerLoop,
      );
    }

    return simplified;
  }

  List<_Point> _douglasPeucker(
    List<_Point> points,
    double epsilon,
  ) {
    if (points.length < 3) {
      return List<_Point>.from(points);
    }

    var maxDistance = 0.0;
    var index = 0;

    final first = points.first;
    final last = points.last;

    for (var i = 1; i < points.length - 1; i++) {
      final distance = _perpendicularDistance(
        points[i],
        first,
        last,
      );

      if (distance > maxDistance) {
        maxDistance = distance;
        index = i;
      }
    }

    if (maxDistance > epsilon) {
      final left = _douglasPeucker(
        points.sublist(
          0,
          index + 1,
        ),
        epsilon,
      );

      final right = _douglasPeucker(
        points.sublist(
          index,
        ),
        epsilon,
      );

      return <_Point>[
        ...left.take(
          math.max(
            0,
            left.length - 1,
          ),
        ),
        ...right,
      ];
    }

    return <_Point>[
      first,
      last,
    ];
  }

  double _perpendicularDistance(
    _Point point,
    _Point lineStart,
    _Point lineEnd,
  ) {
    final dx = lineEnd.x - lineStart.x;
    final dy = lineEnd.y - lineStart.y;

    if (dx == 0 && dy == 0) {
      return _distance(
        point,
        lineStart,
      );
    }

    final numerator =
        (dy * point.x) -
        (dx * point.y) +
        (lineEnd.x * lineStart.y) -
        (lineEnd.y * lineStart.x);

    return numerator.abs() /
        math.sqrt(
          dx * dx + dy * dy,
        );
  }

  double _distance(
    _Point a,
    _Point b,
  ) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;

    return math.sqrt(
      dx * dx + dy * dy,
    );
  }

  List<_Point> _resampleLoop(
    List<_Point> points,
    int maximum,
  ) {
    if (points.length <= maximum) {
      return points;
    }

    final result = <_Point>[];

    final step =
        points.length / maximum;

    for (var i = 0; i < maximum; i++) {
      final index =
          (i * step).floor().clamp(
                0,
                points.length - 1,
              );

      result.add(
        points[index],
      );
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // SVG GENERATION
  // ---------------------------------------------------------------------------

  String _buildSvg({
    required EducationalImageAsset asset,
    required List<_Region> regions,
  }) {
    final idPrefix = _safeId(
      asset.id,
    );

    final buffer = StringBuffer();

    buffer.write(
      '<svg '
      'xmlns="http://www.w3.org/2000/svg" '
      'viewBox="0 0 $_gridSize $_gridSize" '
      'width="$_gridSize" '
      'height="$_gridSize">',
    );

    for (var index = 0;
        index < regions.length;
        index++) {
      final region = regions[index];

      if (region.loops.isEmpty) {
        continue;
      }

      final id =
          '${idPrefix}_region_${index + 1}';

      final pathData =
          _buildPathData(
        region.loops,
      );

      if (pathData.isEmpty) {
        continue;
      }

      buffer.write(
        '<path '
        'id="$id" '
        'fill="#FFFFFF" '
        'stroke="#1D1D1D" '
        'stroke-width="0.7" '
        'stroke-linejoin="round" '
        'stroke-linecap="round" '
        'fill-rule="evenodd" '
        'd="$pathData"/>',
      );
    }

    buffer.write(
      '</svg>',
    );

    return buffer.toString();
  }

  String _buildPathData(
    List<List<_Point>> loops,
  ) {
    final buffer = StringBuffer();

    for (final loop in loops) {
      if (loop.length < 3) {
        continue;
      }

      buffer.write(
        'M${_number(loop.first.x)} '
        '${_number(loop.first.y)} ',
      );

      for (var i = 1;
          i < loop.length;
          i++) {
        final point = loop[i];

        buffer.write(
          'L${_number(point.x)} '
          '${_number(point.y)} ',
        );
      }

      buffer.write(
        'Z ',
      );
    }

    return buffer.toString().trim();
  }

  String _number(
    double value,
  ) {
    if (value == value.roundToDouble()) {
      return value
          .round()
          .toString();
    }

    return value
        .toStringAsFixed(2)
        .replaceFirst(
          RegExp(r'0+$'),
          '',
        )
        .replaceFirst(
          RegExp(r'\.$'),
          '',
        );
  }

  String _safeId(
    String value,
  ) {
    final sanitized = value.replaceAll(
      RegExp(
        r'[^a-zA-Z0-9_-]',
      ),
      '_',
    );

    if (sanitized.isEmpty) {
      return 'image';
    }

    if (RegExp(r'^[0-9]').hasMatch(
      sanitized,
    )) {
      return 'image_$sanitized';
    }

    return sanitized;
  }

  // ---------------------------------------------------------------------------
  // QUALITY / CONFIDENCE
  // ---------------------------------------------------------------------------

  double _calculateCoverage(
    List<_Region> regions,
  ) {
    final cells = regions.fold<int>(
      0,
      (sum, region) =>
          sum + region.cells.length,
    );

    return cells /
        (_gridSize * _gridSize);
  }

  double _calculateConfidence({
    required EducationalImageAsset asset,
    required List<_Region> regions,
    required double coverage,
  }) {
    final regionScore =
        math.min(
          1.0,
          regions.length / 8,
        );

    final coverageScore =
        coverage > 0.02
            ? math.min(
                1.0,
                coverage / 0.35,
              )
            : 0.0;

    final sourceConfidence =
        asset.conversionConfidence.clamp(
      0.0,
      1.0,
    );

    final score =
        sourceConfidence * 0.35 +
        regionScore * 0.35 +
        coverageScore * 0.30;

    return score.clamp(
      0.0,
      1.0,
    );
  }
}

// ============================================================================
// INTERNAL DATA TYPES
// ============================================================================

class _Rgba {
  const _Rgba(
    this.r,
    this.g,
    this.b,
    this.a,
  );

  final int r;
  final int g;
  final int b;
  final int a;

  double distanceTo(
    _Rgba other,
  ) {
    final dr = r - other.r;
    final dg = g - other.g;
    final db = b - other.b;

    return math.sqrt(
      dr * dr +
          dg * dg +
          db * db,
    );
  }
}

class _Cell {
  _Cell({
    required this.x,
    required this.y,
    required this.rgba,
  });

  final int x;
  final int y;
  final _Rgba rgba;

  bool isForeground = false;

  int bucket = -1;
}

class _Region {
  const _Region({
    required this.cells,
    required this.loops,
    required this.bucket,
  });

  final List<_Cell> cells;
  final List<List<_Point>> loops;
  final int bucket;
}

class _Point {
  const _Point(
    this.x,
    this.y,
  );

  final double x;
  final double y;
}

class _BoundaryEdge {
  const _BoundaryEdge(
    this.start,
    this.end,
  );

  final _Point start;
  final _Point end;
}