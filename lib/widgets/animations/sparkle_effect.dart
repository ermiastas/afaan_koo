import 'package:flutter/material.dart';

class SparkleEffect extends StatefulWidget {

  final bool show;


  const SparkleEffect({
    super.key,
    required this.show,
  });


  @override
  State<SparkleEffect> createState()
  => _SparkleEffectState();

}



class _SparkleEffectState
extends State<SparkleEffect>
with SingleTickerProviderStateMixin{


late AnimationController controller;


@override
void initState(){

super.initState();

controller=
AnimationController(
vsync:this,
duration:
const Duration(seconds:1),
);


if(widget.show){
 controller.forward();
}

}



@override
Widget build(BuildContext context){


return AnimatedBuilder(

animation:controller,

builder:(context,child){


return Opacity(

opacity:
1-controller.value,

child:

Transform.scale(

scale:
1+
controller.value,

child:

const Icon(
Icons.auto_awesome,
color:Colors.yellow,
size:50,
),

),

);

},

);

}



@override
void dispose(){
controller.dispose();
super.dispose();
}

}