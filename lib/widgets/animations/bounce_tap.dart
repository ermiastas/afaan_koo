import 'package:flutter/material.dart';


class BounceTap extends StatefulWidget {

final Widget child;
final VoidCallback onTap;


const BounceTap({
super.key,
required this.child,
required this.onTap,
});


@override
State<BounceTap> createState()
=>_BounceTapState();

}



class _BounceTapState
extends State<BounceTap>
with SingleTickerProviderStateMixin{


late AnimationController controller;


@override
void initState(){

super.initState();

controller=
AnimationController(
vsync:this,
duration:
const Duration(milliseconds:150),
lowerBound:.9,
upperBound:1,
value:1,
);

}



void tap(){

controller.reverse()
.then((_){

controller.forward();

});

widget.onTap();

}



@override
Widget build(BuildContext context){

return ScaleTransition(

scale:controller,

child:

GestureDetector(

onTap:tap,

child:widget.child,

),

);

}



@override
void dispose(){

controller.dispose();

super.dispose();

}

}