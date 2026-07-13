class Song {


  final String titleOromo;
  final String titleEnglish;

  final String singer;

  final String lyricsOromo;
  final String lyricsEnglish;

  final String image;
  final String sound;



  Song({

    required this.titleOromo,
    required this.titleEnglish,
    required this.singer,
    required this.lyricsOromo,
    required this.lyricsEnglish,
    required this.image,
    required this.sound,

  });



  factory Song.fromJson(
      Map<String,dynamic> json
      ){

    return Song(

      titleOromo:
      json["titleOromo"],

      titleEnglish:
      json["titleEnglish"],

      singer:
      json["singer"],

      lyricsOromo:
      json["lyricsOromo"],

      lyricsEnglish:
      json["lyricsEnglish"],

      image:
      json["image"],

      sound:
      json["sound"],

    );

  }


}