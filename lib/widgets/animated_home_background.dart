import 'dart:math';

import 'package:flutter/material.dart';



class AnimatedHomeBackground extends StatefulWidget {


  final Widget child;


  const AnimatedHomeBackground({
    super.key,
    required this.child,
  });



  @override
  State<AnimatedHomeBackground> createState()
      => _AnimatedHomeBackgroundState();

}




class _AnimatedHomeBackgroundState
    extends State<AnimatedHomeBackground>
    with SingleTickerProviderStateMixin {



late AnimationController controller;



final Random random = Random();



final List<_Bubble> bubbles = [];



@override
void initState(){

super.initState();


controller = AnimationController(

vsync:this,

duration:
const Duration(seconds:20),

)..repeat();



for(int i=0;i<25;i++){

bubbles.add(

_Bubble(

x:random.nextDouble(),

y:random.nextDouble(),

size:
20+random.nextDouble()*50,

speed:
0.2+random.nextDouble(),

),

);

}


}




@override
void dispose(){

controller.dispose();

super.dispose();

}




@override
Widget build(BuildContext context){


return AnimatedBuilder(

animation:controller,


builder:(context,child){


return Stack(

children:[



Container(

decoration:

BoxDecoration(

gradient:

LinearGradient(

begin:
Alignment.topCenter,

end:
Alignment.bottomCenter,


colors:[

Colors.lightBlue.shade50,

Colors.white,

Colors.green.shade50,

],


),


),

),




...bubbles.map((bubble){


final move =

(controller.value*bubble.speed);



return Positioned(

left:

bubble.x *
MediaQuery.of(context).size.width,


top:

((bubble.y+move)%1.2) *
MediaQuery.of(context).size.height,


child:

Container(

width:bubble.size,

height:bubble.size,


decoration:

BoxDecoration(

shape:
BoxShape.circle,


color:

Colors.white.withValues(alpha:.35),


),

),


);


}),




widget.child,



],


);


},


);


}


}



class _Bubble{


final double x;

final double y;

final double size;

final double speed;


_Bubble({

required this.x,

required this.y,

required this.size,

required this.speed,

});


}