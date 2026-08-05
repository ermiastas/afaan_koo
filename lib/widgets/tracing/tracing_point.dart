import 'package:flutter/material.dart';

/// Represents one normalized tracing point.
///
/// dx and dy are always between 0 and 1,
/// making tracing independent of screen size.
@immutable
class TracingPoint {
  final double dx;
  final double dy;

  const TracingPoint({
    required this.dx,
    required this.dy,
  });

  Offset toOffset(Size size) {
    return Offset(
      dx * size.width,
      dy * size.height,
    );
  }

  factory TracingPoint.fromOffset(
    Offset offset,
    Size size,
  ) {
    return TracingPoint(
      dx: offset.dx / size.width,
      dy: offset.dy / size.height,
    );
  }

  double distanceTo(TracingPoint other) {
    return (Offset(dx, dy) - Offset(other.dx, other.dy))
        .distance;
  }

  @override
  bool operator ==(Object other) {
    return other is TracingPoint &&
        dx == other.dx &&
        dy == other.dy;
  }

  @override
  int get hashCode => Object.hash(dx, dy);
}