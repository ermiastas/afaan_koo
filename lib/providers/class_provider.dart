import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/class_room.dart';

import '../services/teacher_service.dart';



class ClassProvider extends ChangeNotifier {



  final TeacherService _teacherService =
      TeacherService();




  // ===============================
  // DATA
  // ===============================


  final List<Student> _students = [];



  final List<ClassRoom> _classes = [];





  List<Student> get students =>
      _students;



  List<ClassRoom> get classes =>
      _classes;






  int get totalStudents =>
      _students.length;








  double get averageProgress {


    if(_students.isEmpty){

      return 0;

    }



    final total =

    _students.fold<double>(

      0,

          (sum, student)=>

      sum + student.progress,

    );



    return total /

        _students.length;



  }








  // ===============================
  // LOAD CLASSES
  // ===============================


  Future<void> loadClasses() async {



    try{


      final result =

      await _teacherService

          .getClasses();



      _classes.clear();


      _classes.addAll(result);



      notifyListeners();



    }

    catch(e){


      debugPrint(

          "Class loading error: $e"

      );


    }


  }









  // ===============================
  // ADD CLASS
  // ===============================


  Future<void> addClass(

      ClassRoom classroom

      ) async {



    _classes.add(classroom);



    notifyListeners();




    await _teacherService

        .createClass(classroom);



  }









  // ===============================
  // ADD STUDENT
  // ===============================


  Future<void> addStudent(

      Student student,

      {

      String? classId,

      }

      ) async {



    // Offline first


    _students.add(student);



    notifyListeners();





    // Sync online


    if(classId != null){


      await _teacherService

          .addStudent(

          student,

          classId

      );


    }



  }









  // ===============================
  // UPDATE STUDENT
  // ===============================


  void updateStudent(

      Student student

      ){



    final index =

    _students.indexWhere(

            (s)=>s.id == student.id

    );




    if(index != -1){



      _students[index] = student;



      notifyListeners();



    }



  }








  // ===============================
  // SAVE PROGRESS
  // ===============================


  Future<void> saveStudentProgress({


    required String studentId,


    required String lessonId,


    required double progress,


    required bool completed,


  }) async {



    await _teacherService

        .saveProgress(



      studentId: studentId,


      lessonId: lessonId,


      progress: progress,


      completed: completed,



    );



  }







}