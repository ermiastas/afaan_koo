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
      json["titleOromo"],

      titleEnglish:
      json["titleEnglish"],

      storyOromo:
      json["storyOromo"],

      storyEnglish:
      json["storyEnglish"],

      image:
      json["image"],

      sound:
      json["sound"],

    );

  }


}