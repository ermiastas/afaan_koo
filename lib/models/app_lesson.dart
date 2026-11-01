import 'package:flutter/material.dart';

class AppLesson {
  final String id;
  final String title;
  final String description;
  final String category;
  final String emoji;
  final IconData? icon;
  final Color color;
  final String route;

  // Optional badge for reward system
  final String? badgeId;

  final List<int> ages;

  /// The downloadable content pack that provides this lesson.
  ///
  /// A null value means the lesson is part of the app's starter content.
  final String? packId;

  const AppLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
    this.icon,
    required this.color,
    required this.route,
    this.badgeId,
    required this.ages,
    this.packId,
  });
}
