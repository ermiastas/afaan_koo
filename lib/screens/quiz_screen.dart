import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../services/content_service.dart';
import '../providers/reward_provider.dart';



class QuizScreen extends StatefulWidget {


  const QuizScreen({super.key});


  @override
  State<QuizScreen> createState()
  => _QuizScreenState();


}



class _QuizScreenState extends State<QuizScreen>{


  final ContentService service =
  ContentService();



  late Future<List<Quiz>> quizzes;



  int index = 0;

  int correctAnswers = 0;



  @override
  void initState(){

    super.initState();

    quizzes =
    service.getQuizzes();

  }




  void checkAnswer(
      String selectedAnswer,
      Quiz quiz,
      List<Quiz> quizList
      ){


    final reward =
    Provider.of<RewardProvider>(
      context,
      listen:false,
    );



    if(selectedAnswer == quiz.answer){


      setState((){

        correctAnswers++;

      });



      reward.addStars(1);



      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:

          Text(
              "Baay'ee gaarii! ⭐"
          ),

        ),

      );


    }

    else{


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:

          Text(
              "Irra deebi'ii yaali"
          ),

        ),

      );


    }




    Future.delayed(

      const Duration(milliseconds:500),

          (){


        if(!mounted) return;



        if(index < quizList.length - 1){


          setState((){

            index++;

          });


        }

        else{


          showDialog(

            context:context,

            builder:(context){


              return AlertDialog(

                title:

                const Text(
                    "Xumurteetta! 🎉"
                ),


                content:

                Text(

                    "Deebii sirrii: $correctAnswers / ${quizList.length}\n\n"
                        "Urjii argatte: ⭐ $correctAnswers"

                ),



                actions:[


                  TextButton(

                    onPressed:(){

                      Navigator.pop(context);

                    },

                    child:

                    const Text(
                        "Tole"
                    ),

                  )


                ],


              );


            },

          );


        }


      },

    );


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:

        const Text(
            "Quiz ⭐"
        ),

      ),





      body:

      FutureBuilder<List<Quiz>>(


        future:
        quizzes,



        builder:
            (context,snapshot){


          if(snapshot.connectionState ==
              ConnectionState.waiting){


            return const Center(

              child:

              CircularProgressIndicator(),

            );


          }




          if(snapshot.hasError){


            return Center(

              child:

              Text(

                "Dogoggora: ${snapshot.error}",

              ),

            );


          }




          final quizList =
              snapshot.data ?? [];



          if(quizList.isEmpty){


            return const Center(

              child:

              Text(
                  "Quiz hin jiru"
              ),

            );


          }




          final quiz =
          quizList[index];





          return Padding(

            padding:
            const EdgeInsets.all(20),


            child:

            Column(


              children:[



                Text(

                  "Gaaffii ${index + 1}/${quizList.length}",

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





                Image.asset(

                  quiz.image,

                  height:150,

                ),





                const SizedBox(
                  height:20,
                ),





                ...quiz.options.map(

                      (option){


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

                          onPressed:(){

                            checkAnswer(

                              option,

                              quiz,

                              quizList,

                            );


                          },


                          child:

                          Text(

                              option

                          ),

                        ),

                      ),

                    );


                  },


                ),




              ],

            ),


          );


        },

      ),


    );


  }


}