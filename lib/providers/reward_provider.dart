import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student_reward.dart';

import '../services/supabase_service.dart';

import '../models/badge_item.dart';

import '../data/badge_data.dart';

import '../data/badge_rules.dart';



class RewardProvider extends ChangeNotifier {



  // ==========================================
  // BADGES
  // ==========================================


  final List<BadgeItem> _badges =
      List.from(badgeData);



  final List<String> _unlockedBadges = [];



  List<BadgeItem> get badges =>
      _badges;



  List<String> get unlockedBadges =>
      _unlockedBadges;




  static const String _rewardKey =
      "reward_data_v1";


  static const String _badgeKey =
      "unlocked_badges_v1";


  static const String _gameRewardKey =
      "completed_games_v1";

  // ==========================================
  // REWARD VALUES
  // ==========================================


  int xp = 0;


  int _coins = 0;


  int _stars = 0;


  int lessons = 0;


  int gamesCompleted = 0;



  int get coins =>
      _coins;



  int get stars =>
      _stars;



  int get level {

    return (xp ~/ 100) + 1;

  }




  double get levelProgress {


    final currentXP =
        xp % 100;


    return currentXP / 100;

  }






  // ==========================================
  // TRACKING
  // ==========================================


  final Map<String,bool> completedGames = {};



  final List<String> completedLessons = [];





  // ==========================================
  // STUDENT REWARDS
  // ==========================================


  final List<StudentReward> _studentRewards = [];



  List<StudentReward> get studentRewards =>
      _studentRewards;




  SupabaseClient get _supabase =>
      SupabaseService.client!;





  // ==========================================
  // LOAD
  // ==========================================


  Future<void> load() async {


    await _loadLocal();


    await _loadBadges();


    await _loadCloud();


    notifyListeners();

  }

