class FruitItem {

  final String nameOromo;
  final String nameEnglish;
  final String image;
  final String sound;


  FruitItem({

    required this.nameOromo,

    required this.nameEnglish,

    required this.image,

    required this.sound,

  });



  factory FruitItem.fromJson(Map<String,dynamic> json){

    return FruitItem(

      nameOromo: json["nameOromo"] ?? "",

      nameEnglish: json["nameEnglish"] ?? "",

      image: json["image"] ?? "",

      sound: json["sound"] ?? "",

    );

  }

}