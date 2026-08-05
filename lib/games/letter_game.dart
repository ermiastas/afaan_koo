import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/alphabet_data.dart';
import '../models/game_item.dart';
import '../providers/reward_provider.dart';
import '../widgets/game_reward_dialog.dart';



class LetterGame extends StatefulWidget {


  final GameItem game;



  const LetterGame({

    super.key,

    required this.game,

  });



  @override
  State<LetterGame> createState()
      => _LetterGameState();


}





class _LetterGameState extends State<LetterGame> {


  late GameItem game;


  final Random random = Random();


  int index = 0;


  int score = 0;


  List<String> options = [];



  @override
  void initState() {


    super.initState();


    game = widget.game;


    generateOptions();


  }







  void generateOptions() {


    final current = letters[index];



    final answers = letters

        .map((e) => e.example)

        .where(
          (e) => e != current.example,
        )

        .toList();



    answers.shuffle();



    options = [

      current.example,

      ...answers.take(3),

    ];



    options.shuffle();


  }








  void checkAnswer(String answer) {


    final current = letters[index];



    if(answer == current.example){


      score++;


      showMessage(
        "Sirrii dha! ⭐",
      );


    }

    else{


      showMessage(
        "Irra deebi'ii yaali.",
      );


    }



    setState((){


      if(index < letters.length - 1){


        index++;


      }

      else{


        gameFinished();


        return;


      }



      generateOptions();


    });



  }








  void gameFinished(){



    context

        .read<RewardProvider>()

        .completeGame(


          xp:

          game.rewardXP,


          coins:

          game.rewardCoins,


          stars:

          game.rewardStars,


          gameId:

          game.id,


        );





    showDialog(


      context:context,


      builder:(_)=>


      GameRewardDialog(


        xp:

        game.rewardXP,


        coins:

        game.rewardCoins,


      ),


    );



  }









  void showMessage(String text) {


    ScaffoldMessenger.of(context)

        .showSnackBar(


      SnackBar(

        content:

        Text(text),

      ),


    );


  }









  @override
  Widget build(BuildContext context) {


    final current = letters[index];



    return Scaffold(



      appBar:

      AppBar(


        title:

        Text(

          "Qubee Walitti Qabi ⭐ $score",

        ),


      ),





      body:

 
      SafeArea(
  child: SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            current.uppercase,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            current.lowercase,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 60,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          Image.asset(
            current.image,
            height: 150,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 25),

          ...options.map(
            (word) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () => checkAnswer(word),
                  child: Text(
                    word,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),

    );


  }



}