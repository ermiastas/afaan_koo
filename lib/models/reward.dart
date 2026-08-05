enum RewardType {

  badge,

  certificate,

  achievement,

  avatar,

}



class Reward {


  final String id;

  final String title;

  final String description;

  final String emoji;

  final RewardType type;

  final int requiredXP;



  const Reward({

    required this.id,

    required this.title,

    required this.description,

    required this.emoji,

    required this.type,

    required this.requiredXP,

  });


}