import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import '../../data/time_game_data.dart';

import '../../models/time_question.dart';

import '../../providers/reward_provider.dart';

import '../../widgets/animated_clock.dart';





class TimeMathGameScreen extends StatefulWidget {



const TimeMathGameScreen({

super.key,

});





@override

State<TimeMathGameScreen> createState()

=> _TimeMathGameScreenState();



}






class _TimeMathGameScreenState

extends State<TimeMathGameScreen>{



late List<TimeQuestion> questions;


int current=0;


String? selected;





@override

void initState(){


super.initState();


questions=

generateTimeQuestions();


}




TimeQuestion get question =>

questions[current];







void check(String value){



setState((){

selected=value;

});




if(value==question.answer){



final reward=

Provider.of<RewardProvider>(

context,

listen:false,

);



reward.addStars(3);

reward.addCoins(2);



showRaji(

"Sirrii dha! Yeroo sirriitti baratte ⭐",

);



Future.delayed(

const Duration(seconds:2),

next,

);



}

else{


showRaji(

"Irra deebi'ii ilaali 🕒",

);


}


}







void next(){



if(current < questions.length-1){



setState((){


current++;

selected=null;


});



}

else{


finish();


}



}






void finish(){



showDialog(

context:context,

builder:(context)=>AlertDialog(


title:

const Text(

"🎉 Xumurteetta!",

),


content:

const Text(

"Yeroo dubbisuu baratte!",

),


actions:[

TextButton(

onPressed:(){

Navigator.pop(context);

},

child:

const Text(

"Tole",

),

)

],


)


);


}






void showRaji(String text){


ScaffoldMessenger.of(context)

.showSnackBar(

SnackBar(

content:

Text(

"😊 Raji: $text",

),

),

);


}








@override

Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

const Text(

"🕒 Herrega Yeroo",

),

),





body:

Center(



child:

Column(

mainAxisAlignment:

MainAxisAlignment.center,

children:[





Text(

question.activity,

style:

const TextStyle(

fontSize:25,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:25),





AnimatedClock(

hour:

question.hour,

minute:

question.minute,

),





const SizedBox(height:30),





const Text(

"Yeroon meeqa?",

style:

TextStyle(

fontSize:22,

),

),




Wrap(

spacing:10,


children:

[

question.answer,

"2:00",

"5:30",

"8:00",

].map((e){


return ElevatedButton(

onPressed:

()=>check(e),

child:

Text(

e,

style:

const TextStyle(

fontSize:20,

),

),

);


}).toList(),


),



],

),



),



);



}



}