
import '../../../providers/age_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/reward_provider.dart';

import '../models/raji_context.dart';

class RajiContextBuilder {
  RajiContextBuilder._();

  // =====================================================
  // BUILD RAJI CONTEXT
  // =====================================================

  static RajiContext build({
    required ProfileProvider profileProvider,

    required ProgressProvider progressProvider,

    required RewardProvider rewardProvider,

    required AgeProvider ageProvider,

    String? currentLesson,

    String? currentCategory,

    String? currentItem,
  }) {
    final age =
        ageProvider.age;

    return RajiContext(
      // -------------------------------------------------
      // CHILD PROFILE
      // -------------------------------------------------

      nickname:
          profileProvider.name,

      avatar:
          profileProvider.avatar,

      ageGroup:
          ageToAgeGroup(age),

      // -------------------------------------------------
      // CURRENT LEARNING
      // -------------------------------------------------

      currentLesson:
          currentLesson,

      currentCategory:
          currentCategory,

      currentItem:
          currentItem,

      // -------------------------------------------------
      // REWARDS
      // -------------------------------------------------

      xp:
          rewardProvider.xp,

      coins:
          rewardProvider.coins,

      stars:
          rewardProvider.stars,

      level:
          rewardProvider.level,

      // -------------------------------------------------
      // PROGRESS
      // -------------------------------------------------

      completedLessons:
          progressProvider
              .completedCount,

      completedGames:
          progressProvider
              .gamesCompleted,

      learningMinutes:
          progressProvider
              .learningMinutes,

      completionPercentage:
          progressProvider
                  .completionPercentage *
              100,

      completedLessonIds:
          progressProvider
              .completedLessons
              .entries
              .where(
                (entry) =>
                    entry.value == true,
              )
              .map(
                (entry) =>
                    entry.key,
              )
              .toList(),
    );
  }

  // =====================================================
  // AGE → AGE GROUP
  // =====================================================

  static String ageToAgeGroup(
    int age,
  ) {
    if (age <= 6) {
      return '5-6';
    }

    if (age <= 8) {
      return '7-8';
    }

    if (age <= 10) {
      return '9-10';
    }

    if (age <= 13) {
      return '11-13';
    }

    return '14+';
  }
}
