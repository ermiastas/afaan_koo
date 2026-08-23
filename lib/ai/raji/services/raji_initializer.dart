
import '../../../providers/age_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/reward_provider.dart';

import '../providers/raji_provider.dart';

import 'raji_context_builder.dart';

class RajiInitializer {
  RajiInitializer._();

  static Future<void> initialize({
    required RajiProvider rajiProvider,

    required ProfileProvider profileProvider,

    required ProgressProvider progressProvider,

    required RewardProvider rewardProvider,

    required AgeProvider ageProvider,

    String? currentLesson,

    String? currentCategory,

    String? currentItem,
  }) async {
    final rajiContext =
        RajiContextBuilder.build(
      profileProvider:
          profileProvider,

      progressProvider:
          progressProvider,

      rewardProvider:
          rewardProvider,

      ageProvider:
          ageProvider,

      currentLesson:
          currentLesson,

      currentCategory:
          currentCategory,

      currentItem:
          currentItem,
    );

    await rajiProvider.initialize(
      context:
          rajiContext,
    );
  }
}
