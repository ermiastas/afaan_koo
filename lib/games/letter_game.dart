import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/alphabet_data.dart';
import '../providers/reward_provider.dart';



class LetterGame extends StatefulWidget {


const LetterGame({super.key});


@override
State<LetterGame> createState()
=> _LetterGameState();


}




class _LetterGameState extends State<LetterGame>{


int index = 0;

int score = 0;



void checkAnswer(String answer){


final current =
letters[index];



final reward =
Provider.of<RewardProvider>(

context,

listen:false,

);



if(answer == current.wordOromo){


score++;

reward.addStars(1);



showMessage(
"Sirrii dha! ⭐"
);



}

else{


showMessage(
"Irra deebi'ii yaali"
);



}



setState((){


if(index < letters.length-1){

index++;

}

else{

index = 0;

}


});


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


final current =
letters[index];



final options =
letters
.take(3)
.map((e)=>e.wordOromo)
.toList();



return Scaffold(


appBar:

AppBar(

title:

Text(
"Qubee Walitti Qabi ⭐ $score"
),

),



body:

Padding(

padding:

const EdgeInsets.all(20),


child:

Column(

children:[



Text(

current.letter,

style:

const TextStyle(

fontSize:100,

fontWeight:
FontWeight.bold,

),

),




Image.asset(

current.image,

height:150,

),





const SizedBox(
height:20,
),




...options.map(

(word)=>

Padding(

padding:

const EdgeInsets.all(8),


child:

ElevatedButton(

style:

ElevatedButton.styleFrom(

minimumSize:

const Size(
double.infinity,
50
),

),


onPressed:(){

checkAnswer(word);

},


child:

Text(

word,

style:

const TextStyle(

fontSize:20,

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