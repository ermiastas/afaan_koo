import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';


class ConfettiReward extends StatefulWidget {


const ConfettiReward({

super.key,

});


@override
State<ConfettiReward> createState()

=> _ConfettiRewardState();


}



class _ConfettiRewardState

extends State<ConfettiReward>{


late ConfettiController controller;



@override
void initState(){

super.initState();


controller = ConfettiController(

duration:

const Duration(seconds:3),

);


controller.play();


}



@override
void dispose(){

controller.dispose();

super.dispose();

}



@override
Widget build(BuildContext context){


return Align(

alignment:

Alignment.topCenter,


child:

ConfettiWidget(

confettiController:

controller,


blastDirectionality:

BlastDirectionality.explosive,


numberOfParticles:

30,


),


);


}


}