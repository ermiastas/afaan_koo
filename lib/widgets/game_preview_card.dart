import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reward_provider.dart';
import '../screens/game_center_screen.dart';


class GamePreviewCard extends StatelessWidget {

  const GamePreviewCard({
    super.key,
  });


  @override
  Widget build(BuildContext context) {


    return Consumer<RewardProvider>(

      builder:(context, reward, child){


        return GestureDetector(


          onTap:(){


            Navigator.push(

              context,

              MaterialPageRoute(

                builder:(_)=>
                const GameCenterScreen(),

              ),

            );


          },


          child: Container(


            width:

            double.infinity,


            padding:

            const EdgeInsets.all(20),



            decoration:

            BoxDecoration(


              gradient:

              const LinearGradient(

                colors:[

                  Color(0xffFF9966),

                  Color(0xffFF5E62),

                ],

              ),


              borderRadius:

              BorderRadius.circular(30),



              boxShadow:[


                BoxShadow(

                  color:

                  Colors.red.withValues(alpha:0.25),

                  blurRadius:15,

                  offset:

                  const Offset(0,8),

                ),


              ],


            ),



            child:

            Column(


              crossAxisAlignment:

              CrossAxisAlignment.start,


              children:[



                Row(


                  children:[


                    const Icon(

                      Icons.sports_esports,

                      size:45,

                      color:Colors.white,

                    ),



                    const SizedBox(width:15),



                    const Expanded(

                      child:

                      Text(

                        "Taphoota Koo 🎮",

                        style:

                        TextStyle(

                          fontSize:24,

                          fontWeight:

                          FontWeight.bold,

                          color:

                          Colors.white,

                        ),

                      ),

                    ),


                    const Icon(

                      Icons.arrow_forward_ios,

                      color:

                      Colors.white,

                    ),


                  ],


                ),




                const SizedBox(height:20),




                Row(

                  mainAxisAlignment:

                  MainAxisAlignment.spaceAround,


                  children:[


                    rewardItem(

                      "⭐",

                      "${reward.stars}",

                    ),



                    rewardItem(

                      "⚡",

                      "${reward.xp}",

                    ),



                    rewardItem(

                      "🪙",

                      "${reward.coins}",

                    ),



                  ],


                ),




                const SizedBox(height:15),




                const Text(

                  "Baradhu • Taphadhu • Badhaasa argadhu 🚀",

                  style:

                  TextStyle(

                    color:

                    Colors.white,

                    fontSize:15,

                  ),

                ),



              ],


            ),


          ),


        );


      },

    );


  }





  Widget rewardItem(

      String icon,

      String value,

      ){


    return Column(


      children:[


        Text(

          icon,

          style:

          const TextStyle(

            fontSize:24,

          ),

        ),



        const SizedBox(height:5),



        Text(

          value,

          style:

          const TextStyle(

            fontSize:18,

            fontWeight:

            FontWeight.bold,

            color:

            Colors.white,

          ),

        ),



      ],


    );


  }


}