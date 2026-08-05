import 'package:flutter/material.dart';

import '../models/math_lesson.dart';
import '../widgets/lesson_complete_button.dart';


class MathLessonDetailScreen extends StatelessWidget {


  final MathLesson lesson;



  const MathLessonDetailScreen({

    super.key,

    required this.lesson,

  });





  void openGame(BuildContext context){


    String? route;



    switch(lesson.id){


      case "counting":

        route = "/counting_game";

        break;



      case "addition":

        route = "/addition_game";

        break;



      case "subtraction":

        route = "/subtraction_game";

        break;



      case "multiplication":

        route = "/multiplication_game";

        break;



      case "division":

        route = "/division_game";

        break;



      case "fractions":

        route = "/fraction_game";

        break;



      case "money":

        route = "/money_math_game";

        break;



      case "time":

        route = "/time_math_game";

        break;



      default:

        route = null;

    }





    if(route != null){


      Navigator.pushNamed(

        context,

        route,

      );


    }

    else{


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:

          Text(

            "🎮 Taphaan kun yeroo gabaabaa keessatti ni dhufa!",

          ),

        ),

      );


    }


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:

      AppBar(

        title:

        Text(

          lesson.titleOromo,

        ),

        centerTitle:true,

      ),






      body:

      SingleChildScrollView(



        padding:

        const EdgeInsets.all(20),





        child:

        Column(



          children:[





            // Lesson Icon

            Container(

              padding:

              const EdgeInsets.all(25),


              decoration:

              BoxDecoration(

                color:

                lesson.color.withValues(alpha:.15),


                shape:

                BoxShape.circle,

              ),



              child:

              Icon(

                lesson.icon,

                size:

                110,

                color:

                lesson.color,

              ),


            ),







            const SizedBox(height:25),







            Text(



              lesson.titleOromo,



              textAlign:

              TextAlign.center,



              style:

              const TextStyle(



                fontSize:32,

                fontWeight:

                FontWeight.bold,



              ),



            ),






            const SizedBox(height:15),







            Text(



              lesson.titleEnglish,



              style:

              const TextStyle(



                fontSize:20,

                color:

                Colors.grey,



              ),



            ),







            const SizedBox(height:25),






            Text(



              lesson.description,



              textAlign:

              TextAlign.center,



              style:

              const TextStyle(



                fontSize:22,



              ),



            ),







            const SizedBox(height:30),






            // Raji Message

            Container(



              width:

              double.infinity,



              padding:

              const EdgeInsets.all(20),





              decoration:

              BoxDecoration(



                gradient:

                LinearGradient(



                  colors:[

                    lesson.color.withValues(alpha:.25),

                    Colors.white,

                  ],

                ),



                borderRadius:

                BorderRadius.circular(25),



              ),






              child:

              const Text(



                "😊 Raji:\n"

                "Herrega barachuun tapha bareedaa dha! "

                "Yaalii godhi, ati ni dandeessa!",



                textAlign:

                TextAlign.center,



                style:

                TextStyle(



                  fontSize:18,

                  fontWeight:

                  FontWeight.w600,



                ),



              ),



            ),






            const SizedBox(height:30),







            // Start Game Button

            SizedBox(

              width:

              double.infinity,



              child:

              ElevatedButton.icon(



                onPressed:

                (){

                  openGame(context);

                },



                icon:

                const Icon(

                  Icons.play_arrow,

                  size:30,

                ),




                label:

                const Text(

                  "🎮 Tapha Jalqabi",

                  style:

                  TextStyle(

                    fontSize:22,

                    fontWeight:

                    FontWeight.bold,

                  ),

                ),



                style:

                ElevatedButton.styleFrom(



                  padding:

                  const EdgeInsets.symmetric(

                    vertical:16,

                  ),



                  shape:

                  RoundedRectangleBorder(



                    borderRadius:

                    BorderRadius.circular(25),



                  ),



                ),



              ),

            ),








            const SizedBox(height:35),







            LessonCompleteButton(



              lessonId:

              "math_${lesson.id}",



            ),





          ],



        ),



      ),



    );



  }


}