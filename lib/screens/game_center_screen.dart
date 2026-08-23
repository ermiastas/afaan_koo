import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reward_provider.dart';

import '../data/game_data.dart';
import '../models/game_item.dart';

import '../games/letter_game.dart';
import '../games/matching_game.dart';
import '../games/memory_game.dart';
import '../games/sound_game.dart';
import '../games/balloon_count_game.dart';
import '../games/alphabet_tracing_game.dart';
import '../games/handwriting_trace_game.dart';
import '../utils/responsive.dart';



class GameCenterScreen extends StatelessWidget {


  const GameCenterScreen({
    super.key,
  });



  Color _categoryColor(String category){


    switch(category){


      case "Language":
        return Colors.orange;


      case "Nature":
        return Colors.green;


      case "Health":
        return Colors.pink;


      case "Culture":
        return Colors.brown;


      default:
        return Colors.blue;


    }

  }




  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:

        const Text(
          "Taphoota Koo 🎮",
        ),

      ),




      body:

      Consumer<RewardProvider>(

        builder:(context,reward,child){


          return GridView.builder(


            padding:

            EdgeInsets.all(Responsive.pagePadding(context)),



            gridDelegate:

            SliverGridDelegateWithFixedCrossAxisCount(


              crossAxisCount:

              Responsive.homeColumns(context, max: 5),


              crossAxisSpacing:

              12,


              mainAxisSpacing:

              12,

              childAspectRatio: 0.82,


            ),




            itemCount:

            games.length,




            itemBuilder:

            (context,index){



              final originalGame = games[index];



              final game = GameItem(


                id: originalGame.id,


                title: originalGame.title,


                description: originalGame.description,


                icon: originalGame.icon,


                iconData: originalGame.iconData,


                rewardXP: originalGame.rewardXP,


                rewardCoins: originalGame.rewardCoins,


                unlocked: originalGame.unlocked,


                category: originalGame.category,


                completed:

                reward.completedGames[originalGame.id]
                    ??
                    false,


              );




              return gameCard(

                context,

                game,

              );


            },


          );


        },


      ),


    );


  }






Widget gameCard(

    BuildContext context,

    GameItem game,

){

  return InkWell(


    onTap:

    game.unlocked

    ?

    (){

      openGame(

        context,

        game,

      );


    }

    :

    null,



    borderRadius:

    BorderRadius.circular(25),




    child:

    Container(



      decoration:

      BoxDecoration(



        gradient:

        LinearGradient(



          colors:


          game.unlocked


          ?


          [

            _categoryColor(game.category),

            _categoryColor(game.category)
                .withValues(alpha:0.65),


          ]


          :


          [

            Colors.grey,

            Colors.grey.shade700,

          ],


        ),




        borderRadius:

        BorderRadius.circular(25),



        boxShadow:[


          const BoxShadow(

            blurRadius:6,

            offset:

            Offset(0,4),

            color:

            Colors.black26,

          ),


        ],



      ),




      child:

      Stack(


        children:[



          Center(


            child:

            Column(


              mainAxisAlignment:

              MainAxisAlignment.center,



              children:[



                Text(

                  game.icon,

                  style:

                  const TextStyle(

                    fontSize:50,

                  ),

                ),



                const SizedBox(height:10),




                Text(

                  game.title,


                  textAlign:

                  TextAlign.center,



                  style:

                  const TextStyle(

                    fontSize:18,

                    fontWeight:

                    FontWeight.bold,

                    color:

                    Colors.white,

                  ),

                ),




                const SizedBox(height:5),




                Text(

                  "+${game.rewardXP} XP",

                  style:

                  const TextStyle(

                    color:

                    Colors.white,

                  ),

                ),




                const SizedBox(height:5),




                Text(

                  game.completed

                  ?

                  "✅ Xumurame"

                  :

                  "🪙 ${game.rewardCoins}",


                  style:

                  const TextStyle(

                    color:

                    Colors.white,

                    fontWeight:

                    FontWeight.bold,

                  ),

                ),



              ],


            ),



          ),




          if(!game.unlocked)

          const Positioned(

            right:10,

            top:10,

            child:

            Icon(

              Icons.lock,

              color:

              Colors.white,

            ),

          ),



        ],


      ),


    ),


  );

}






void openGame(

    BuildContext context,

    GameItem game,

){


switch(game.id){

case "handwriting_trace":

Navigator.push(context, MaterialPageRoute(builder: (_) => HandwritingTraceGame(game: game)));

break;

case "alphabet_trace":

Navigator.push(context, MaterialPageRoute(builder: (_) => AlphabetTracingGame(game: game)));

break;

case "balloon_count":

Navigator.push(context, MaterialPageRoute(builder: (_) => BalloonCountGame(game: game)));

break;



case "alphabet_match":


Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

LetterGame(game:game),

),

);


break;




case "word_memory":


Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

MemoryGame(

game:game,

),

),

);


break;




case "animal_quiz":


Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

MatchingGame(

game:game,

),

),

);


break;




case "listening":


Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

SoundGame(

game:game,

),

),

);


break;


}



}



}
