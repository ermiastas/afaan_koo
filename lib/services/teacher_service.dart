import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student.dart';
import '../models/class_room.dart';
import 'supabase_service.dart';



class TeacherService {


  SupabaseClient get _client => SupabaseService.client!;





  // =====================================
  // CREATE CLASS
  // =====================================


  Future<void> createClass(

      ClassRoom classroom

      ) async {


    try {


      final user =
          SupabaseService.currentUser;



      if(user == null){

        return;

      }



      await _client

          .from('classes')

          .insert({


        'id':
        classroom.id,


        'teacher_id':
        user.id,


        'name':
        classroom.name,


        'grade':
        classroom.grade,


        'created_at':
        DateTime.now()
            .toIso8601String(),


      });



    }

    catch(e){


      debugPrint(

          "Create class error: $e"

      );


    }


  }








  // =====================================
  // LOAD TEACHER CLASSES
  // =====================================


  Future<List<ClassRoom>> getClasses() async {


    try{


      final user =
          SupabaseService.currentUser;



      if(user == null){

        return [];

      }





      final response =

      await _client

          .from('classes')

          .select()

          .eq(

          'teacher_id',

          user.id

      );





      return response

          .map<ClassRoom>(

              (item)=>ClassRoom.fromMap(item)

      )

          .toList();



    }

    catch(e){


      debugPrint(

          "Load classes error: $e"

      );


      return [];


    }


  }









  // =====================================
  // ADD STUDENT
  // =====================================


  Future<void> addStudent(

      Student student,

      String classId,

      ) async {


    try{


      await _client

          .from('students')

          .insert({


        'id':

        student.id,



        'class_id':

        classId,



        'name':

        student.name,



        'created_at':

        DateTime.now()

            .toIso8601String(),



      });



    }

    catch(e){


      debugPrint(

          "Add student error: $e"

      );


    }


  }









  // =====================================
  // SAVE STUDENT PROGRESS
  // =====================================


  Future<void> saveProgress({

    required String studentId,

    required String lessonId,

    required double progress,

    required bool completed,


  }) async {


    try{


      await _client

          .from('student_progress')

          .upsert({



        'student_id':

        studentId,



        'lesson_id':

        lessonId,



        'progress':

        progress,



        'completed':

        completed,



        'updated_at':

        DateTime.now()

            .toIso8601String(),



      });



    }

    catch(e){


      debugPrint(

          "Save progress error: $e"

      );


    }



  }








  // =====================================
  // GIVE STUDENT REWARD
  // =====================================


  Future<void> giveReward({


    required String studentId,


    required String title,


    required String description,


    required int xp,


    required int stars,


    required String badge,



  }) async {



    try{


      final user =

      SupabaseService.currentUser;



      await _client

          .from('student_rewards')

          .insert({



        'student_id':

        studentId,



        'teacher_id':

        user?.id,



        'title':

        title,



        'description':

        description,



        'xp':

        xp,



        'stars':

        stars,



        'badge':

        badge,



        'created_at':

        DateTime.now()

            .toIso8601String(),



      });



    }

    catch(e){


      debugPrint(

          "Reward save error: $e"

      );


    }


  }






}