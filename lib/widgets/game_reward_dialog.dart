import 'package:flutter/material.dart';

import '../models/raji_message.dart';
import 'raji/raji_widget.dart';



class GameRewardDialog extends StatelessWidget {


final int xp;

final int coins;



const GameRewardDialog({

super.key,

required this.xp,

required this.coins,

});



@override
Widget build(BuildContext context){


return AlertDialog(


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(25),

),



content:

Column(

mainAxisSize:
MainAxisSize.min,

children:[


RajiWidget(

message:

RajiMessage(

text:

"Baay'ee gaarii! Taphi kee xumurame 🎉",

mood:

RajiMood.celebrating,

),

),


const SizedBox(height:20),


Text(

"+$xp XP ⭐",

style:

const TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),


Text(

"+$coins 🪙",

style:

const TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),



],

),


);


}

}