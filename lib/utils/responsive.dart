import 'package:flutter/material.dart';

/// Central responsive design system for AfaanKoo.
///
/// Designed for:
/// - Smartwatch-sized displays
/// - Small phones
/// - Normal phones
/// - Tablets
/// - Laptops
/// - Desktop monitors
/// - Android/Smart TV-sized displays
///
/// The goal is to keep layouts readable, touch-friendly, and free from
/// overflow while allowing each screen to progressively use more space.
class Responsive {
  Responsive._();

  // ==============================================================
  // BREAKPOINTS
  // ==============================================================

  /// Extremely small / watch-sized layout.
  static const double watchBreakpoint = 280;

  /// Small phone.
  static const double phoneBreakpoint = 420;

  /// Large phone / small tablet.
  static const double tabletBreakpoint = 700;

  /// Tablet / small laptop.
  static const double desktopBreakpoint = 1000;

  /// Large desktop.
  static const double largeDesktopBreakpoint = 1400;

  /// Very large display / TV.
  static const double tvBreakpoint = 1800;

  // Existing compatibility breakpoints.
  static const double tinyBreakpoint = watchBreakpoint;
  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 900;

  /// Maximum width for normal reading/content layouts.
  static const double maxContentWidth = 1400;

  /// Maximum width for very wide TV layouts.
  static const double maxTvContentWidth = 1800;

  // ==============================================================
  // DEVICE CLASSIFICATION
  // ==============================================================

  /// True for very small displays such as watch-sized layouts.
  static bool isWatch(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.shortestSide < watchBreakpoint;
  }

  /// True for phone-sized layouts.
  static bool isPhone(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;

    return shortestSide >= watchBreakpoint && shortestSide < tabletBreakpoint;
  }

  /// True for tablet-sized layouts.
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;

