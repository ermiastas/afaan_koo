import 'package:flutter/material.dart';

/// Shared breakpoints and measurements for child-friendly layouts.
///
/// Keeping these values in one place prevents individual lessons from drifting
/// into fixed-width layouts that overflow on tablets, foldables, or the web.
class Responsive {
  Responsive._();

  /// These match the steps used by the home screen.  Reusing them keeps a
  /// lesson reachable on a small phone while taking advantage of tablets,
  /// desktop browsers and TVs.
  static const double tinyBreakpoint = 280;
  static const double phoneBreakpoint = 420;
  static const double tabletBreakpoint = 700;
  static const double desktopBreakpoint = 1000;
  static const double largeDesktopBreakpoint = 1400;
  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 900;
  static const double maxContentWidth = 1200;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  static bool isTiny(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tinyBreakpoint;

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= compactBreakpoint && width < mediumBreakpoint;
  }

  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < tinyBreakpoint) return 12;
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
    final availableWidth = width - (pagePadding(context) * 2);
    final columns = (availableWidth / minimumTileWidth).floor();

    // Keep narrow devices usable even where a screen normally requests two
    // columns. A single, legible card is better than an overflowing pair.
    final minimum = width < tinyBreakpoint ? 1 : min;
    return columns.clamp(minimum, max).toInt();
  }

  /// The standard column progression for browse and collection screens.
  /// It is intentionally the same progression as the home lesson grid.
  static int homeColumns(
    BuildContext context, {
    int min = 1,
    int max = 6,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < tinyBreakpoint
        ? 1
        : width < phoneBreakpoint
            ? 2
            : width < tabletBreakpoint
                ? 3
                : width < desktopBreakpoint
                    ? 4
                    : width < largeDesktopBreakpoint
                        ? 5
                        : 6;
    return columns.clamp(min, max).toInt();
  }

  /// A shared grid delegate for cards shown throughout the app.
  static SliverGridDelegateWithFixedCrossAxisCount homeGridDelegate(
    BuildContext context, {
    double childAspectRatio = .82,
    double crossAxisSpacing = 12,
    double mainAxisSpacing = 12,
    int minColumns = 1,
    int maxColumns = 6,
  }) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: homeColumns(
        context,
        min: minColumns,
        max: maxColumns,
      ),
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }

  /// Centres reading-oriented layouts on wide screens without reducing the
  /// usable width of games and canvases.
  static Widget centeredContent({
    required Widget child,
    double maxWidth = maxContentWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
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
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return (size * scale).clamp(min, max).toDouble();
  }
}
