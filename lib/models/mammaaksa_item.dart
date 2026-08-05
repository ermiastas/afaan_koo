enum MammaaksaDifficulty {
  easy,
  medium,
  hard,
}


class MammaaksaItem {

  final int id;

  final String proverb;

  final String meaning;

  final String hint;

  final String emoji;

  final String audio;

  final String category;

  final MammaaksaDifficulty difficulty;

  final int xpReward;

  final int coinsReward;

  final bool isUnlocked;


  MammaaksaItem({

    required this.id,

    required this.proverb,

    required this.meaning,

    required this.hint,

    required this.emoji,

    required this.audio,

    this.category = "Aadaa fi Safuu",

    this.difficulty = MammaaksaDifficulty.easy,

    this.xpReward = 10,

    this.coinsReward = 5,

    this.isUnlocked = true,

  });


  factory MammaaksaItem.fromJson(
      Map<String, dynamic> json) {

    return MammaaksaItem(

      id: json['id'],

      proverb: json['proverb'],

      meaning: json['meaning'],

      hint: json['hint'] ?? "",

      emoji: json['emoji'] ?? "📖",

      audio: json['audio'] ?? "",

      category: json['category'] ?? "Aadaa fi Safuu",

      difficulty:
          MammaaksaDifficulty.values.firstWhere(
        (e) =>
            e.name == json['difficulty'],
        orElse: () =>
            MammaaksaDifficulty.easy,
      ),

      xpReward:
          json['xpReward'] ?? 10,

      coinsReward:
          json['coinsReward'] ?? 5,

      isUnlocked:
          json['isUnlocked'] ?? true,

    );
  }



  Map<String, dynamic> toJson(){

    return {

      "id": id,

      "proverb": proverb,

      "meaning": meaning,

      "hint": hint,

      "emoji": emoji,

      "audio": audio,

      "category": category,

      "difficulty":
          difficulty.name,

      "xpReward":
          xpReward,

      "coinsReward":
          coinsReward,

      "isUnlocked":
          isUnlocked,

    };

  }

}