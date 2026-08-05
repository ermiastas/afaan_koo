import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/addition_game_data.dart';
import '../../models/addition_question.dart';
import '../../providers/reward_provider.dart';



class AdditionGameScreen extends StatefulWidget {


const AdditionGameScreen({

super.key,

});



@override
State<AdditionGameScreen> createState()

=> _AdditionGameScreenState();


}




class _AdditionGameScreenState

extends State<AdditionGameScreen>{



late List<AdditionQuestion> questions;


int current = 0;


int collected = 0;


bool completed=false;



@override
void initState(){

super.initState();

questions =
generateAdditionQuestions();

}




AdditionQuestion get question =>
questions[current];





void appleDropped(){



setState((){

collected++;

});



if(collected == question.secondNumber){


checkAnswer();


}


}




void checkAnswer(){



final reward =
Provider.of<RewardProvider>(

context,

listen:false,

);



reward.addStars(2);

reward.addCoins(1);



showRaji(

"Baay'ee gaarii! ⭐🍎",

);



Future.delayed(

const Duration(seconds:2),

(){



if(!mounted)return;



nextQuestion();


});


}





void nextQuestion(){


if(current < questions.length-1){


setState((){


current++;

collected=0;


});


}


else{


finish();


}


}






void finish(){



setState((){

completed=true;

});



showDialog(

context:context,

builder:(context)=>AlertDialog(


title:

const Text(

"🎉 Herrega Xumurteetta!",

),



content:

const Text(

"Ati dabaluu baay'ee gaarii baratte!",

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

]


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

"🍎 Dabaluu Taphadhu",

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

"${question.firstNumber} + ${question.secondNumber} = ?",

style:

const TextStyle(

fontSize:35,

fontWeight:

FontWeight.bold,

),

),




const SizedBox(height:20),





Row(

mainAxisAlignment:

MainAxisAlignment.center,


children:

List.generate(

question.firstNumber,


(index)=>

const Text(

"🍎",

style:

TextStyle(

fontSize:45,

),

),

),



),





const SizedBox(height:20),




const Text(

"🍎 Apple walitti fidi",

style:

TextStyle(

fontSize:22,

),

),






DragTarget<String>(



onAcceptWithDetails:(details){


appleDropped();


},




builder:(context,accepted,rejected){



return Container(



width:220,

height:150,



decoration:

BoxDecoration(


color:

Colors.green.shade100,


borderRadius:

BorderRadius.circular(30),

),





child:

Column(

mainAxisAlignment:

MainAxisAlignment.center,


children:[


const Text(

"🧺",

style:

TextStyle(

fontSize:70,

),

),



Text(

"$collected / ${question.secondNumber}",

style:

const TextStyle(

fontSize:20,

fontWeight:

FontWeight.bold,

),

),


],


),



);



},



),





const SizedBox(height:30),





Wrap(

spacing:10,


children:

List.generate(

question.secondNumber,


(index)=>Draggable<String>(


data:"apple",



feedback:

const Text(

"🍎",

style:

TextStyle(

fontSize:60,

),

),




childWhenDragging:

const SizedBox(

width:50,

),




child:

const Text(

"🍎",

style:

TextStyle(

fontSize:55,

),

),



),



),



),




],



),



),



);



}



}