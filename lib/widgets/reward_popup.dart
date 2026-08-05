import 'package:flutter/material.dart';



class RewardPopup extends StatefulWidget {


final int xp;

final int coins;

final int stars;



const RewardPopup({

super.key,

required this.xp,

required this.coins,

required this.stars,

});




@override
State<RewardPopup> createState()

=> _RewardPopupState();


}




class _RewardPopupState

extends State<RewardPopup>

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

)

..forward();


}




@override
Widget build(BuildContext context){



return ScaleTransition(


scale:

CurvedAnimation(

parent:controller,

curve:

Curves.elasticOut,

),


child:

Dialog(


shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(30),

),



child:

Padding(

padding:

const EdgeInsets.all(30),


child:

Column(

mainAxisSize:

MainAxisSize.min,


children:[



const Text(

"🎉",

style:

TextStyle(

fontSize:70,

),

),



const Text(

"Raji",

style:

TextStyle(

fontSize:28,

fontWeight:

FontWeight.bold,

),

),



Text(

"+${widget.xp} XP",

style:

const TextStyle(

fontSize:22,

),

),



Text(

"🪙 ${widget.coins} Coins",

style:

const TextStyle(

fontSize:20,

),

),



Text(

"⭐ ${widget.stars} Stars",

style:

const TextStyle(

fontSize:20,

),

),


],


),

),



),


);



}




@override

void dispose(){

controller.dispose();

super.dispose();

}



}