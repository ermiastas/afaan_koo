class Teacher {


  final String id;

  final String name;

  final String? school;


  Teacher({

    required this.id,

    required this.name,

    this.school,

  });



  factory Teacher.fromMap(
      Map<String,dynamic> map
  ){

    return Teacher(

      id:map['id'],

      name:map['name'],

      school:map['school'],

    );

  }



  Map<String,dynamic> toMap(){

    return {

      'id':id,

      'name':name,

      'school':school,

    };

  }


}