import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/lesson_theme.dart';


class AnimatedLessonCard extends StatefulWidget {

  final LessonTheme theme;

  final String subtitle;

  final double progress;

  final bool completed;

  final bool locked;

  final VoidCallback onTap;


  const AnimatedLessonCard({

    super.key,

    required this.theme,

    required this.subtitle,

    required this.progress,

    required this.onTap,

    this.completed = false,

    this.locked = false,

  });


  @override
  State<AnimatedLessonCard> createState() =>
      _AnimatedLessonCardState();

}




class _AnimatedLessonCardState
    extends State<AnimatedLessonCard>
    with TickerProviderStateMixin {



  late AnimationController bubbleController;

  late AnimationController glowController;

  late AnimationController bounceController;



  @override
  void initState(){

    super.initState();


    bubbleController = AnimationController(

      vsync:this,

      duration:

      const Duration(seconds:6),

    )..repeat();



    glowController = AnimationController(

      vsync:this,

      duration:

      const Duration(seconds:2),

    )..repeat(reverse:true);



    bounceController = AnimationController(

      vsync:this,

      duration:

      const Duration(milliseconds:200),

    );

  }




  @override
  void dispose(){

    bubbleController.dispose();

    glowController.dispose();

    bounceController.dispose();

    super.dispose();

  }




  void tap(){


    bounceController.forward().then((_) {

      bounceController.reverse();

    });


    widget.onTap();

  }





  String getStars(){


    int total = 5;


    int filled =

    (widget.progress * total)

        .round();


    return

    "⭐"*filled +

    "☆"*(total-filled);


  }





  @override
  Widget build(BuildContext context){


    return AnimatedBuilder(

      animation:

      Listenable.merge([

        bubbleController,

        glowController,

        bounceController,

      ]),


      builder:(context,child){



        final scale =

        1 -

        (bounceController.value * 0.05);



        return Transform.scale(

          scale:scale,


          child:

          GestureDetector(

            onTap:

            widget.locked

                ? null

                : tap,


            child:

            Container(

              decoration:

              BoxDecoration(

                borderRadius:

                BorderRadius.circular(28),



                gradient:

                LinearGradient(

                  colors:[

                    widget.theme.startColor,

                    widget.theme.endColor,

                  ],

                ),



                boxShadow:[

                  BoxShadow(

                    color:

                    widget.theme.startColor

                        .withValues(

                      alpha:

                      0.25 +

                          glowController.value *

                              0.25,

                    ),

                    blurRadius:20,

                    spreadRadius:3,

                  )

                ],


              ),



              child:

              Stack(

                children:[


                  // bubbles

                  Positioned(

                    top:

                    20 +

                    sin(

                    bubbleController.value *

                        2 *

                        pi

                    ) *

                    10,


                    right:20,


                    child:

                    bubble(),

                  ),




                  if(widget.locked)

                    Center(

                      child:

                      Container(

                        padding:

                        const EdgeInsets.all(20),

                        decoration:

                        BoxDecoration(

                          color:

                          Colors.black45,

                          borderRadius:

                          BorderRadius.circular(50),

                        ),


                        child:

                        const Icon(

                          Icons.lock,

                          color:

                          Colors.white,

                          size:40,

                        ),

                      ),

                    ),





                  Padding(

                    padding:

                    const EdgeInsets.all(15),


                    child:

                    Column(

                      mainAxisAlignment:

                      MainAxisAlignment.center,


                      children:[



                        Expanded(

                          child:

                          Image.asset(

                            widget.theme.image,

                            fit:

                            BoxFit.contain,


                            errorBuilder:

                            (_,__,___)=>Icon(

                              widget.theme.icon,

                              size:70,

                              color:

                              Colors.white,

                            ),

                          ),

                        ),




                        Text(

                          widget.theme.title,


                          style:

                          const TextStyle(

                            color:

                            Colors.white,

                            fontSize:20,

                            fontWeight:

                            FontWeight.bold,

                          ),

                        ),




                        const SizedBox(height:5),




                        Text(

                          widget.subtitle,


                          style:

                          const TextStyle(

                            color:

                            Colors.white70,

                          ),

                        ),




                        const SizedBox(height:5),




                        Text(

                          getStars(),

                          style:

                          const TextStyle(

                            fontSize:18,

                          ),

                        ),




                        if(widget.completed)

                          const Text(

                            "🏆 Xumureera",

                            style:

                            TextStyle(

                              color:

                              Colors.white,

                              fontWeight:

                              FontWeight.bold,

                            ),

                          ),



                      ],

                    ),

                  ),


                ],

              ),

            ),

          ),

        );

      },

    );


  }





  Widget bubble(){


    return Container(

      width:35,

      height:35,


      decoration:

      BoxDecoration(

        color:

        Colors.white

            .withValues(alpha:.2),

        shape:

        BoxShape.circle,

      ),

    );


  }



}
