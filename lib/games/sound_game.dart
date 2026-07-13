import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/animal_data.dart';
import '../services/audio_service.dart';
import '../providers/reward_provider.dart';



class SoundGame extends StatefulWidget {


const SoundGame({super.key});



@override
State<SoundGame> createState()
=> _SoundGameState();


}





class _SoundGameState extends State<SoundGame>{


int index = 0;

int score = 0;


final AudioService audio =
AudioService();





void playSound(){


final animal =
animalData[index];


audio.playSound(
animal.sound
);


}







void checkAnswer(String answer){


final animal =
animalData[index];


if(answer == animal.nameOromo){


setState((){

score++;

});



Provider.of<RewardProvider>(

context,

listen:false,

)

.addStars(1);



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


if(index < animalData.length - 1){

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



final options =
animalData
.take(3)
.map((e)=>e.nameOromo)
.toList();



options.shuffle();





return Scaffold(



appBar:

AppBar(

title:

Text(

"Sagalee Beeki 🔊 ⭐ $score"

),

),





body:

Padding(

padding:

const EdgeInsets.all(20),


child:

Column(

children:[




const Text(

"Dhaggeeffadhu",

style:

TextStyle(

fontSize:28,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(

height:30,

),





Image.asset(

animal.image,

height:150,

),





const SizedBox(

height:20,

),





ElevatedButton.icon(

onPressed:

playSound,


icon:

const Icon(
Icons.volume_up,
),


label:

const Text(
"Sagalee Taphachiisi"
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