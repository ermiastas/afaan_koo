
class RajiContext {
  // =====================================================
  // CHILD PROFILE
  // =====================================================

  final String nickname;

  final String avatar;

  final String ageGroup;

  // =====================================================
  // CURRENT LEARNING CONTEXT
  // =====================================================

  final String? currentLesson;

  final String? currentCategory;

  final String? currentItem;

  // =====================================================
  // REWARDS
  // =====================================================

  final int xp;

  final int coins;

  final int stars;

  final int level;

  // =====================================================
  // LEARNING PROGRESS
  // =====================================================

  final int completedLessons;

  final int completedGames;

  final int learningMinutes;

  final double completionPercentage;

  final List<String> completedLessonIds;

  // =====================================================
  // CONSTRUCTOR
  // =====================================================

  const RajiContext({
    required this.nickname,
    required this.avatar,
    required this.ageGroup,

    this.currentLesson,

    this.currentCategory,

    this.currentItem,

    this.xp = 0,

    this.coins = 0,

    this.stars = 0,

    this.level = 1,

    this.completedLessons = 0,

    this.completedGames = 0,

    this.learningMinutes = 0,

    this.completionPercentage = 0,

    this.completedLessonIds =
        const [],
  });

  // =====================================================
  // COPY WITH
  // =====================================================

  RajiContext copyWith({
    String? nickname,
    String? avatar,
    String? ageGroup,
    String? currentLesson,
    String? currentCategory,
    String? currentItem,
    int? xp,
    int? coins,
    int? stars,
    int? level,
    int? completedLessons,
    int? completedGames,
    int? learningMinutes,
    double? completionPercentage,
    List<String>?
        completedLessonIds,
  }) {
    return RajiContext(
      nickname:
          nickname ?? this.nickname,

      avatar:
          avatar ?? this.avatar,

      ageGroup:
          ageGroup ?? this.ageGroup,

      currentLesson:
          currentLesson ??
          this.currentLesson,

      currentCategory:
          currentCategory ??
          this.currentCategory,

      currentItem:
          currentItem ??
          this.currentItem,

      xp:
          xp ?? this.xp,

      coins:
          coins ?? this.coins,

      stars:
          stars ?? this.stars,

      level:
          level ?? this.level,

      completedLessons:
          completedLessons ??
          this.completedLessons,

      completedGames:
          completedGames ??
          this.completedGames,

      learningMinutes:
          learningMinutes ??
          this.learningMinutes,

      completionPercentage:
          completionPercentage ??
          this.completionPercentage,

      completedLessonIds:
          completedLessonIds ??
          this.completedLessonIds,
    );
  }

  // =====================================================
  // JSON
  // =====================================================

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,

      'avatar': avatar,

      'ageGroup': ageGroup,

      'currentLesson':
          currentLesson,

      'currentCategory':
          currentCategory,

      'currentItem':
          currentItem,

      'progress': {
        'xp': xp,

        'coins': coins,

        'stars': stars,

        'level': level,

        'completedLessons':
            completedLessons,

        'completedGames':
            completedGames,

        'learningMinutes':
            learningMinutes,

        'completionPercentage':
            completionPercentage,

        'completedLessonIds':
            completedLessonIds,
      },
    };
  }
}