  /// Removes local reward state after a parent explicitly confirms a reset.
  Future<void> resetLocalRewards() async {
    xp = 0;
    _coins = 0;
    _stars = 0;
    lessons = 0;
    gamesCompleted = 0;
    completedGames.clear();
    completedLessons.clear();
    _unlockedBadges.clear();
    _studentRewards.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rewardKey);
    await prefs.remove(_badgeKey);
    await prefs.remove(_gameRewardKey);
    notifyListeners();
  }






  // ==========================================
  // LOCAL LOAD
  // ==========================================


  Future<void> _loadLocal() async {

    
    




    final prefs =
        await SharedPreferences.getInstance();



    final savedGames =
    prefs.getStringList(_gameRewardKey);


if(savedGames != null){

  completedGames.clear();


  for(final game in savedGames){

    completedGames[game] = true;

  }

}

    final data =
        prefs.getString(_rewardKey);



    if(data == null){

      return;

    }



    final json =
        jsonDecode(data);



    xp =
        json['xp'] ?? 0;



    _coins =
        json['coins'] ?? 0;



    _stars =
        json['stars'] ?? 0;



    lessons =
        json['lessons'] ?? 0;



    gamesCompleted =
        json['games'] ?? 0;




    if(json['completedLessons'] != null){


      completedLessons.clear();


      completedLessons.addAll(

        List<String>.from(

          json['completedLessons'],

        ),

      );


    }



  }







  Future<void> _saveLocal() async {


    final prefs =
        await SharedPreferences.getInstance();




    await prefs.setString(


      _rewardKey,


      jsonEncode({



        "xp":xp,


        "coins":_coins,


        "stars":_stars,


        "lessons":lessons,


        "games":gamesCompleted,


        "completedLessons":
        completedLessons,



      }),



    );

  await prefs.setStringList(

  _gameRewardKey,

  completedGames.keys.toList(),

);



  }








  // ==========================================
  // BADGE STORAGE
  // ==========================================


  Future<void> _loadBadges() async {


    final prefs =
        await SharedPreferences.getInstance();



    final saved =
        prefs.getStringList(_badgeKey);



    if(saved != null){


      _unlockedBadges.clear();


      _unlockedBadges.addAll(saved);


    }


  }







  Future<void> _saveBadges() async {


    final prefs =
        await SharedPreferences.getInstance();



    await prefs.setStringList(

      _badgeKey,

      _unlockedBadges,

    );


  }







  void unlockBadge(String id){


    if(_unlockedBadges.contains(id)){

      return;

    }


    _unlockedBadges.add(id);


    _saveBadges();


    notifyListeners();


  }







  void checkBadges(){


    if(lessons >= 5){

      unlockBadge("alphabet");

    }



    if(lessons >= 10){

      unlockBadge("animals");

    }



    if(gamesCompleted >= 5){

      unlockBadge("games");

    }




    if(
    lessons >= 50 &&
    gamesCompleted >= 10
    ){

      unlockBadge("master");

    }


  }








  // ==========================================
  // CLOUD LOAD
  // ==========================================


  Future<void> _loadCloud() async {


    try{


      final user =
          SupabaseService.currentUser;



      if(user == null){

        return;

      }




      final result =

      await _supabase

          .from('rewards')

          .select()

          .eq(
          'user_id',
          user.id
      )

          .maybeSingle();




      if(result != null){


        xp =
            result['xp'] ?? xp;



        _coins =
            result['coins'] ?? _coins;



        _stars =
            result['stars'] ?? _stars;



        lessons =
            result['lessons_completed']
            ?? lessons;



        gamesCompleted =
            result['games_completed']
            ?? gamesCompleted;


      }



    }

    catch(e){

      debugPrint(
          "Reward cloud load error: $e"
      );

    }



  }








  // ==========================================
  // CLOUD SAVE
  // ==========================================


  Future<void> _saveCloud() async {


    try{


      final user =
          SupabaseService.currentUser;



      if(user == null){

        return;

      }




      await _supabase

          .from('rewards')

          .upsert({



        "user_id":
        user.id,



        "xp":
        xp,



        "coins":
        _coins,



        "stars":
        _stars,



        "lessons_completed":
        lessons,



        "games_completed":
        gamesCompleted,



        "updated_at":
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






  Future<void> _save() async {


    await _saveLocal();


    await _saveCloud();


    notifyListeners();


  }







  // ==========================================
  // ADD XP
  // ==========================================


  Future<void> addXP(int amount) async {


    xp += amount;


    checkBadges();


    await _save();


  }







  // ==========================================
  // ADD STARS
  // ==========================================


  Future<void> addStars(int amount) async {


    _stars += amount;


    checkBadges();


    await _save();


  }







  // ==========================================
  // ADD COINS
  // ==========================================


  Future<void> addCoins(int amount) async {


    _coins += amount;


    await _save();


  }








  // ==========================================
  // COMPLETE LESSON
  // ==========================================


  Future<void> completeLesson({

    required String lessonId,

  }) async {



    if(completedLessons.contains(lessonId)){

      return;

    }



    completedLessons.add(lessonId);



    lessons++;


    xp += 10;


    _coins += 2;



    await checkLessonBadge(

      lessonId,

    );



    checkBadges();



    await _save();



  }








  // ==========================================
  // COMPLETE GAME
  // ==========================================

/*
  Future<void> completeGame({

    required int xp,

    required int coins,

    required int stars,

    required String gameId,


  }) async {



    if(completedGames[gameId] == true){

      return;

    }



    this.xp += xp;


    _coins += coins;


    _stars += stars;



    gamesCompleted++;



    completedGames[gameId] = true;



    checkBadges();



    await _save();



  }

*/

Future<void> completeGame({

  required int xp,

  required int coins,

  required int stars,

  required String gameId,

}) async {



  // Prevent duplicate rewards

  if(completedGames[gameId] == true){

    return;

  }



  // Add rewards

  this.xp += xp;

  _coins += coins;

  _stars += stars;



  // Count completed games

  gamesCompleted++;



  // Mark game completed

  completedGames[gameId] = true;



  // Check badges

  checkBadges();



  // Save data

  await _save();



  // Update UI

  notifyListeners();


}




  // ==========================================
  // CATEGORY BADGES
  // ==========================================


  Future<void> completeCategoryBadge(
      String badgeId
      ) async {



    unlockBadge(badgeId);



    await _saveBadges();



    notifyListeners();



  }








  Future<void> checkLessonBadge(

      String lessonId

      ) async {



    final badgeId =
    badgeRules[lessonId];



    if(badgeId == null){

      return;

    }




    await completeCategoryBadge(

        badgeId

    );



  }








  // ==========================================
  // TEACHER REWARD
  // ==========================================


  Future<void> giveStudentReward({

    required String studentId,

    required String title,

    required String description,

    required int xp,

    required int stars,

    required String badge,


  }) async {



    final reward = StudentReward(


      id:

      DateTime.now()
          .millisecondsSinceEpoch
          .toString(),


      studentId:
      studentId,


      title:
      title,


      description:
      description,


      xp:
      xp,


      stars:
      stars,


      badge:
      badge,


      date:
      DateTime.now(),



    );




    _studentRewards.add(reward);



    this.xp += xp;


    _stars += stars;



    checkBadges();



    await _save();



    notifyListeners();



  }





}
