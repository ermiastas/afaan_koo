class StudentReward {


  final String id;

  final String studentId;

  final String title;

  final String description;

  final int xp;

  final int stars;

  final String badge;

  final DateTime date;



  const StudentReward({

    required this.id,

    required this.studentId,

    required this.title,

    required this.description,

    required this.xp,

    required this.stars,

    required this.badge,

    required this.date,

  });





  Map<String,dynamic> toMap(){


    return {


      "id":id,

      "student_id":studentId,

      "title":title,

      "description":description,

      "xp":xp,

      "stars":stars,

      "badge":badge,

      "date":date.toIso8601String(),


    };


  }






  factory StudentReward.fromMap(

      Map<String,dynamic> map

      ){


    return StudentReward(


      id:map['id'] ?? "",


      studentId:

      map['student_id'] ?? "",



      title:

      map['title'] ?? "",




      description:

      map['description'] ?? "",




      xp:

      map['xp'] ?? 0,




      stars:

      map['stars'] ?? 0,




      badge:

      map['badge'] ?? "",




      date:

      DateTime.tryParse(

        map['date'] ?? "",

      )

      ??

      DateTime.now(),



    );


  }


}