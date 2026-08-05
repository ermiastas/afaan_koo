class ColorItem {


  final String nameOromo;

  final String nameEnglish;

  final String colorCode;

  final String image;

  final String sound;





  ColorItem({

    required this.nameOromo,

    required this.nameEnglish,

    required this.colorCode,

    required this.image,

    required this.sound,

  });







  factory ColorItem.fromJson(

      Map<String,dynamic> json

      ){



    return ColorItem(




      nameOromo:

      json["nameOromo"]

      ??

      json["title"]

      ??

      "",






      nameEnglish:

      json["nameEnglish"]

      ??

      json["english"]

      ??

      "",






      colorCode:

      json["colorCode"]

      ??

      "#FFFFFF",






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