class LearningProgress {


  int alphabetCompleted;

  int animalCompleted;

  int wordCompleted;

  int gamesCompleted;



  // Total available learning sections
  static const int totalLessons = 4;



  LearningProgress({


    this.alphabetCompleted = 0,


    this.animalCompleted = 0,


    this.wordCompleted = 0,


    this.gamesCompleted = 0,


  });





  // Total completed activities

  int get totalCompleted =>

      alphabetCompleted +

      animalCompleted +

      wordCompleted +

      gamesCompleted;






  // Progress percentage as a value between 0.0 and 1.0

  double get percentage {



    if(totalLessons == 0){

      return 0;

    }



    return totalCompleted / totalLessons;

  }






  // Progress percentage as whole number

  int get percentageValue =>

      (percentage * 100).round();





  // Reset progress

  void reset(){


    alphabetCompleted = 0;


    animalCompleted = 0;


    wordCompleted = 0;


    gamesCompleted = 0;


  }




  // Convert to JSON for storage

  Map<String,dynamic> toJson(){


    return {


      "alphabetCompleted":

      alphabetCompleted,


      "animalCompleted":

      animalCompleted,


      "wordCompleted":

      wordCompleted,


      "gamesCompleted":

      gamesCompleted,


    };


  }






  // Load from JSON

  factory LearningProgress.fromJson(

      Map<String,dynamic> json

      ){



    return LearningProgress(


      alphabetCompleted:

      json["alphabetCompleted"] ?? 0,



      animalCompleted:

      json["animalCompleted"] ?? 0,



      wordCompleted:

      json["wordCompleted"] ?? 0,



      gamesCompleted:

      json["gamesCompleted"] ?? 0,



    );


  }



}