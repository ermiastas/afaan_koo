class LessonAssignment {

  final String id;

  final String classId;

  final String lessonId;

  final String lessonTitle;

  final DateTime assignedDate;


  const LessonAssignment({

    required this.id,

    required this.classId,

    required this.lessonId,

    required this.lessonTitle,

    required this.assignedDate,

  });



  factory LessonAssignment.fromMap(
      Map<String,dynamic> map
      ){

    return LessonAssignment(

      id: map['id'] ?? '',

      classId: map['class_id'] ?? '',

      lessonId: map['lesson_id'] ?? '',

      lessonTitle:
      map['lesson_title'] ?? '',

      assignedDate:

      DateTime.tryParse(
        map['assigned_date'] ?? '',
      )
      ??
      DateTime.now(),

    );

  }




  Map<String,dynamic> toMap(){

    return {

      'id':id,

      'class_id':classId,

      'lesson_id':lessonId,

      'lesson_title':lessonTitle,

      'assigned_date':
      assignedDate.toIso8601String(),

    };

  }

}
