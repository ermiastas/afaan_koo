import 'package:flutter/material.dart';


class AnimatedTouch extends StatefulWidget {

  final Widget child;
  final VoidCallback? onTap;


  const AnimatedTouch({
    super.key,
    required this.child,
    this.onTap,
  });


  @override
  State<AnimatedTouch> createState()
      => _AnimatedTouchState();

}




class _AnimatedTouchState
    extends State<AnimatedTouch>
    with SingleTickerProviderStateMixin {


  double scale = 1;


  void _press(bool value){

    setState(() {

      scale = value ? 0.92 : 1;

    });

  }




  @override
  Widget build(BuildContext context){


    return GestureDetector(


      onTapDown:(_){

        _press(true);

      },


      onTapUp:(_){

        _press(false);

        widget.onTap?.call();

      },


      onTapCancel:(){

        _press(false);

      },



      child:

      AnimatedScale(


        scale:scale,


        duration:

        const Duration(
          milliseconds:120,
        ),


        curve:

        Curves.easeOut,


        child:

        widget.child,


      ),


    );


  }


}