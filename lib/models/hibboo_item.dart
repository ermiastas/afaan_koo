enum HibbooDifficulty {
  easy,
  medium,
  hard,
}


class HibbooItem {

  final int id;

  final String question;

  final String hint;

  final String answer;

  // Emoji bakka image bu'a
  final String emoji;

  final String audio;

  final String category;

  final HibbooDifficulty difficulty;

  final int xpReward;

  final int coinsReward;

  final bool isUnlocked;


  HibbooItem({

    required this.id,

    required this.question,

    required this.hint,

    required this.answer,

    required this.emoji,

    required this.audio,

    this.category = "Waliigala",

    this.difficulty = HibbooDifficulty.easy,

    this.xpReward = 10,

    this.coinsReward = 5,

    this.isUnlocked = true,

  });

}