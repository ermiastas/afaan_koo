import 'package:flutter/material.dart';

import '../models/lesson_category.dart';
import '../widgets/lesson_card_large.dart';

class LessonListScreen extends StatelessWidget {
  final LessonCategory category;

  const LessonListScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = category.lessons;

    return Scaffold(
      appBar: AppBar(
        title: Text("${category.emoji} ${category.title}"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];


return LessonCardLarge(

  lesson: lesson,

  xp: 30,

  unlocked: true,


  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => lesson.screen,

      ),

    );

  },

);
        
        },
      ),
    );
  }
}