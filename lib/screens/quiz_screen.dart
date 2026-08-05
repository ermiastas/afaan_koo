import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../models/quiz_type.dart';

import '../services/content_service.dart';

import '../providers/reward_provider.dart';
import '../providers/progress_provider.dart';

import '../data/lesson_ids.dart';

import '../services/raji_audio_service.dart';
import '../widgets/alphabet_tracing_widget.dart';
import '../widgets/raji_assistant.dart';
import '../widgets/tracing/number_tracing_widget.dart';
import '../widgets/app_states.dart';



class QuizScreen extends StatefulWidget {


  const QuizScreen({

    super.key,

  });



  @override
  State<QuizScreen> createState()

  => _QuizScreenState();


}





class _QuizScreenState

extends State<QuizScreen>{



  final ContentService service =

  ContentService();



  late Future<List<Quiz>> quizzes;



  int currentIndex = 0;


  int correctAnswers = 0;


  bool answered = false;






  @override
  void initState(){

    super.initState();

    quizzes = service.getQuizzes();

  }









  void checkAnswer(

      String selected,

      Quiz quiz,

      List<Quiz> quizList,

      ){



    if(answered){

      return;

    }



    setState((){

      answered = true;

    });





    final reward =

    context.read<RewardProvider>();





    if(selected == quiz.answer){



      setState((){

        correctAnswers++;

      });



      reward.addStars(1);



      showMessage(

        "Baay'ee gaarii! ⭐",

      );



    }

    else{



      showMessage(

        "Irra deebi'ii yaali 😊",

      );



    }



    nextQuestion(quizList);



  }










  void nextQuestion(

      List<Quiz> quizList,

      ){



    Future.delayed(

      const Duration(

        milliseconds:700,

      ),



          (){


        if(!mounted){

          return;

        }



        if(currentIndex < quizList.length - 1){



          setState((){


            currentIndex++;


            answered=false;


          });



        }

        else{



          finishQuiz(

            quizList.length,

          );



        }



      },

    );


  }









  Future<void> finishQuiz(

      int total,

      ) async {



    final progress =

    context.read<ProgressProvider>();


    final reward =

    context.read<RewardProvider>();







    await progress.completeLesson(

      LessonIds.quiz,

    );







    await reward.completeLesson(

      lessonId:

      LessonIds.quiz,

    );

    const RajiAssistant(
      message: "Mee irra deebi'i 😊",
      
    );
await RajiAudioService.wrong();

const RajiAssistant(

  celebrate: true,

  message:
      "Baay'ee gaarii! ⭐",

);

await RajiAudioService.correct();

    await reward.addStars(

      correctAnswers,

    );







    if(!mounted){

      return;

    }







    showDialog(

      context:context,


      builder:(context){



        return AlertDialog(



          shape:

          RoundedRectangleBorder(

            borderRadius:

            BorderRadius.circular(25),

          ),





          title:

          const Text(

            "🎉 Xumurteetta!",

            textAlign:

            TextAlign.center,

          ),





          content:

          Text(



            "Deebii sirrii:\n"

                "$correctAnswers / $total\n\n"

                "⭐ Urjii argatte: "

                "$correctAnswers",



            textAlign:

            TextAlign.center,



          ),





          actions:[



            Center(

              child:

              TextButton(



                onPressed:(){


                  Navigator.pop(context);



                  setState((){


                    currentIndex=0;


                    correctAnswers=0;


                    answered=false;



                  });



                },



                child:

                const Text(

                  "Deebi'i",

                  style:

                  TextStyle(

                    fontSize:18,

                  ),

                ),

              ),

            )



          ],



        );

      },

    );



  }









  void showMessage(String message){


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



    return Scaffold(



      appBar:

      AppBar(



        title:

        const Text(

          "Quiz ⭐",

        ),



        centerTitle:true,

      ),





      body:

      FutureBuilder<List<Quiz>>(



        future:

        quizzes,



        builder:

            (context,snapshot){



          if(snapshot.connectionState ==

              ConnectionState.waiting){



            return const AppLoadingState(
              label: 'Loading quiz…',
            );


          }





          if(snapshot.hasError){



            return AppErrorState(
              message: 'The quiz could not be loaded. Please try again.',
              onRetry: () => setState(() {
                quizzes = service.getQuizzes();
              }),
            );

          }







          final quizList =

          snapshot.data ?? [];







          if(quizList.isEmpty){



            return const AppEmptyState(
              title: 'Quiz hin jiru',
              message: 'Quiz tokko yeroo dhiyootti daballa.',
              icon: Icons.quiz_outlined,
            );

          }








          final quiz =

          quizList[currentIndex];








          return SingleChildScrollView(



            padding:

            const EdgeInsets.all(20),



            child:

            Column(



              children:[





                Text(

                  "Gaaffii ${currentIndex+1}/${quizList.length}",

                  style:

                  const TextStyle(

                    fontSize:18,

                  ),

                ),





                const SizedBox(

                  height:15,

                ),






                Text(

                  quiz.question,

                  textAlign:

                  TextAlign.center,

                  style:

                  const TextStyle(

                    fontSize:25,

                    fontWeight:

                    FontWeight.bold,

                  ),

                ),





                const SizedBox(

                  height:20,

                ),







                if(quiz.type ==

                    QuizType.alphabetTracing)



                  AlphabetTracingWidget(



                    capitalLetter:

                    quiz.tracingLetter ??

                        quiz.answer,



                    smallLetter:

                    quiz.tracingSmallLetter ??

                        "",



                    onComplete:(){



                      context

                          .read<RewardProvider>()

                          .addStars(5);



                    },



                  )







                else if(quiz.type ==

                    QuizType.numberTracing)



                  NumberTracingWidget(



                    number:

                    quiz.numberToTrace ??

                        int.tryParse(

                          quiz.answer,

                        ) ??

                        0,



                    onComplete:(){



                      context

                          .read<RewardProvider>()

                          .addStars(5);



                    },



                  )







                else ...[





                  buildQuizImage(

                    quiz.image,

                  ),





                  const SizedBox(

                    height:25,

                  ),







                  ...quiz.options.map((option){



                    return SizedBox(



                      width:

                      double.infinity,



                      child:

                      Padding(



                        padding:

                        const EdgeInsets.symmetric(

                          vertical:5,

                        ),



                        child:

                        ElevatedButton(



                          onPressed:

                          answered

                              ? null

                              :

                              (){



                            checkAnswer(

                              option,

                              quiz,

                              quizList,

                            );



                          },



                          child:

                          Text(

                            option,

                            style:

                            const TextStyle(

                              fontSize:18,

                            ),

                          ),



                        ),

                      ),

                    );



                  }),



                ],



              ],

            ),

          );



        },

      ),


    );


  }









  Widget buildQuizImage(String image){



    if(image.isEmpty){



      return const Icon(

        Icons.quiz,

        size:100,

      );

    }





    if(image.startsWith("/")){



      return Image.file(

        File(image),

        height:150,

        errorBuilder:

            (context,error,stack){

          return const Icon(

            Icons.broken_image,

            size:100,

          );

        },

      );


    }







    return Image.asset(

      image,

      height:150,

      errorBuilder:

          (context,error,stack){


        return const Icon(

          Icons.broken_image,

          size:100,

        );


      },

    );


  }



}
