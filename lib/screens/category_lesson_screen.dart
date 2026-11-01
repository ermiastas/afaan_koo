import 'package:flutter/material.dart';

import '../models/lesson_category.dart';
import '../models/lesson_item.dart';
import '../utils/app_animations.dart';
import '../utils/responsive.dart';
import '../widgets/animations/animated_entrance.dart';

class CategoryLessonScreen extends StatelessWidget {
  final LessonCategory category;

  const CategoryLessonScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = category.lessons;
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${category.emoji} ${category.title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        titleTextStyle: TextStyle(
          fontSize: Responsive.subtitleSize(context),
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          Responsive.pagePadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _categoryHeader(context),
            SizedBox(
              height: isWatch
                  ? 12
                  : isTV
                      ? 28
                      : 25,
            ),
            Text(
              'Barnoota filadhu 👇',
              style: TextStyle(
                fontSize: Responsive.titleSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: isWatch
                  ? 8
                  : isTV
                      ? 18
                      : 15,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: lessons.length,
                gridDelegate: Responsive.homeGridDelegate(
                  context,
                  crossAxisSpacing: Responsive.gridSpacing(context),
                  mainAxisSpacing: Responsive.gridSpacing(context),
                  childAspectRatio: Responsive.cardAspectRatio(context),
                ),
                itemBuilder: (context, index) {
                  return AnimatedEntrance(
                    delay: index * 70,
                    child: _lessonCard(
                      context,
                      lessons[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryHeader(BuildContext context) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.cardPadding(context),
        vertical: isWatch
            ? 10
            : isTV
                ? 30
                : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            category.color,
            category.color.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(
          Responsive.cardRadius(context),
        ),
      ),
      child: Column(
        children: [
          Text(
            category.emoji,
            style: TextStyle(
              fontSize: isWatch
                  ? 36
                  : isTV
                      ? 90
                      : 60,
              height: 1,
            ),
          ),
          SizedBox(
            height: isWatch
                ? 6
                : isTV
                    ? 16
                    : 10,
          ),
          Text(
            category.title,
            textAlign: TextAlign.center,
            maxLines: isWatch ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Responsive.titleSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          SizedBox(
            height: isWatch
                ? 4
                : isTV
                    ? 10
                    : 6,
          ),
          Text(
            category.subtitle,
            textAlign: TextAlign.center,
            maxLines: isWatch ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Responsive.bodySize(context),
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lessonCard(
    BuildContext context,
    LessonItem lesson,
  ) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    final radius = Responsive.cardRadius(context);
    final padding = Responsive.cardPadding(context);

    return Semantics(
      button: true,
      label: lesson.title,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
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
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: lesson.color,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  blurRadius: isTV ? 14 : 5,
                  offset: Offset(
                    0,
                    isTV ? 6 : 4,
                  ),
                  color: Colors.black26,
                ),
              ],
            ),
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lesson.emoji,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWatch
                        ? 26
                        : isTV
                            ? 68
                            : 42,
                    height: 1,
                  ),
                ),
                SizedBox(
                  height: isWatch
                      ? 5
                      : isTV
                          ? 16
                          : 10,
                ),
                Icon(
                  lesson.icon,
                  color: Colors.white,
                  size: isWatch
                      ? 22
                      : isTV
                          ? 50
                          : 34,
                ),
                SizedBox(
                  height: isWatch
                      ? 5
                      : isTV
                          ? 14
                          : 10,
                ),
                Flexible(
                  child: Text(
                    lesson.title,
                    textAlign: TextAlign.center,
                    maxLines: isWatch ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Responsive.subtitleSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                ),
                SizedBox(
                  height: isWatch
                      ? 3
                      : isTV
                          ? 8
                          : 6,
                ),
                Flexible(
                  child: Text(
                    lesson.description,
                    textAlign: TextAlign.center,
                    maxLines: isWatch ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Responsive.bodySize(context),
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
