import 'package:flutter/material.dart';

import '../models/lesson_category.dart';
import '../models/lesson_item.dart';
import '../utils/responsive.dart';

class CategoryLessonsScreen extends StatelessWidget {
  final LessonCategory category;

  const CategoryLessonsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    return Scaffold(
      backgroundColor: const Color(0xffF7FBFF),
      appBar: AppBar(
        backgroundColor: category.color,
        elevation: 0,
        titleSpacing: Responsive.isPhone(context) ? 8 : 16,
        title: Row(
          children: [
            Text(
              category.emoji,
              style: TextStyle(
                fontSize: isWatch
                    ? 20
                    : isTV
                        ? 42
                        : 28,
              ),
            ),
            SizedBox(
              width: isWatch
                  ? 6
                  : isTV
                      ? 16
                      : 10,
            ),
            Expanded(
              child: Text(
                category.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.subtitleSize(context),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _categoryHeader(context),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(
                Responsive.pagePadding(context),
              ),
              itemCount: category.lessons.length,
              gridDelegate: Responsive.homeGridDelegate(
                context,
                childAspectRatio: Responsive.cardAspectRatio(context),
                crossAxisSpacing: Responsive.gridSpacing(context),
                mainAxisSpacing: Responsive.gridSpacing(context),
              ),
              itemBuilder: (context, index) {
                final lesson = category.lessons[index];

                return LessonCard(
                  lesson: lesson,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryHeader(BuildContext context) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: isWatch
            ? 8
            : isTV
                ? 28
                : 20,
      ),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: .15),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            isWatch
                ? 16
                : isTV
                    ? 40
                    : 30,
          ),
          bottomRight: Radius.circular(
            isWatch
                ? 16
                : isTV
                    ? 40
                    : 30,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            category.subtitle,
            textAlign: TextAlign.center,
            maxLines: isWatch ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Responsive.bodySize(context),
              height: 1.2,
            ),
          ),
          SizedBox(
            height: isWatch
                ? 4
                : isTV
                    ? 12
                    : 10,
          ),
          Text(
            '${category.lessonCount} barnoota qaba',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Responsive.bodySize(context),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final LessonItem lesson;

  const LessonCard({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final isWatch = Responsive.isWatch(context);
    final isTV = Responsive.isTV(context);

    final radius = Responsive.cardRadius(context);
    final cardPadding = Responsive.cardPadding(context);
    final emojiSize = _emojiSize(context);
    final emojiContainerSize = _emojiContainerSize(context);
    final titleSize = Responsive.subtitleSize(context);
    final descriptionSize = Responsive.bodySize(context);

    return Semantics(
      button: true,
      label: lesson.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => lesson.screen,
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
                  blurRadius: isTV ? 18 : 8,
                  offset: Offset(
                    0,
                    isTV ? 7 : 4,
                  ),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: emojiContainerSize,
                  width: emojiContainerSize,
                  decoration: BoxDecoration(
                    color: lesson.color.withValues(alpha: .15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      lesson.emoji,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: emojiSize,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: isWatch
                      ? 6
                      : isTV
                          ? 16
                          : 10,
                ),
                Flexible(
                  child: Text(
                    lesson.title,
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
                Flexible(
                  child: Text(
                    lesson.description,
                    textAlign: TextAlign.center,
                    maxLines: isWatch ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: descriptionSize,
                      color: Colors.grey.shade600,
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

  double _emojiContainerSize(BuildContext context) {
    if (Responsive.isWatch(context)) {
      return 42;
    }

    if (Responsive.isPhone(context)) {
      return 56;
    }

    if (Responsive.isTablet(context)) {
      return 66;
    }

    if (Responsive.isTV(context)) {
      return 112;
    }

    return 76;
  }

  double _emojiSize(BuildContext context) {
    if (Responsive.isWatch(context)) {
      return 24;
    }

    if (Responsive.isPhone(context)) {
      return 32;
    }

    if (Responsive.isTablet(context)) {
      return 38;
    }

    if (Responsive.isTV(context)) {
      return 62;
    }

    return 44;
  }
}
