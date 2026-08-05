class NumberItem {


  final int number;


  final String nameOromo;


  final String nameEnglish;


  final String image;


  final String sound;


  /// Example sentences or objects
  final List<String> examples;



  const NumberItem({

    required this.number,

    required this.nameOromo,

    required this.nameEnglish,

    required this.image,

    required this.sound,

    this.examples = const [],

  });






  factory NumberItem.fromJson(
      Map<String, dynamic> json) {


    return NumberItem(


      number:

      json["number"] is int

          ? json["number"]

          : int.tryParse(

              json["number"]
                  ?.toString() ?? "0",

            ) ?? 0,




      nameOromo:

      json["nameOromo"] ?? "",




      nameEnglish:

      json["nameEnglish"] ?? "",




      image:

      json["image"] ?? "",




      sound:

      json["sound"] ?? "",




      examples:


      json["examples"] != null

          ? List<String>.from(

              json["examples"],

            )

          : const [],



    );


  }







  Map<String,dynamic> toJson(){


    return {


      "number":

      number,


      "nameOromo":

      nameOromo,


      "nameEnglish":

      nameEnglish,


      "image":

      image,


      "sound":

      sound,


      "examples":

      examples,


    };


  }






  String get displayNumber {


    return number.toString();


  }






  String get displayName {


    return "$number - $nameOromo";


  }



}