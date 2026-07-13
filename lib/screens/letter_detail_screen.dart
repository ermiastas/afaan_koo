import 'package:flutter/material.dart';
import '../models/letter.dart';


class LetterDetailScreen extends StatelessWidget{


final Letter letter;


const LetterDetailScreen({

super.key,

required this.letter,

});



@override

Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
Text(letter.letter),

),



body:

Center(

child:

Column(

children:[


Text(

letter.letter,

style:

const TextStyle(

fontSize:100,

fontWeight:
FontWeight.bold,

),

),



Image.asset(

letter.image,

height:200,

),



Text(

letter.wordOromo,

style:

const TextStyle(

fontSize:35,

),

),



Text(

letter.wordEnglish,

style:

const TextStyle(

fontSize:22,

),

),



ElevatedButton.icon(

onPressed:(){


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
