class ChildProfile {

  final String name;
  final int age;
  final int xp;
  final int lessonsCompleted;
  final int learningMinutes;
  final int streak;


  ChildProfile({

    required this.name,
    required this.age,
    required this.xp,
    required this.lessonsCompleted,
    required this.learningMinutes,
    required this.streak,

  });


  String get level {

    if(xp < 500){
      return "Beginner 🌱";
    }

    if(xp < 1500){
      return "Explorer 🚀";
    }

    if(xp < 3000){
      return "Champion 🏆";
    }

    return "Afaan Koo Master 👑";

  }

}