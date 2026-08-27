import 'dart:math';

import 'package:flutter/material.dart';

import '../models/handwriting_stroke.dart';
import 'handwriting_utils.dart';

class TracingEngine {
  /// Scores both guide coverage and ink precision. The former implementation
  /// checked only guide control points, allowing short scribbles to pass.
  static double calculateAccuracy(
    List<Offset> drawing,
    List<HandwritingStroke> strokes,
    Size canvasSize,
  ) {
    if (canvasSize.width <= 0 || strokes.isEmpty) return 0;

    const baseSize = 400.0;
    final scale = canvasSize.width / baseSize;
    final ink = drawing
        .where((point) => point != Offset.infinite)
        .map((point) => Offset(point.dx / scale, point.dy / scale))
        .toList(growable: false);
    if (ink.length < 2) return 0;

    final guide = _sampleGuide(strokes);
    if (guide.isEmpty) return 0;

    const coverageTolerance = 28.0;
    const precisionTolerance = 34.0;
    final coverage = guide
            .where((target) => ink.any((point) =>
                HandwritingUtils.distance(point, target) <= coverageTolerance))
            .length /
        guide.length;
    final precision = ink
            .where((point) => guide.any((target) =>
                HandwritingUtils.distance(point, target) <= precisionTolerance))
            .length /
        ink.length;

    return (coverage * .72) + (precision * .28);
  }

  static List<Offset> _sampleGuide(List<HandwritingStroke> strokes) {
    final samples = <Offset>[];
    for (final stroke in strokes) {
      for (var index = 0; index < stroke.points.length - 1; index++) {
        final start = HandwritingUtils.toOffset(stroke.points[index]);
        final end = HandwritingUtils.toOffset(stroke.points[index + 1]);
        final steps =
            max(1, (HandwritingUtils.distance(start, end) / 12).ceil());
        for (var step = 0; step <= steps; step++) {
          samples.add(Offset.lerp(start, end, step / steps)!);
        }
      }
    }
    return samples;
  }
}
