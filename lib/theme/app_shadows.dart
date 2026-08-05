import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static BoxShadow soft(Color color) {
    return BoxShadow(
      color: color.withValues(alpha: 0.25),
      blurRadius: 20,
      offset: const Offset(0, 10),
    );
  }
}