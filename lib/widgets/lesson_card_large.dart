import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lesson_item.dart';
import '../providers/progress_provider.dart';


class LessonCardLarge extends StatelessWidget {


  final LessonItem lesson;

  final int xp;

  final bool unlocked;

  final VoidCallback onTap;



  const LessonCardLarge({

    super.key,

    required this.lesson,

    this.xp = 30,

    this.unlocked = true,

    required this.onTap,

  });





  @override
  Widget build(BuildContext context) {


    final progressProvider =
        Provider.of<ProgressProvider>(context);



    final double progress =
        progressProvider.getLessonProgress(
          lesson.id,
        );



    final bool completed =
        progressProvider.isCompleted(
          lesson.id,
        );



    final int stars =
        _calculateStars(progress);





    return GestureDetector(


      onTap:

      unlocked
          ? onTap
          : null,



      child:

      AnimatedContainer(

        duration:
        const Duration(milliseconds:400),



        margin:

        const EdgeInsets.only(
          bottom:18,
        ),



        padding:

        const EdgeInsets.all(18),




        decoration:

        BoxDecoration(



          gradient:

          LinearGradient(

            begin:
            Alignment.topLeft,


            end:
            Alignment.bottomRight,



            colors:[


              lesson.color,


              lesson.color.withValues(
                alpha:0.55,
              ),



            ],


          ),




          borderRadius:

          BorderRadius.circular(30),




          boxShadow:[



            BoxShadow(

              blurRadius:
              completed ? 18 : 8,


              offset:
              const Offset(0,6),


              color:

              Colors.black26,


            ),


          ],



        ),




        child:

        Stack(



          children:[




            Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,



              children:[



                Row(



                  children:[



                    // Emoji

                    Container(


                      width:65,

                      height:65,


                      decoration:

                      BoxDecoration(

                        color:
                        Colors.white24,


                        borderRadius:
                        BorderRadius.circular(20),


                      ),



                      child:

                      Center(

                        child:

                        Text(

                          lesson.emoji,


                          style:

                          const TextStyle(

                            fontSize:40,

                          ),

                        ),

                      ),


                    ),





                    const SizedBox(
                      width:15,
                    ),





                    Expanded(

                      child:

                      Text(

                        lesson.title,


                        style:

                        const TextStyle(

                          fontSize:22,

                          fontWeight:
                          FontWeight.bold,

                          color:
                          Colors.white,


                        ),


                      ),

                    ),



                  ],



                ),





                const SizedBox(
                  height:12,
                ),





                Text(

                  lesson.description,


                  style:

                  const TextStyle(

                    color:
                    Colors.white,


                    fontSize:16,

                  ),


                ),





                const SizedBox(
                  height:15,
                ),






                // XP badge

                Row(

                  children:[


                    _badge(

                      "+$xp XP",

                      Icons.star,

                    ),



                    const SizedBox(
                      width:10,
                    ),




                    if(completed)

                      _badge(

                        "Xumurame ✅",

                        Icons.check_circle,

                      ),


                  ],


                ),







                const SizedBox(
                  height:15,
                ),







                // Progress bar

                ClipRRect(

                  borderRadius:
                  BorderRadius.circular(20),



                  child:

                  LinearProgressIndicator(


                    value:
                    progress,


                    minHeight:
                    12,



                    backgroundColor:
                    Colors.white38,



                    color:
                    Colors.yellow,


                  ),


                ),







                const SizedBox(
                  height:10,
                ),







                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,



                  children:[



                    Text(

                      "${(progress*100).round()}%",

                      style:

                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),





                    Text(

                      _starsText(stars),


                      style:

                      const TextStyle(

                        fontSize:24,

                      ),


                    ),



                  ],


                ),




              ],


            ),






            if(!unlocked)

              const Positioned(

                right:5,

                top:5,


                child:

                Icon(

                  Icons.lock,

                  color:
                  Colors.white,

                  size:35,

                ),

              ),




          ],


        ),



      ),


    );


  }







  int _calculateStars(double progress){


    if(progress >= 1.0){

      return 3;

    }


    if(progress >=0.66){

      return 2;

    }


    if(progress >0){

      return 1;

    }


    return 0;


  }







  String _starsText(int stars){


    switch(stars){


      case 3:

        return "🥇⭐⭐⭐";


      case 2:

        return "🥈⭐⭐";


      case 1:

        return "🥉⭐";


      default:

        return "🏆";

    }


  }







  Widget _badge(

      String text,

      IconData icon,

      ){



    return Container(


      padding:

      const EdgeInsets.symmetric(

        horizontal:12,

        vertical:6,

      ),



      decoration:

      BoxDecoration(


        color:
        Colors.white,


        borderRadius:

        BorderRadius.circular(20),


      ),



      child:

      Row(

        children:[


          Icon(

            icon,

            size:18,

            color:
            Colors.orange,

          ),



          const SizedBox(
            width:5,
          ),



          Text(

            text,


            style:

            TextStyle(

              color:
              lesson.color,


              fontWeight:
              FontWeight.bold,


            ),


          ),



        ],


      ),


    );


  }


}