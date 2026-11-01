import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/lesson_provider.dart';
import '../../utils/responsive.dart';
import 'lesson_category_card.dart';

/// Responsive lesson-category grid used by the AfaanKoo home experience.
///
/// Adapts automatically from very small watch-sized layouts through
/// phones, tablets, desktops, and large TV displays.
class LessonGrid extends StatelessWidget {
  const LessonGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();
    final categories = lessonProvider.categories;

    if (categories.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.pagePadding(context),
            vertical: Responsive.verticalPadding(context),
          ),
          child: Center(
            child: SizedBox(
              width: Responsive.touchTarget(context),
              height: Responsive.touchTarget(context),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    final spacing = Responsive.gridSpacing(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: Responsive.verticalPadding(context),
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return LessonCategoryCard(
              category: categories[index],
            );
          },
          childCount: categories.length,
        ),
        gridDelegate: Responsive.homeGridDelegate(
          context,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: Responsive.cardAspectRatio(context),
        ),
      ),
    );
  }
}
