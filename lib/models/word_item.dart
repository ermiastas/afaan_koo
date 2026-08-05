class WordItem {


  final String wordOromo;

  final String wordEnglish;

  final String image;

  final String sound;

  final String category;




  WordItem({

    required this.wordOromo,

    required this.wordEnglish,

    required this.image,

    required this.sound,

    required this.category,

  });







  factory WordItem.fromJson(

      Map<String,dynamic> json

      ){


    return WordItem(



      wordOromo:

      json["wordOromo"]

      ??

      json["title"]

      ??

      "",






      wordEnglish:

      json["wordEnglish"]

      ??

      json["english"]

      ??

      "",






      image:

      json["image"]

      ??

      "",






      sound:

      json["sound"]

      ??

      "",






      category:

      json["category"]

      ??

      "general",




    );


  }


}