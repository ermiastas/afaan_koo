import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/animal_data.dart';
import '../providers/reward_provider.dart';



class MatchingGame extends StatefulWidget {


const MatchingGame({super.key});


@override
State<MatchingGame> createState()
=> _MatchingGameState();


}





class _MatchingGameState extends State<MatchingGame>{


int index = 0;

int score = 0;



void checkAnswer(
String answer
){


final animal =
animalData[index];



final reward =
Provider.of<RewardProvider>(

context,

listen:false,

);



if(answer == animal.nameOromo){


setState((){

score++;

});



reward.addStars(1);



_showMessage(
"Sirrii dha! ⭐"
);



}

else{


_showMessage(
"Dogoggora. Irra deebi'i"
);


}




setState((){


if(index < animalData.length-1){

index++;

}

else{

index = 0;

}



});


}







void _showMessage(String message){


ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

content:

Text(message),

),

);


}






@override
Widget build(BuildContext context){



final animal =
animalData[index];



final options = [

animal.nameOromo,



if(animalData.length > index+1)

animalData[index+1].nameOromo,



if(animalData.length > index+2)

animalData[index+2].nameOromo,



];



options.shuffle();



return Scaffold(


appBar:

AppBar(

title:

Text(
"Fakkii Walitti Qabi ⭐ $score"
),

),




body:

Padding(

padding:

const EdgeInsets.all(20),



child:

Column(

children:[




Image.asset(

animal.image,

height:200,

),





const SizedBox(

height:20,

),





const Text(

"Fakkii kana maqaan isaa maal?"

,

style:

TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(

height:20,

),





...options.map(

(option)=>


Padding(

padding:

const EdgeInsets.all(8),



child:

SizedBox(

width:

double.infinity,



child:

ElevatedButton(



onPressed:(){


checkAnswer(option);


},



child:

Text(

option,

style:

const TextStyle(

fontSize:20,

),

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