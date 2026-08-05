import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const cardTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  static const sectionTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
}