class Letter {


  final String letter;
  final String wordOromo;
  final String wordEnglish;
  final String image;
  final String sound;



  Letter({

    required this.letter,
    required this.wordOromo,
    required this.wordEnglish,
    required this.image,
    required this.sound,

  });



  factory Letter.fromJson(
      Map<String,dynamic> json
      ){

    return Letter(

      letter:
      json["letter"],

      wordOromo:
      json["word"],

      wordEnglish:
      json["english"],

      image:
      json["image"],

      sound:
      json["sound"],

    );

  }


}