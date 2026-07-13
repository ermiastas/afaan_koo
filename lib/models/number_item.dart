class NumberItem {


  final int number;
  final String nameOromo;
  final String nameEnglish;
  final String image;
  final String sound;



  NumberItem({

    required this.number,
    required this.nameOromo,
    required this.nameEnglish,
    required this.image,
    required this.sound,

  });



  factory NumberItem.fromJson(
      Map<String,dynamic> json
      ){

    return NumberItem(

      number:
      json["number"],

      nameOromo:
      json["nameOromo"],

      nameEnglish:
      json["nameEnglish"],

      image:
      json["image"],

      sound:
      json["sound"],

    );

  }


}