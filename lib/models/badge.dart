class BadgeModel {


  final String id;

  final String title;

  final String description;

  final String emoji;

  final bool unlocked;



  const BadgeModel({

    required this.id,

    required this.title,

    required this.description,

    required this.emoji,

    this.unlocked = false,

  });



  BadgeModel copyWith({

    bool? unlocked,

  }){


    return BadgeModel(

      id:id,

      title:title,

      description:description,

      emoji:emoji,

      unlocked:
      unlocked ?? this.unlocked,

    );


  }


}