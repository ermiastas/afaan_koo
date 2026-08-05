class VegetableItem {

  final String nameOromo;
  final String nameEnglish;
  final String image;
  final String sound;

  VegetableItem({
    required this.nameOromo,
    required this.nameEnglish,
    required this.image,
    required this.sound,
  });

  factory VegetableItem.fromJson(Map<String, dynamic> json) {

    return VegetableItem(

      nameOromo: json["nameOromo"] ?? "",

      nameEnglish: json["nameEnglish"] ?? "",

      image: json["image"] ?? "",

      sound: json["sound"] ?? "",

    );

  }

}