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






      singer:

      json["singer"]

      ??

      "Unknown",






      lyricsOromo:

      json["lyricsOromo"]

      ??

      json["description"]

      ??

      "",






      lyricsEnglish:

      json["lyricsEnglish"]

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