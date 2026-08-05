import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/counting_game_data.dart';
import '../../providers/reward_provider.dart';



class CountingGameScreen extends StatefulWidget {


const CountingGameScreen({
super.key,
});



@override
State<CountingGameScreen> createState()
=> _CountingGameScreenState();



}



class _CountingGameScreenState 
extends State<CountingGameScreen>{



int index = 0;

int stars = 0;



bool answered=false;




void checkAnswer(String value){


if(answered) return;


setState((){

answered=true;

});



if(value ==
countingQuestions[index].answer){


stars++;


Provider.of<RewardProvider>(

context,

listen:false,

).addStars(1);



showMessage(
"Baay'ee gaarii! ⭐",
);


}

else{


showMessage(
"Irra deebi'ii yaali 😊",
);


}



Future.delayed(

const Duration(seconds:1),

(){

if(!mounted)return;


if(index < countingQuestions.length-1){


setState((){

index++;

answered=false;


});


}


else{


showResult();


}



});


}






void showResult(){


showDialog(

context:context,

builder:(_)=>

AlertDialog(


title:

const Text(
"🎉 Xumurteetta!",
),



content:

Text(

"Urjii argatte: $stars",

),



actions:[

TextButton(

onPressed:(){

Navigator.pop(context);

setState((){

index=0;

stars=0;

answered=false;

});


},

child:

const Text(
"Deebi'i",
),

)

]


)


);


}






void showMessage(String text){

ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

content:

Text(text),

),

);

}







@override
Widget build(BuildContext context){



final question =
countingQuestions[index];



return Scaffold(



appBar:

AppBar(

title:

const Text(
"🍎 Lakkaawuu",
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

question.question,

style:

const TextStyle(

fontSize:26,

fontWeight:
FontWeight.bold,

),

),




const SizedBox(height:30),




AnimatedScale(

scale:

answered ? 1.2 : 1,

duration:

const Duration(
milliseconds:300,
),

child:

Text(

question.emoji,

style:

const TextStyle(

fontSize:60,

),

),

),





const SizedBox(height:40),




Wrap(

spacing:15,

children:

question.options.map((option){



return ElevatedButton(



onPressed:

answered

?

null

:

(){

checkAnswer(option);

},



child:

Text(

option,

style:

const TextStyle(

fontSize:25,

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