import 'package:flutter/material.dart';

import '../../models/lesson_category.dart';
import '../../screens/category_lessons_screen.dart';
import '../../utils/responsive.dart';

class LessonCategoryCard extends StatelessWidget {
  final LessonCategory category;

  const LessonCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = Responsive.cardPadding(context);
    final radius = Responsive.cardRadius(context);

    final emojiContainerSize = _emojiContainerSize(context);
    final emojiTextSize = _emojiTextSize(context);
    final titleSize = Responsive.subtitleSize(context);
    final countSize = Responsive.bodySize(context) - 2;

    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    return Semantics(
      button: true,
      label: '${category.title}, ${category.lessons.length} barnoota',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryLessonsScreen(
                  category: category,
                ),
              ),
            );
          },
          child: Ink(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isWatch ? .05 : .08,
                  ),
                  blurRadius: isTV ? 18 : 10,
                  offset: Offset(0, isTV ? 7 : 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: emojiContainerSize,
                  height: emojiContainerSize,
                  decoration: BoxDecoration(
                    color: category.color.withValues(
                      alpha: .15,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      category.emoji,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: emojiTextSize,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: isWatch
                      ? 6
                      : isTV
                          ? 18
                          : 12,
                ),
                Flexible(
                  child: Text(
                    category.title,
                    textAlign: TextAlign.center,
                    maxLines: isWatch ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                      height: 1.15,
                    ),
                  ),
                ),
                SizedBox(
                  height: isWatch
                      ? 3
                      : isTV
                          ? 8
                          : 5,
                ),
                Text(
                  '${category.lessons.length} barnoota',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: countSize.clamp(
                      isWatch ? 9.0 : 11.0,
                      isTV ? 22.0 : 18.0,
                    ),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _emojiContainerSize(BuildContext context) {
    if (Responsive.isWatch(context)) {
      return 44;
    }

    if (Responsive.isPhone(context)) {
      return 58;
    }

    if (Responsive.isTablet(context)) {
      return 68;
    }

    if (Responsive.isTV(context)) {
      return 110;
    }

    return 80;
  }

  double _emojiTextSize(BuildContext context) {
    if (Responsive.isWatch(context)) {
      return 25;
    }

    if (Responsive.isPhone(context)) {
      return 34;
    }

    if (Responsive.isTablet(context)) {
      return 40;
    }

    if (Responsive.isTV(context)) {
      return 60;
    }

    return 46;
  }
}
