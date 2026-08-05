import 'package:flutter/material.dart';

import 'moving_clouds.dart';
//import 'floating_bubbles.dart';


class AppBackground extends StatelessWidget {

  final Widget child;


  const AppBackground({
    super.key,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: const BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topCenter,

          end: Alignment.bottomCenter,

          colors:[

            Color(0xff64B5F6),

            Color(0xffBBDEFB),

            Color(0xffEAF7FF),

          ],

        ),

      ),


      child: Stack(

        children:[


          // Moving clouds
          const MovingClouds(),


          // Floating bubbles
          //const FloatingBubbles(),



          // Screen content
          child,


        ],

      ),

    );

  }

}