import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


import '../models/game_progress.dart';


class GameProvider extends ChangeNotifier {


  static const String _key =
      "game_progress_v1";



  final Map<String, GameProgress> _games = {};



  Map<String, GameProgress> get games =>
      _games;



  Future<void> load() async {


    final prefs =
        await SharedPreferences.getInstance();



    final saved =
        prefs.getString(_key);



    if(saved != null){


      final data =
          jsonDecode(saved)
          as Map<String,dynamic>;



      _games.clear();



      data.forEach((key,value){


        _games[key] =
            GameProgress(

              gameId:key,

              highScore:
                  value['score'] ?? 0,

              plays:
                  value['plays'] ?? 0,

              completed:
                  value['completed'] ?? false,

              unlocked:
                  value['unlocked'] ?? false,

            );


      });


    }



    notifyListeners();

  }







  Future<void> _save() async {


    final prefs =
        await SharedPreferences.getInstance();



    final data =
        _games.map(

          (key,value)=>MapEntry(

            key,

            {

              "score":
                  value.highScore,


              "plays":
                  value.plays,


              "completed":
                  value.completed,


              "unlocked":
                  value.unlocked,

            },

          ),

        );



    await prefs.setString(

      _key,

      jsonEncode(data),

    );

  }







  // ===========================
  // Unlock Game
  // ===========================


  void unlockGame(String gameId){


    final current =
        _games[gameId] ??
            GameProgress(
              gameId: gameId,
            );



    _games[gameId] =
        current.copyWith(

          unlocked:true,

        );


    notifyListeners();

    _save();

  }







  // ===========================
  // Start Game
  // ===========================


  void startGame(String gameId){


    final current =
        _games[gameId] ??
            GameProgress(

              gameId:gameId,

              unlocked:true,

            );



    _games[gameId] =
        current.copyWith(

          plays:
          current.plays + 1,

        );


    notifyListeners();

    _save();

  }







  // ===========================
  // Complete Game
  // ===========================


  void completeGame({

    required String gameId,

    required int score,

  }){


    final current =
        _games[gameId] ??
            GameProgress(

              gameId:gameId,

            );



    _games[gameId] =
        current.copyWith(

          highScore:
          score >
              current.highScore

              ? score

              : current.highScore,


          completed:true,

          unlocked:true,

        );



    notifyListeners();

    _save();

  }







  bool isUnlocked(String gameId){


    return _games[gameId]
        ?.unlocked ??
        false;


  }







  bool isCompleted(String gameId){


    return _games[gameId]
        ?.completed ??
        false;


  }







  int highScore(String gameId){


    return _games[gameId]
        ?.highScore ??
        0;


  }


}