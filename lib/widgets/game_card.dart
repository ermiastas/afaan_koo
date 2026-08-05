import 'package:flutter/material.dart';

import '../models/game_item.dart';



class GameCard extends StatelessWidget {


final GameItem game;

final VoidCallback onTap;


const GameCard({

super.key,

required this.game,

required this.onTap,

});



@override
Widget build(BuildContext context){


return GestureDetector(

onTap:
game.unlocked ? onTap : null,


child:

Container(

margin:
const EdgeInsets.all(10),


padding:
const EdgeInsets.all(18),


decoration:

BoxDecoration(

borderRadius:
BorderRadius.circular(25),


gradient:

const LinearGradient(

colors:[

Color(0xff667eea),

Color(0xff764ba2),

],

),


),



child:

Column(

children:[


Text(

game.icon,

style:

const TextStyle(

fontSize:50,

),

),



const SizedBox(height:10),



Text(

game.title,

style:

const TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

color:
Colors.white,

),

),



Text(

"+${game.rewardXP} XP",

style:

const TextStyle(

color:
Colors.yellow,

fontWeight:
FontWeight.bold,

),

),


],

),

),

);

}

}