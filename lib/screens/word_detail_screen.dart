import 'package:flutter/material.dart';

import '../models/word_item.dart';
import '../services/audio_service.dart';



class WordDetailScreen extends StatelessWidget {


final WordItem word;


WordDetailScreen({

super.key,

required this.word,

});



final AudioService audio =
AudioService();




@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
Text(word.wordOromo),

),



body:

Center(

child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[



Image.asset(

word.image,

height:200,

),




Text(

word.wordOromo,

style:

const TextStyle(

fontSize:40,

fontWeight:
FontWeight.bold,

),

),




Text(

word.wordEnglish,

style:

const TextStyle(

fontSize:25,

),

),





ElevatedButton.icon(

onPressed:(){


audio.playSound(
word.sound
);


},


icon:

const Icon(
Icons.volume_up,
),


label:

const Text(
"Dhaggeeffadhu"
),


),



],


),

),


);


}


}