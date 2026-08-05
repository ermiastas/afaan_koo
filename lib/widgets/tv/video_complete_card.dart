import 'package:flutter/material.dart';


class VideoCompleteCard extends StatelessWidget {


  final int xp;


  final VoidCallback onQuiz;



  const VideoCompleteCard({

    super.key,

    required this.xp,

    required this.onQuiz,

  });



  @override
  Widget build(BuildContext context){


    return Container(

      padding:
          const EdgeInsets.all(20),


      decoration:
      BoxDecoration(

        color:
        Colors.amber.shade100,

        borderRadius:
        BorderRadius.circular(25),

      ),


      child:
      Column(

        children:[


          const Text(

            "🎉",

            style:
            TextStyle(
              fontSize:60,
            ),

          ),



          const Text(

            "Barnoota xumurte!",

            style:
            TextStyle(

              fontSize:22,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          Text(
            "+$xp XP argatte!",
          ),



          const SizedBox(height:15),



          ElevatedButton.icon(

            onPressed:onQuiz,


            icon:
            const Icon(
              Icons.quiz,
            ),


            label:
            const Text(
              "Quiz taphadhu",
            ),

          ),



        ],

      ),


    );


  }

}
