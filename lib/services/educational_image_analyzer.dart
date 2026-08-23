import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../models/educational_image_asset.dart';

class EducationalImageAnalysis {
  const EducationalImageAnalysis({
    required this.width,
    required this.height,
    required this.colorCount,
    required this.hasTransparency,
    required this.contentFingerprint,
    required this.perceptualHash,
    required this.isColoringCandidate,
    required this.confidence,
    required this.reason,
  });

  final int width;
  final int height;
  final int colorCount;
  final bool hasTransparency;
  final String contentFingerprint;
  final String perceptualHash;
  final bool isColoringCandidate;
  final double confidence;
  final String reason;
}

/// A deliberately local, explainable candidate scorer.  It avoids making a
/// network request or calling an AI service just to open the colouring book.
class EducationalImageAnalyzer {
  const EducationalImageAnalyzer();

  Future<EducationalImageAnalysis> analyze({
    required EducationalImageAsset asset,
    required Uint8List bytes,
  }) async {
    final image = await _decode(bytes);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (data == null) {
        throw StateError('Image pixels are unavailable');
      }
      final pixels = data.buffer.asUint8List();
      final sample = _samplePixels(pixels, image.width, image.height);
      final pathScore = _pathScore(asset.sourcePath, asset.category);
      final detailPenalty = _detailPenalty(sample);
      final confidence = (pathScore -
              detailPenalty +
              (sample.hasTransparency ? 0.08 : 0) +
              (sample.colorCount < 40 ? 0.08 : 0))
          .clamp(0.0, 1.0);
      final candidate = confidence >= 0.58 && !_isExcluded(asset.sourcePath);
      return EducationalImageAnalysis(
        width: image.width,
        height: image.height,
        colorCount: sample.colorCount,
        hasTransparency: sample.hasTransparency,
        contentFingerprint: _fingerprint(bytes),
        perceptualHash: sample.perceptualHash,
        isColoringCandidate: candidate,
        confidence: confidence,
        reason: candidate
            ? _candidateReason(asset, sample)
            : _excludedReason(asset.sourcePath, sample),
      );
    } finally {
      image.dispose();
    }
  }

  Future<ui.Image> _decode(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }

  _PixelSummary _samplePixels(Uint8List pixels, int width, int height) {
    const grid = 32;
    final colors = <int>{};
    final brightness = <int>[];
    var transparent = 0;
    final hashBits = StringBuffer();
    final smallBrightness = <int>[];
    for (var y = 0; y < grid; y++) {
      for (var x = 0; x < grid; x++) {
        final sourceX = (x * (width - 1) / (grid - 1)).round();
        final sourceY = (y * (height - 1) / (grid - 1)).round();
        final index = (sourceY * width + sourceX) * 4;
        final r = pixels[index];
        final g = pixels[index + 1];
        final b = pixels[index + 2];
        final a = pixels[index + 3];
        if (a < 24) transparent++;
        final level = ((r * 0.299) + (g * 0.587) + (b * 0.114)).round();
        brightness.add(level);
        colors.add(((r ~/ 32) << 6) | ((g ~/ 32) << 3) | (b ~/ 32));
        if (x % 4 == 0 && y % 4 == 0) smallBrightness.add(level);
      }
    }
    final mean =
        smallBrightness.reduce((a, b) => a + b) / smallBrightness.length;
    for (final value in smallBrightness) {
      hashBits.write(value >= mean ? '1' : '0');
    }
    return _PixelSummary(
      colorCount: colors.length,
      hasTransparency: transparent > grid,
      averageContrast: _contrast(brightness),
      perceptualHash: hashBits.toString(),
    );
  }

  double _contrast(List<int> values) {
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values
            .map((value) => (value - mean) * (value - mean))
            .reduce((a, b) => a + b) /
        values.length;
    return variance.sqrt() / 128;
  }

  double _detailPenalty(_PixelSummary summary) {
    var penalty = 0.0;
    if (summary.colorCount > 110) penalty += 0.22;
    if (summary.averageContrast > 0.78) penalty += 0.12;
    return penalty;
  }

  double _pathScore(String path, String? category) {
    final text = '$path ${category ?? ''}'.toLowerCase();
    if (_isExcluded(text)) return 0.05;
    if (RegExp(r'animals?|fruits?|vegetables?|plants?|alphabet|numbers?|'
            r'food|transport|traffic|occupation|clothing|body|school|'
            r'family|culture|weather|shapes?|coloring')
        .hasMatch(text)) {
      return 0.82;
    }
    if (text.contains('stories') || text.contains('words')) return 0.66;
    return 0.48;
  }

  bool _isExcluded(String path) => RegExp(
        r'(logo|icon|badge|card|background|splash|thumbnail|screenshot|ui/|videos?)',
        caseSensitive: false,
      ).hasMatch(path);

  String _candidateReason(EducationalImageAsset asset, _PixelSummary summary) {
    final topic = asset.category ?? 'educational';
    if (summary.hasTransparency) {
      return 'clear $topic illustration with a transparent background';
    }
    if (summary.colorCount < 40) {
      return 'simple $topic illustration with limited colours';
    }
    return 'educational $topic image with colourable object boundaries';
  }

  String _excludedReason(String path, _PixelSummary summary) {
    if (_isExcluded(path)) {
      return 'decorative, UI, badge, logo, or video asset';
    }
    if (summary.colorCount > 110) {
      return 'high colour detail is more photograph-like';
    }
    return 'not enough evidence that this image is a child-friendly object';
  }

  String _fingerprint(Uint8List bytes) {
    // FNV-1a: deterministic, quick, and sufficient for local deduplication.
    var hash = 0x811c9dc5;
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}

class _PixelSummary {
  const _PixelSummary({
    required this.colorCount,
    required this.hasTransparency,
    required this.averageContrast,
    required this.perceptualHash,
  });

  final int colorCount;
  final bool hasTransparency;
  final double averageContrast;
  final String perceptualHash;
}

extension on double {
  double sqrt() {
    if (this <= 0) return 0;
    var guess = this;
    for (var i = 0; i < 12; i++) {
      guess = (guess + this / guess) / 2;
    }
    return guess;
  }
}
