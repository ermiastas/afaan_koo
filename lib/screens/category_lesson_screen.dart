import 'package:flutter/material.dart';

import '../models/lesson_category.dart';
import '../models/lesson_item.dart';
import '../utils/app_animations.dart';
import '../widgets/animations/animated_entrance.dart';
import '../utils/responsive.dart';

class CategoryLessonScreen extends StatelessWidget {
  final LessonCategory category;

  const CategoryLessonScreen({
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
      body: Padding(
        padding: EdgeInsets.all(Responsive.pagePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    category.color,
                    category.color.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Barnoota filadhu 👇",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.builder(
                itemCount: lessons.length,
                gridDelegate:
                    Responsive.homeGridDelegate(
                  context,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  // Cards carry an icon, title, and two lines of description.
                  // A taller ratio prevents vertical overflow on narrow phones.
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  return AnimatedEntrance(
                    delay: index * 70,
                    child: lessonCard(context, lessons[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget lessonCard(
    BuildContext context,
    LessonItem lesson,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        Navigator.push(
          context,
          AppAnimations.slidePage(lesson.screen),
        );
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.96, end: 1),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
        child: Container(
        decoration: BoxDecoration(
          color: lesson.color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(0, 4),
              color: Colors.black26,
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lesson.emoji,
              style: const TextStyle(fontSize: 42),
            ),

            const SizedBox(height: 10),

            Icon(
              lesson.icon,
              color: Colors.white,
              size: 34,
            ),

            const SizedBox(height: 10),

            Text(
              lesson.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              lesson.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
