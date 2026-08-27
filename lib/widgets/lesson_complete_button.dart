import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';
import '../services/raji_audio_service.dart';


class LessonCompleteButton extends StatelessWidget {


  final String lessonId;


  final VoidCallback? onCompleted;

  /// A completed lesson should lead directly into a short knowledge check.
  final bool openQuizAfterCompletion;



  const LessonCompleteButton({

    super.key,

    required this.lessonId,

    this.onCompleted,

    this.openQuizAfterCompletion = true,

  });





  @override
  Widget build(BuildContext context) {


    final progress =
        context.watch<ProgressProvider>();


    final completed =
        progress.isCompleted(lessonId);





    return SizedBox(

      width: double.infinity,


      child: ElevatedButton.icon(


        style: ElevatedButton.styleFrom(


          padding:
          const EdgeInsets.symmetric(

            vertical:15,

          ),



          backgroundColor:

          completed

          ? Colors.green

          : Colors.orange,



          shape:

          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(25),

          ),


        ),




        icon:

        Icon(

          completed

          ? Icons.check_circle

          : Icons.emoji_events,

          color: Colors.white,

        ),





        label:

        Text(

          completed

          ? "Barnoonni xumurameera ✅"

          : "Barnoota kana xumuri 🏆",


          style:

          const TextStyle(

            fontSize:18,

            fontWeight:
            FontWeight.bold,

            color:Colors.white,

          ),

        ),






        onPressed:

        completed

        ? null

        : () async {



          final progressProvider =
              context.read<ProgressProvider>();


          final reward =
              context.read<RewardProvider>();





          // =========================
          // COMPLETE LESSON PROGRESS
          // =========================


          await progressProvider.completeLesson(

            lessonId,

          );







          // =========================
          // GIVE XP + COINS + LESSON COUNT
          // =========================


          await reward.completeLesson(

            lessonId: lessonId,

          );

  await RajiAudioService.lessonComplete();





          // =========================
          // EXTRA STARS
          // =========================


          await reward.addStars(3);







          // =========================
          // CHECK BADGES
          // =========================


          await reward.checkLessonBadge(

            lessonId,

          );







          // =========================
          // OPTIONAL CALLBACK
          // =========================


          if(onCompleted != null){

            onCompleted!();

          }







          // =========================
          // MESSAGE
          // =========================


          if(context.mounted){


            ScaffoldMessenger.of(context)

            .showSnackBar(



              const SnackBar(

                content:

                Text(

                  "🎉 Gaarii! Barnoota xumurteetta +3 ⭐",

                ),

              ),



            );


          }

          // Keep the learning loop moving: each completed lesson leads to the
          // quiz screen, unless this button is itself used for a quiz.
          if (openQuizAfterCompletion &&
              lessonId != 'quiz' &&
              context.mounted) {
            Navigator.of(context).pushNamed('/quiz');
          }





        },


      ),


    );


  }


}
