import 'package:flutter/material.dart';

enum BrushType {
  pencil,
  crayon,
  marker,
  glitter,
  rainbow,
  eraser,
}

class DrawStroke {
  final Color color;
  final double width;
  final BrushType brush;

  final List<Offset> points;

  DrawStroke({
    required this.color,
    required this.width,
    required this.brush,
    required this.points,
  });
}