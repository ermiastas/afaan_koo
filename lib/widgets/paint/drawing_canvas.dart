import 'package:flutter/material.dart';

import '../../models/drawing_point.dart';
import '../../models/paint_mode.dart';

/// Renders a sequence of paint strokes with smooth, connected lines.
class DrawingCanvas extends CustomPainter {
  const DrawingCanvas({
    required this.points,
    required this.backgroundColor,
  });

  final List<DrawingPoint?> points;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(backgroundColor, BlendMode.src);

    DrawingPoint? previous;
    for (final point in points) {
      if (point == null) {
        previous = null;
        continue;
      }

      if (point.sticker != null) {
        _drawSticker(canvas, point);
        previous = null;
        continue;
      }

      if (point.mode == PaintMode.glitter ||
          point.brushType.toString().toLowerCase().contains('magic')) {
        _drawGlitter(canvas, point.offset, point.paint);
        previous = point;
        continue;
      }

      final paint = point.paint;
      if (previous == null) {
        canvas.drawCircle(point.offset, paint.strokeWidth / 2, paint);
      } else {
        // A line plus a small end-cap gives smooth output while preserving
        // pressure/brush width carried by each sampled point.
        canvas.drawLine(previous.offset, point.offset, paint);
        canvas.drawCircle(point.offset, paint.strokeWidth / 2, paint);
      }
      previous = point;
    }
  }

  void _drawSticker(Canvas canvas, DrawingPoint point) {
    final painter = TextPainter(
      text: TextSpan(
        text: point.sticker,
        style: const TextStyle(fontSize: 40),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, point.offset - Offset(painter.width / 2, painter.height / 2));
  }

  void _drawGlitter(Canvas canvas, Offset position, Paint paint) {
    final glitterPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;
    for (var index = 0; index < 5; index++) {
      final dx = position.dx + (index * 3) - 6;
      final dy = position.dy + (index * 4) - 8;
      canvas.drawCircle(Offset(dx, dy), 2, glitterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingCanvas oldDelegate) =>
      oldDelegate.points != points || oldDelegate.backgroundColor != backgroundColor;
}
