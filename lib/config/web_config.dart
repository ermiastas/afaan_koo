import 'package:flutter/foundation.dart';

class WebConfig {
  static bool get isWeb => kIsWeb;

  static double get maxWidth {
    if (!kIsWeb) return double.infinity;
    return 1200;
  }

  static double responsiveWidth(double width) {
    if (!kIsWeb) return width;

    if (width > 1200) {
      return 1200;
    }

    return width;
  }
}