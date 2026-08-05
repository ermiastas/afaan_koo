class Story {


  final String titleOromo;

  final String titleEnglish;

  final String storyOromo;

  final String storyEnglish;

  final String image;

  final String sound;





  Story({

    required this.titleOromo,

    required this.titleEnglish,

    required this.storyOromo,

    required this.storyEnglish,

    required this.image,

    required this.sound,

  });







  factory Story.fromJson(

      Map<String,dynamic> json

      ){



    return Story(




      titleOromo:

      json["titleOromo"]

      ??

      json["title"]

      ??

      "",






      titleEnglish:

      json["titleEnglish"]

      ??

      json["english"]

      ??

      "",






      storyOromo:

      json["storyOromo"]

      ??

      json["description"]

      ??

      "",






      storyEnglish:

      json["storyEnglish"]

      ??

      json["description"]

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




    );



  }



}