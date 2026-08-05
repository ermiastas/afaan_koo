import 'package:flutter/material.dart';

/// Shared breakpoints and measurements for child-friendly layouts.
///
/// Keeping these values in one place prevents individual lessons from drifting
/// into fixed-width layouts that overflow on tablets, foldables, or the web.
class Responsive {
  Responsive._();

  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 900;
  static const double maxContentWidth = 1200;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= compactBreakpoint && width < mediumBreakpoint;
  }

  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= mediumBreakpoint) return 32;
    if (width >= compactBreakpoint) return 24;
    return 16;
  }

  static int gridColumns(
    BuildContext context, {
    double minimumTileWidth = 170,
    int min = 1,
    int max = 6,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / minimumTileWidth).floor().clamp(min, max).toInt();
  }

  static double tracingHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return (size.height * .46).clamp(260.0, 440.0).toDouble();
  }

  static double clampFontSize(
    BuildContext context,
    double size, {
    double min = 12,
    double max = 32,
  }) {
    final scale = MediaQuery.textScalerOf(context).textScaleFactor;
    return (size * scale).clamp(min, max).toDouble();
  }
}
