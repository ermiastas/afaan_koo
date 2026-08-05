import 'package:flutter/material.dart';

import '../models/badge_item.dart';



class BadgeCard extends StatelessWidget {


  final BadgeItem badge;

  final bool unlocked;



  const BadgeCard({

    super.key,

    required this.badge,

    required this.unlocked,

  });





  @override
  Widget build(BuildContext context) {


    return Container(


      padding:
      const EdgeInsets.all(12),



      decoration:
      BoxDecoration(


        color:
        unlocked

            ? Colors.white

            : Colors.grey.shade200,



        borderRadius:
        BorderRadius.circular(20),



        boxShadow:[


          BoxShadow(

            color:
            Colors.black.withValues(alpha:.08),

            blurRadius:8,

          )


        ],


      ),





      child:

      Column(


        mainAxisAlignment:
        MainAxisAlignment.center,



        children:[





          Opacity(


            opacity:
            unlocked ? 1 : .35,



            child:

            Image.asset(

              badge.image,

              height:70,

              width:70,

            ),

          ),





          const SizedBox(height:10),






          Text(

            badge.nameOromo,


            textAlign:
            TextAlign.center,



            maxLines:2,


            overflow:
            TextOverflow.ellipsis,



            style:
            TextStyle(


              fontWeight:
              FontWeight.bold,


              color:
              unlocked

                  ? Colors.black

                  : Colors.grey,

            ),

          ),





          const SizedBox(height:5),





          if(!unlocked)

            const Icon(

              Icons.lock,

              size:18,

              color:Colors.grey,

            ),





        ],


      ),


    );

  }


}