class StudentProgress {

  final int xp;

  final int coins;

  final int stars;

  final int level;

  final int streak;

  final int completedLessons;

  final int totalLessons;

  final int learningMinutes;


  const StudentProgress({

    required this.xp,

    required this.coins,

    required this.stars,

    required this.level,

    required this.streak,

    required this.completedLessons,

    required this.totalLessons,

    required this.learningMinutes,

  });


  double get completionPercentage {

    if(totalLessons == 0){
      return 0;
    }

    return completedLessons / totalLessons;

  }


  StudentProgress copyWith({

    int? xp,

    int? coins,

    int? stars,

    int? level,

    int? streak,

    int? completedLessons,

    int? totalLessons,

    int? learningMinutes,

  }){


    return StudentProgress(

      xp: xp ?? this.xp,

      coins: coins ?? this.coins,

      stars: stars ?? this.stars,

      level: level ?? this.level,

      streak: streak ?? this.streak,

      completedLessons:
          completedLessons ??
          this.completedLessons,

      totalLessons:
          totalLessons ??
          this.totalLessons,

      learningMinutes:
          learningMinutes ??
          this.learningMinutes,

    );

  }

}