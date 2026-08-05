import 'package:flutter/material.dart';

import '../../models/raji_message.dart';



class RajiWidget extends StatelessWidget {


final RajiMessage message;


const RajiWidget({

super.key,

required this.message,

});



@override
Widget build(BuildContext context){


return Container(


padding:
const EdgeInsets.all(12),


decoration:

BoxDecoration(

color:
Colors.white,

borderRadius:
BorderRadius.circular(25),


boxShadow:[

BoxShadow(

blurRadius:12,

color:
Colors.black.withValues(alpha: 0.15),

)

],

),



child:

Row(

children:[



CircleAvatar(

radius:32,


backgroundColor:
Colors.blue.shade50,


child:

Text(

_moodEmoji(),

style:

const TextStyle(

fontSize:40,

),

),

),



const SizedBox(width:12),



Expanded(

child:

Text(

message.text,


style:

const TextStyle(

fontSize:16,

fontWeight:
FontWeight.w600,

),

),

),


],

),


);


}



String _moodEmoji(){


switch(message.mood){


case RajiMood.celebrating:
return "🎉";


case RajiMood.excited:
return "🤩";


case RajiMood.thinking:
return "🤔";


case RajiMood.encouraging:
return "💪";


default:
return "😊";


}


}


}