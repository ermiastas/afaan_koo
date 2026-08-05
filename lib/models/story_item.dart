enum StoryDifficulty {

  easy,

  medium,

  hard,

}



class StoryQuestion {


  final String question;


  final List<String> options;


  final int correctAnswer;



  StoryQuestion({

    required this.question,

    required this.options,

    required this.correctAnswer,

  });





  factory StoryQuestion.fromJson(
      Map<String,dynamic> json){

    return StoryQuestion(

      question:
      json['question'] ?? "",

      options:
      List<String>.from(
        json['options'] ?? [],
      ),

      correctAnswer:
      json['correctAnswer'] ?? 0,

    );

  }




  Map<String,dynamic> toJson(){

    return {

      "question":
      question,

      "options":
      options,

      "correctAnswer":
      correctAnswer,

    };

  }


}





class StoryItem {



  final int id;



  final String title;



  final String subtitle;



  final String story;



  final String lesson;



  final List<String> learningPoints;



  final List<String> newWords;



  final List<StoryQuestion> questions;



  final String hint;



  final String emoji;



  final String audio;



  final String category;



  final String ageGroup;



  final int readingTime;



  final StoryDifficulty difficulty;



  final int xpReward;



  final int coinsReward;



  final bool isUnlocked;





  StoryItem({


    required this.id,


    required this.title,


    this.subtitle = "",


    required this.story,


    required this.lesson,


    this.learningPoints = const [],


    this.newWords = const [],


    this.questions = const [],


    required this.hint,


    required this.emoji,


    required this.audio,


    this.category = "Aadaa Oromoo",


    this.ageGroup = "6-12",


    this.readingTime = 3,


    this.difficulty =
    StoryDifficulty.easy,


    this.xpReward = 20,


    this.coinsReward = 10,


    this.isUnlocked = true,


  });








  factory StoryItem.fromJson(

      Map<String,dynamic> json){



    return StoryItem(



      id:

      json['id'] ?? 0,



      title:

      json['title'] ?? "",



      subtitle:

      json['subtitle'] ?? "",



      story:

      json['story'] ?? "",



      lesson:

      json['lesson'] ?? "",




      learningPoints:

      List<String>.from(

        json['learningPoints'] ?? [],

      ),




      newWords:

      List<String>.from(

        json['newWords'] ?? [],

      ),





      questions:

      (json['questions'] as List? ?? [])

          .map(

            (e)=>

            StoryQuestion.fromJson(e),

      )

          .toList(),






      hint:

      json['hint'] ?? "",




      emoji:

      json['emoji'] ?? "📖",




      audio:

      json['audio'] ?? "",





      category:

      json['category'] ??

          "Aadaa Oromoo",






      ageGroup:

      json['ageGroup'] ??

          "6-12",





      readingTime:

      json['readingTime'] ?? 3,






      difficulty:

      StoryDifficulty.values.firstWhere(

            (e)=>

        e.name ==

            json['difficulty'],



        orElse:

            ()=> StoryDifficulty.easy,

      ),






      xpReward:

      json['xpReward'] ?? 20,





      coinsReward:

      json['coinsReward'] ?? 10,






      isUnlocked:

      json['isUnlocked'] ?? true,



    );

  }









  Map<String,dynamic> toJson(){



    return {



      "id":

      id,



      "title":

      title,



      "subtitle":

      subtitle,



      "story":

      story,



      "lesson":

      lesson,



      "learningPoints":

      learningPoints,



      "newWords":

      newWords,



      "questions":

      questions

          .map(

              (e)=>e.toJson()

      )

          .toList(),




      "hint":

      hint,



      "emoji":

      emoji,



      "audio":

      audio,



      "category":

      category,



      "ageGroup":

      ageGroup,



      "readingTime":

      readingTime,



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