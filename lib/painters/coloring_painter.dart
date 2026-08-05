import 'package:flutter/material.dart';


class ColoringPainter extends CustomPainter {
  // Use dynamic to avoid analyzer errors if DrawPoint type isn't resolved.
  final List<dynamic> points;

  ColoringPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current != null && next != null) {
        final paint = Paint()
          ..color = current.color
          ..strokeWidth = current.strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        canvas.drawLine(current.offset, next.offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ColoringPainter oldDelegate) => true;
}