import 'package:flutter/material.dart';


class DailyChallengeCard extends StatefulWidget {

  final String title;

  final String description;

  final int rewardXP;

  final VoidCallback onTap;


  const DailyChallengeCard({

    super.key,

    required this.title,

    required this.description,

    required this.rewardXP,

    required this.onTap,

  });


  @override
  State<DailyChallengeCard> createState() =>
      _DailyChallengeCardState();

}



class _DailyChallengeCardState
    extends State<DailyChallengeCard>
    with SingleTickerProviderStateMixin {


  late AnimationController _controller;


  @override
  void initState() {

    super.initState();


    _controller = AnimationController(

      vsync: this,

      duration:
      const Duration(seconds:2),

    )..repeat(reverse:true);

  }



  @override
  void dispose(){

    _controller.dispose();

    super.dispose();

  }




  @override
  Widget build(BuildContext context) {


    return Padding(

      padding:
      const EdgeInsets.symmetric(
        horizontal:20,
        vertical:10,
      ),


      child: AnimatedBuilder(

        animation:_controller,


        builder:(context,child){


          return Transform.translate(

            offset:Offset(

              0,

              -3 *
              _controller.value,

            ),


            child:child,

          );


        },


        child:InkWell(

          borderRadius:
          BorderRadius.circular(25),


          onTap:
          widget.onTap,


          child:Container(

            padding:
            const EdgeInsets.all(20),


            decoration:BoxDecoration(

              borderRadius:
              BorderRadius.circular(25),


              gradient:
              const LinearGradient(

                colors:[

                  Color(0xffffd54f),

                  Color(0xffffa000),

                ],

              ),


              boxShadow:[

                BoxShadow(

                  color:
                  Colors.orangeAccent
                      .withValues(alpha:.3),

                  blurRadius:15,

                  offset:
                  const Offset(0,8),

                )

              ],

            ),



            child:Row(

              children:[


                Container(

                  width:70,

                  height:70,


                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white
                        .withValues(alpha:.25),


                    shape:
                    BoxShape.circle,

                  ),


                  child:
                  const Center(

                    child:Text(

                      "🎯",

                      style:
                      TextStyle(

                        fontSize:40,

                      ),

                    ),

                  ),

                ),



                const SizedBox(width:18),



                Expanded(

                  child:Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[


                      const Text(

                        "Har'a",

                        style:
                        TextStyle(

                          color:
                          Colors.white,

                          fontSize:16,

                        ),

                      ),



                      Text(

                        widget.title,


                        style:
                        const TextStyle(

                          color:
                          Colors.white,

                          fontSize:22,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),



                      const SizedBox(height:5),



                      Text(

                        widget.description,


                        style:
                        const TextStyle(

                          color:
                          Colors.white,

                        ),

                      ),



                      const SizedBox(height:10),



                      Row(

                        children:[


                          const Text(

                            "⭐",

                            style:
                            TextStyle(

                              fontSize:20,

                            ),

                          ),



                          const SizedBox(width:5),



                          Text(

                            "+${widget.rewardXP} XP",


                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),


                        ],

                      )


                    ],

                  ),

                )

              ],

            ),

          ),

        ),

      ),

    );

  }

}