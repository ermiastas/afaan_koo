import 'package:flutter/material.dart';

import 'lesson_item.dart';


class LessonCategory {

  /// Category name
  final String title;


  /// Short description shown under title
  final String subtitle;


  /// Emoji illustration
  final String emoji;


  /// Category theme color
  final Color color;


  /// Lessons inside this category
  final List<LessonItem> lessons;



  const LessonCategory({

    required this.title,

    required this.subtitle,

    required this.emoji,

    required this.color,

    required this.lessons,

  });


  /// Total number of lessons
  int get lessonCount => lessons.length;


  /// Get completed lessons
  int completedLessons() {

    return lessons
        .where((lesson) => lesson.completed)
        .length;

  }


  /// Category progress percentage
  double get progress {

    if (lessons.isEmpty) {
      return 0;
    }


    return completedLessons() / lessons.length;

  }


  /// Check if all lessons completed
  bool get isCompleted {

    return lessons.isNotEmpty &&
        completedLessons() == lessons.length;

  }


}