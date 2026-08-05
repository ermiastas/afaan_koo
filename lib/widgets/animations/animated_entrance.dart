import 'package:flutter/material.dart';



class AnimatedEntrance extends StatefulWidget {


  final Widget child;


  final int delay;


  const AnimatedEntrance({

    super.key,

    required this.child,

    this.delay = 0,

  });



  @override
  State<AnimatedEntrance> createState()
      => _AnimatedEntranceState();

}





class _AnimatedEntranceState
    extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {



  late AnimationController controller;


  late Animation<double> fade;


  late Animation<Offset> slide;




  @override
  void initState(){

    super.initState();



    controller = AnimationController(

      vsync:this,

      duration:

      const Duration(milliseconds:600),

    );




    fade = Tween<double>(

      begin:0,

      end:1,

    ).animate(

      CurvedAnimation(

        parent:controller,

        curve:
        Curves.easeOut,

      ),

    );





    slide = Tween<Offset>(

      begin:

      const Offset(0,0.25),

      end:

      Offset.zero,


    ).animate(

      CurvedAnimation(

        parent:controller,

        curve:
        Curves.easeOutBack,

      ),

    );




    Future.delayed(

      Duration(

        milliseconds:

        widget.delay,

      ),

          (){


        if(mounted){

          controller.forward();

        }


      },


    );



  }





  @override
  Widget build(BuildContext context){


    return FadeTransition(

      opacity:fade,


      child:

      SlideTransition(

        position:slide,


        child:

        widget.child,


      ),


    );


  }







  @override
  void dispose(){

    controller.dispose();

    super.dispose();

  }


}