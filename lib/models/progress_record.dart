class ProgressRecord {


  final String id;

  final String userId;

  final String lessonId;

  final double progress;

  final bool completed;



  const ProgressRecord({

    required this.id,

    required this.userId,

    required this.lessonId,

    required this.progress,

    required this.completed,

  });





  factory ProgressRecord.fromMap(
      Map<String,dynamic> map
      ){

    return ProgressRecord(

      id:
      map['id'] ?? '',


      userId:
      map['user_id'] ?? '',


      lessonId:
      map['lesson_id'] ?? '',


      progress:
      (map['progress'] ?? 0)
          .toDouble(),


      completed:
      map['completed'] ?? false,


    );


  }





  Map<String,dynamic> toMap(){


    return {


      'id':id,

      'user_id':userId,

      'lesson_id':lessonId,

      'progress':progress,

      'completed':completed,


    };


  }



}