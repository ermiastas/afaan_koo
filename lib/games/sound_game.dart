import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/animal_data.dart';
import '../services/audio_service.dart';
import '../models/game_item.dart';
import '../providers/reward_provider.dart';
import '../widgets/game_reward_dialog.dart';



class SoundGame extends StatefulWidget {


  final GameItem game;



  const SoundGame({

    super.key,

    required this.game,

  });



  @override
  State<SoundGame> createState()
      => _SoundGameState();


}







class _SoundGameState extends State<SoundGame>{



  late GameItem game;


  int index = 0;


  int score = 0;


  final AudioService audio =
  AudioService();




  @override
  void initState(){

    super.initState();

    game = widget.game;

  }









  void playSound(){


    final animal =
    animalData[index];


    audio.playSound(

      animal.sound,

    );


  }









  void checkAnswer(String answer){



    final animal =
    animalData[index];



    if(answer == animal.nameOromo){


      setState((){

        score++;

      });



      _showMessage(

        "Sirrii dha! ⭐",

      );



    }

    else{


      _showMessage(

        "Dogoggora. Irra deebi'i",

      );


    }






    setState((){


      if(index < animalData.length - 1){


        index++;


      }

      else{


        finishGame();


      }


    });



  }









  void finishGame(){



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









  void _showMessage(String message){



    ScaffoldMessenger.of(context)

        .showSnackBar(



      SnackBar(

        content:

        Text(message),

      ),



    );



  }









  @override
  Widget build(BuildContext context){



    final animal =
    animalData[index];



    final options =

    animalData

        .take(3)

        .map((e)=>e.nameOromo)

        .toList();



    options.shuffle();







    return Scaffold(



      appBar:

      AppBar(


        title:

        Text(

          "Sagalee Beeki 🔊 ⭐ $score",

        ),


      ),





      body:

      Padding(



        padding:

        const EdgeInsets.all(20),





        child:

        Column(



          children:[





            const Text(



              "Dhaggeeffadhu",



              style:

              TextStyle(


                fontSize:28,


                fontWeight:

                FontWeight.bold,


              ),


            ),





            const SizedBox(

              height:30,

            ),





            Image.asset(

              animal.image,

              height:150,

            ),





            const SizedBox(

              height:20,

            ),





            ElevatedButton.icon(



              onPressed:

              playSound,





              icon:

              const Icon(

                Icons.volume_up,

              ),





              label:

              const Text(

                "Sagalee Taphachiisi",

              ),



            ),





            const SizedBox(

              height:20,

            ),





            ...options.map(



                  (option)=>Padding(



                padding:

                const EdgeInsets.all(8),





                child:

                SizedBox(



                  width:

                  double.infinity,





                  child:

                  ElevatedButton(



                    onPressed:(){



                      checkAnswer(option);



                    },





                    child:

                    Text(



                      option,



                      style:

                      const TextStyle(


                        fontSize:20,


                      ),


                    ),



                  ),



                ),



              ),



            ),




          ],



        ),



      ),



    );



  }



}