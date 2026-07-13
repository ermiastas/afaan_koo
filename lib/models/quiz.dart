class Quiz {


  final String question;
  final String image;

  final List<String> options;

  final String answer;



  Quiz({

    required this.question,
    required this.image,
    required this.options,
    required this.answer,

  });



  factory Quiz.fromJson(
      Map<String,dynamic> json
      ){

    return Quiz(

      question:
      json["question"],

      image:
      json["image"],

      options:
      List<String>.from(
        json["options"],
      ),

      answer:
      json["answer"],

    );

  }


}