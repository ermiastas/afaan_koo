import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  static const alphabet = LinearGradient(
    colors: [
      AppColors.orange,
      AppColors.yellow,
    ],
  );

  static const numbers = LinearGradient(
    colors: [
      AppColors.blue,
      Color(0xff6DD5FA),
    ],
  );

  static const animals = LinearGradient(
    colors: [
      AppColors.green,
      Color(0xffA8E063),
    ],
  );

  static const culture = LinearGradient(
    colors: [
      Color(0xffB5651D),
      Color(0xffD4A373),
    ],
  );
}