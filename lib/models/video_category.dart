import 'package:flutter/material.dart';

class VideoCategory {
  final String id;

  final String title;

  final String emoji;

  final Color color;

  final String description;

  const VideoCategory({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.description,
  });
}