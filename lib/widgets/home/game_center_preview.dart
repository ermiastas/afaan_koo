import 'package:flutter/material.dart';


class GameCenterPreview extends StatelessWidget {

  final VoidCallback onTap;


  const GameCenterPreview({

    super.key,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return Padding(

      padding:
      const EdgeInsets.symmetric(

        horizontal:20,

        vertical:12,

      ),


      child: InkWell(

        borderRadius:
        BorderRadius.circular(25),


        onTap:onTap,


        child:Container(

          padding:
          const EdgeInsets.all(20),


          decoration:BoxDecoration(

            borderRadius:
            BorderRadius.circular(25),


            gradient:
            const LinearGradient(

              colors:[

                Color(0xff43A047),

                Color(0xff66BB6A),

              ],

            ),


            boxShadow:[

              BoxShadow(

                color:
                Colors.green.withValues(alpha:.25),

                blurRadius:15,

                offset:
                const Offset(0,8),

              )

            ],

          ),



          child:Row(

            children:[


              Container(

                width:75,

                height:75,


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

                    "🎮",

                    style:
                    TextStyle(

                      fontSize:42,

                    ),

                  ),

                ),

              ),



              const SizedBox(width:18),



              const Expanded(

                child:Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children:[


                    Text(

                      "Game Center",

                      style:
                      TextStyle(

                        color:
                        Colors.white,

                        fontSize:22,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                    SizedBox(height:6),



                    Text(

                      "Baradhu, taphadhu fi badhaafadhu!",

                      style:
                      TextStyle(

                        color:
                        Colors.white,

                        fontSize:15,

                      ),

                    ),



                    SizedBox(height:10),



                    Text(

                      "🎯 Games 4+",

                      style:
                      TextStyle(

                        color:
                        Colors.white70,

                      ),

                    ),

                  ],

                ),

              ),



              const Icon(

                Icons.arrow_forward_ios,

                color:Colors.white,

              )

            ],

          ),

        ),

      ),

    );

  }

}