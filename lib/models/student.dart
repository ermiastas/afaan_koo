class Student {


  final String id;

  final String name;

  final int completedLessons;

  final int xp;

  final double progress;



  const Student({

    required this.id,

    required this.name,

    required this.completedLessons,

    required this.xp,

    required this.progress,

  });



  Student copyWith({

    int? completedLessons,

    int? xp,

    double? progress,

  }){


    return Student(

      id:id,

      name:name,

      completedLessons:
          completedLessons ??
          this.completedLessons,


      xp:
          xp ??
          this.xp,


      progress:
          progress ??
          this.progress,

    );

  }


}