    return shortestSide >= tabletBreakpoint && shortestSide < desktopBreakpoint;
  }

  /// True for desktop/laptop-sized layouts.
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= desktopBreakpoint && width < tvBreakpoint;
  }

  /// True for large TV/very-wide displays.
  static bool isTV(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= tvBreakpoint;
  }

  /// General-purpose device category.
  static ResponsiveDeviceType deviceType(
    BuildContext context,
  ) {
    if (isWatch(context)) {
      return ResponsiveDeviceType.watch;
    }

    if (isPhone(context)) {
      return ResponsiveDeviceType.phone;
    }

    if (isTablet(context)) {
      return ResponsiveDeviceType.tablet;
    }

    if (isTV(context)) {
      return ResponsiveDeviceType.tv;
    }

    return ResponsiveDeviceType.desktop;
  }

  // ==============================================================
  // LEGACY / COMPATIBILITY HELPERS
  // ==============================================================

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  static bool isTiny(BuildContext context) => isWatch(context);

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= compactBreakpoint && width < mediumBreakpoint;
  }

  // ==============================================================
  // SCREEN DIMENSIONS
  // ==============================================================

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static Size size(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  /// Shortest dimension is useful for deciding whether a display is
  /// genuinely small, regardless of portrait/landscape orientation.
  static double shortestSide(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide;
  }

  // ==============================================================
  // PADDING
  // ==============================================================

  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (isWatch(context)) {
      return 8;
    }

    if (width < phoneBreakpoint) {
      return 12;
    }

    if (width < tabletBreakpoint) {
      return 16;
    }

    if (width < desktopBreakpoint) {
      return 24;
    }

    if (width < largeDesktopBreakpoint) {
      return 32;
    }

    if (width < tvBreakpoint) {
      return 48;
    }

    return 64;
  }

  static double horizontalPadding(BuildContext context) {
    return pagePadding(context);
  }

  static double verticalPadding(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    if (isWatch(context)) {
      return 6;
    }

    if (height < 500) {
      return 10;
    }

    if (height < 800) {
      return 16;
    }

    return pagePadding(context);
  }

  // ==============================================================
  // CONTENT WIDTH
  // ==============================================================

  /// Appropriate maximum content width for the current display.
  static double contentMaxWidth(BuildContext context) {
    if (isTV(context)) {
      return maxTvContentWidth;
    }

    return maxContentWidth;
  }

  /// Returns a safe content width after applying page margins.
  static double availableContentWidth(
    BuildContext context,
  ) {
    final width = MediaQuery.sizeOf(context).width;

    return (width - pagePadding(context) * 2)
        .clamp(0.0, contentMaxWidth(context))
        .toDouble();
  }

  static Widget centeredContent({
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? maxContentWidth,
        ),
        child: child,
      ),
    );
  }

  // ==============================================================
  // GRID COLUMNS
  // ==============================================================

  /// Calculates columns from the available width and desired tile width.
  ///
  /// This is preferable to hard-coded screen-width conditions for
  /// content-heavy screens.
  static int gridColumns(
    BuildContext context, {
    double minimumTileWidth = 170,
    int min = 1,
    int max = 8,
  }) {
    final availableWidth = availableContentWidth(context);

    if (isWatch(context)) {
      return 1;
    }

    final columns = (availableWidth / minimumTileWidth).floor();

    final minimum = isWatch(context) ? 1 : min;

    return columns
        .clamp(
          minimum,
          max,
        )
        .toInt();
  }

  /// Standard AfaanKoo lesson/content progression.
  ///
  /// Watch       → 1
  /// Small phone → 2
  /// Phone       → 3
  /// Tablet      → 4
  /// Desktop     → 5
  /// Large       → 6
  /// TV          → 7–8
  static int homeColumns(
    BuildContext context, {
    int min = 1,
    int max = 8,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    final int columns;

    if (isWatch(context)) {
      columns = 1;
    } else if (width < phoneBreakpoint) {
      columns = 2;
    } else if (width < tabletBreakpoint) {
      columns = 3;
    } else if (width < desktopBreakpoint) {
      columns = 4;
    } else if (width < largeDesktopBreakpoint) {
      columns = 5;
    } else if (width < tvBreakpoint) {
      columns = 6;
    } else {
      columns = 8;
    }

    return columns.clamp(min, max).toInt();
  }

  // ==============================================================
  // GRID SPACING
  // ==============================================================

  static double gridSpacing(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (isWatch(context)) {
      return 6;
    }

    if (width < phoneBreakpoint) {
      return 8;
    }

    if (width < tabletBreakpoint) {
      return 10;
    }

    if (width < desktopBreakpoint) {
      return 12;
    }

    if (width < largeDesktopBreakpoint) {
      return 16;
    }

    return 20;
  }

  static double cardSpacing(BuildContext context) {
    return gridSpacing(context);
  }

  // ==============================================================
  // GRID DELEGATE
  // ==============================================================

  static SliverGridDelegateWithFixedCrossAxisCount homeGridDelegate(
    BuildContext context, {
    double childAspectRatio = .82,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    int minColumns = 1,
    int maxColumns = 8,
  }) {
    final spacing = gridSpacing(context);

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: homeColumns(
        context,
        min: minColumns,
        max: maxColumns,
      ),
      crossAxisSpacing: crossAxisSpacing ?? spacing,
      mainAxisSpacing: mainAxisSpacing ?? spacing,
      childAspectRatio: childAspectRatio,
    );
  }

  // ==============================================================
  // CARD SIZING
  // ==============================================================

  static double cardRadius(BuildContext context) {
    if (isWatch(context)) {
      return 14;
    }

    if (isPhone(context)) {
      return 18;
    }

    if (isTablet(context)) {
      return 20;
    }

    if (isTV(context)) {
      return 30;
    }

    return 24;
  }

  static double cardPadding(BuildContext context) {
    if (isWatch(context)) {
      return 6;
    }

    if (isPhone(context)) {
      return 10;
    }

    if (isTablet(context)) {
      return 14;
    }

    if (isTV(context)) {
      return 22;
    }

    return 16;
  }

  // ==============================================================
  // TYPOGRAPHY
  // ==============================================================

  static double titleSize(BuildContext context) {
    if (isWatch(context)) {
      return 14;
    }

    if (isPhone(context)) {
      return 20;
    }

    if (isTablet(context)) {
      return 24;
    }

    if (isTV(context)) {
      return 36;
    }

    return 30;
  }

  static double subtitleSize(BuildContext context) {
    if (isWatch(context)) {
      return 10;
    }

    if (isPhone(context)) {
      return 15;
    }

    if (isTablet(context)) {
      return 18;
    }

    if (isTV(context)) {
      return 25;
    }

    return 20;
  }

  static double bodySize(BuildContext context) {
    if (isWatch(context)) {
      return 10;
    }

    if (isPhone(context)) {
      return 14;
    }

    if (isTablet(context)) {
      return 16;
    }

    if (isTV(context)) {
      return 22;
    }

    return 18;
  }

  static double iconSize(BuildContext context) {
    if (isWatch(context)) {
      return 18;
    }

    if (isPhone(context)) {
      return 24;
    }

    if (isTablet(context)) {
      return 28;
    }

    if (isTV(context)) {
      return 40;
    }

    return 32;
  }

  /// Child-friendly touch target.
  ///
  /// TV controls need larger targets because users interact from farther
  /// away. Watch controls are constrained by the available display.
  static double touchTarget(BuildContext context) {
    if (isWatch(context)) {
      return 36;
    }

    if (isPhone(context)) {
      return 44;
    }

    if (isTablet(context)) {
      return 48;
    }

    if (isTV(context)) {
      return 64;
    }

    return 48;
  }

  // ==============================================================
  // ASPECT RATIO
  // ==============================================================

  static double cardAspectRatio(BuildContext context) {
    if (isWatch(context)) {
      return 1.0;
    }

    if (isPhone(context)) {
      return .82;
    }

    if (isTablet(context)) {
      return .85;
    }

    if (isTV(context)) {
      return 1.05;
    }

    return .90;
  }

  // ==============================================================
  // TRACING
  // ==============================================================

  static double tracingHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (isWatch(context)) {
      return (size.height * .38).clamp(150.0, 220.0).toDouble();
    }

    if (isTV(context)) {
      return (size.height * .55).clamp(400.0, 700.0).toDouble();
    }

    return (size.height * .46).clamp(260.0, 440.0).toDouble();
  }

  // ==============================================================
  // TEXT SCALING
  // ==============================================================

  static double clampFontSize(
    BuildContext context,
    double size, {
    double min = 12,
    double max = 32,
  }) {
    final scale = MediaQuery.textScalerOf(context).scale(1);

    return (size * scale).clamp(min, max).toDouble();
  }

  // ==============================================================
  // ORIENTATION
  // ==============================================================

  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return !isLandscape(context);
  }

  // ==============================================================
  // SAFE SCREEN AREA
  // ==============================================================

  static EdgeInsets safePadding(BuildContext context) {
    final mediaPadding = MediaQuery.paddingOf(context);

    return EdgeInsets.only(
      left: mediaPadding.left + pagePadding(context),
      right: mediaPadding.right + pagePadding(context),
      top: mediaPadding.top,
      bottom: mediaPadding.bottom,
    );
  }

  // ==============================================================
  // DEBUG INFORMATION
  // ==============================================================

  static String description(BuildContext context) {
    final type = deviceType(context);

    switch (type) {
      case ResponsiveDeviceType.watch:
        return 'watch';

      case ResponsiveDeviceType.phone:
        return 'phone';

      case ResponsiveDeviceType.tablet:
        return 'tablet';

      case ResponsiveDeviceType.desktop:
        return 'desktop';

      case ResponsiveDeviceType.tv:
        return 'tv';
    }
  }
}

/// Logical responsive device categories.
///
/// These describe layout needs rather than the actual physical hardware.
enum ResponsiveDeviceType {
  watch,
  phone,
  tablet,
  desktop,
  tv,
}
