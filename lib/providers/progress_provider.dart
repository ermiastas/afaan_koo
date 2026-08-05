import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/learning_progress.dart';
import '../services/supabase_service.dart';



class ProgressProvider extends ChangeNotifier {


  static const String _lessonProgressKey =
      'lesson_progress_v1';


  static const String _learningProgressKey =
      'learning_progress_v1';



  // ==============================
  // Learning Minutes
  // ==============================

  int _learningMinutes = 0;


  int get learningMinutes =>
      _learningMinutes;



  Future<void> addLearningMinutes(
      int minutes,
      ) async {


    _learningMinutes += minutes;


    await _saveLocal();


    notifyListeners();

  }






  // ==============================
  // Games
  // ==============================


  int _gamesCompleted = 0;


  int get gamesCompleted =>
      _gamesCompleted;




  Future<void> completeGame(
      String gameId,
      ) async {


    _gamesCompleted++;


    _progress.gamesCompleted =
        _gamesCompleted;


    await _saveLocal();


    notifyListeners();


  }







  // ==============================
  // Lesson Completion
  // ==============================


  final Map<String,bool> _completedLessons = {};



  final Map<String,double> _lessonProgress = {};



  final LearningProgress _progress =
      LearningProgress();





  Map<String,bool> get completedLessons =>
      _completedLessons;



  Map<String,double> get lessonProgress =>
      _lessonProgress;



  LearningProgress get progress =>
      _progress;





  SupabaseClient get _supabase {
    final client = SupabaseService.client;
    if (client == null) {
      throw StateError('Supabase client is not initialized');
    }
    return client;
  }







  // ==============================
  // LOAD
  // ==============================


  Future<void> load() async {


    await _loadLocal();


    await loadCloudProgress();


    notifyListeners();


  }

  /// Resets only progress stored on this device. Synced data is intentionally
  /// retained so a child cannot erase cloud records by mistake.
  Future<void> resetLocalProgress() async {
    _completedLessons.clear();
    _lessonProgress.clear();
    _learningMinutes = 0;
    _gamesCompleted = 0;
    _progress.reset();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lessonProgressKey);
    await prefs.remove(_learningProgressKey);
    notifyListeners();
  }







  // ==============================
  // LOCAL LOAD
  // ==============================


  Future<void> _loadLocal() async {


    final prefs =
    await SharedPreferences.getInstance();



    final savedLessons =
    prefs.getString(
      _lessonProgressKey,
    );



    if(savedLessons != null){


      final decoded =
      jsonDecode(savedLessons)
      as Map<String,dynamic>;



      decoded.forEach(

              (key,value){


            final progress =
            (value as num)
                .toDouble();



            _lessonProgress[key] =
                progress;



            if(progress >= 1){

              _completedLessons[key] =
              true;

            }


          });


    }







    final savedProgress =
    prefs.getString(
      _learningProgressKey,
    );



    if(savedProgress != null){


      final data =
      jsonDecode(savedProgress)
      as Map<String,dynamic>;



      _progress.alphabetCompleted =
          data['alphabet'] ?? 0;



      _progress.animalCompleted =
          data['animal'] ?? 0;



      _progress.wordCompleted =
          data['word'] ?? 0;



      _gamesCompleted =
          data['games'] ?? 0;



      _learningMinutes =
          data['minutes'] ?? 0;



      _progress.gamesCompleted =
          _gamesCompleted;


    }



  }







  // ==============================
  // SAVE LOCAL
  // ==============================


  Future<void> _saveLocal() async {


    final prefs =
    await SharedPreferences.getInstance();



    await prefs.setString(

      _lessonProgressKey,

      jsonEncode(
          _lessonProgress
      ),

    );





    await prefs.setString(

      _learningProgressKey,

      jsonEncode({


        "alphabet":
        _progress.alphabetCompleted,


        "animal":
        _progress.animalCompleted,


        "word":
        _progress.wordCompleted,


        "games":
        _gamesCompleted,


        "minutes":
        _learningMinutes,


      }),

    );


  }









  // ==============================
  // CLOUD LOAD
  // ==============================


  Future<void> loadCloudProgress() async {


    try {


      final user =
      SupabaseService.currentUser;



      if(user == null){

        return;

      }



      final data =
      await _supabase

          .from('progress')

          .select()

          .eq(
        'user_id',
        user.id,
      );





      for(final row in data){


        final id =
        row['lesson_id'];



        final value =
        (row['progress'] ?? 0)
            .toDouble();



        _lessonProgress[id] =
            value;



        if(value >= 1){

          _completedLessons[id] =
          true;

        }


      }



    }

    catch(e){

      debugPrint(
          "Cloud progress load failed: $e"
      );

    }


  }







  // ==============================
  // CLOUD SAVE
  // ==============================


  Future<void> _saveCloudProgress(

      String lessonId,

      double value,

      ) async {



    try {


      final user =
      SupabaseService.currentUser;



      if(user == null){

        return;

      }



      await _supabase

          .from('progress')

          .upsert({


        "user_id":
        user.id,


        "lesson_id":
        lessonId,


        "progress":
        value,


        "completed":
        value >= 1,


      });



    }

    catch(e){

      debugPrint(
          "Cloud save failed: $e"
      );

    }


  }









  // ==============================
  // COMPLETE LESSON
  // ==============================


  Future<void> completeLesson(

      String lessonId,

      ) async {



    if(
    _completedLessons[lessonId]
        == true
    ){

      return;

    }




    _completedLessons[lessonId] =
    true;



    _lessonProgress[lessonId] =
    1.0;



    await _saveLocal();



    await _saveCloudProgress(

      lessonId,

      1.0,

    );



    notifyListeners();


  }









  // ==============================
  // UPDATE PROGRESS
  // ==============================


  Future<void> updateLessonProgress(

      String lessonId,

      double value,

      ) async {



    final progress =
    value.clamp(
        0.0,
        1.0
    );



    _lessonProgress[lessonId] =
        progress;



    if(progress >= 1){

      _completedLessons[lessonId] =
      true;

    }



    await _saveLocal();



    await _saveCloudProgress(

      lessonId,

      progress,

    );



    notifyListeners();


  }









  // ==============================
  // CHECK
  // ==============================


  bool isCompleted(
      String lessonId
      ){

    return _completedLessons[lessonId]
        ?? false;

  }





  double getLessonProgress(
      String lessonId
      ){

    return _lessonProgress[lessonId]
        ?? 0.0;

  }





  int get completedCount {


    return _completedLessons.values
        .where(
            (value)=>value == true
    )
        .length;


  }








  // ==============================
  // CATEGORY
  // ==============================


  double categoryProgress(

      List<String> lessonIds,

      ){


    if(lessonIds.isEmpty){

      return 0;

    }



    int completed = 0;



    for(final id in lessonIds){


      if(isCompleted(id)){

        completed++;

      }

    }



    return completed /
        lessonIds.length;


  }








  // ==============================
  // TOTAL %
  // ==============================


  double get completionPercentage {


    if(_lessonProgress.isEmpty){

      return 0;

    }



    double total = 0;



    for(final value
    in _lessonProgress.values){


      total += value;


    }



    return total /
        _lessonProgress.length;


  }



}
