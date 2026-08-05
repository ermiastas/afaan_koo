class ClassRoom {


  final String id;

  final String name;

  final String grade;


  ClassRoom({

    required this.id,

    required this.name,

    required this.grade,

  });



  factory ClassRoom.fromMap(
      Map<String,dynamic> map
      ){

    return ClassRoom(

      id: map['id'] ?? '',

      name: map['name'] ?? '',

      grade: map['grade'] ?? '',

    );

  }



  Map<String,dynamic> toMap(){

    return {

      "id":id,

      "name":name,

      "grade":grade,

    };

  }

}