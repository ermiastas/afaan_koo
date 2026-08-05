class GameProgress {

  final String gameId;

  final int highScore;

  final int plays;

  final bool completed;

  final bool unlocked;


  const GameProgress({

    required this.gameId,

    this.highScore = 0,

    this.plays = 0,

    this.completed = false,

    this.unlocked = false,

  });



  GameProgress copyWith({

    int? highScore,

    int? plays,

    bool? completed,

    bool? unlocked,

  }) {


    return GameProgress(

      gameId: gameId,


      highScore:
          highScore ?? this.highScore,


      plays:
          plays ?? this.plays,


      completed:
          completed ?? this.completed,


      unlocked:
          unlocked ?? this.unlocked,

    );

  }


}