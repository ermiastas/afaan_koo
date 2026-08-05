class Assignment {

  final String id;

  final String classId;

  final String lessonId;

  final String lessonName;

  final DateTime dueDate;

  final bool completed;

  const Assignment({

    required this.id,

    required this.classId,

    required this.lessonId,

    required this.lessonName,

    required this.dueDate,

    this.completed = false,

  });

  factory Assignment.fromMap(
      Map<String,dynamic> map){

    return Assignment(

      id: map['id'],

      classId: map['class_id'],

      lessonId: map['lesson_id'],

      lessonName: map['lesson_name'],

      dueDate:
          DateTime.parse(map['due_date']),

      completed:
          map['completed'] ?? false,

    );

  }

  Map<String,dynamic> toMap(){

    return {

      "id":id,

      "class_id":classId,

      "lesson_id":lessonId,

      "lesson_name":lessonName,

      "due_date":
          dueDate.toIso8601String(),

      "completed":completed,

    };

  }

}