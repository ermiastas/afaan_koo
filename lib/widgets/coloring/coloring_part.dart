import 'package:flutter/material.dart';


class ColoringPart extends StatelessWidget {


  final String id;

  final Color color;

  final VoidCallback onTap;



  const ColoringPart({

    super.key,

    required this.id,

    required this.color,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:onTap,


      child: AnimatedContainer(

        duration:

        const Duration(

          milliseconds:300,

        ),


        decoration:

        BoxDecoration(

          color:color,

        ),


      ),

    );


  }


}