import 'package:flutter/material.dart';

import '../games/letter_game.dart';
import '../games/matching_game.dart';
import '../games/memory_game.dart';
import '../games/sound_game.dart';



class GameCenterScreen extends StatelessWidget {


const GameCenterScreen({super.key});



@override
Widget build(BuildContext context){


return Scaffold(


appBar:

AppBar(

title:

const Text(

"Taphoota Koo 🎮"

),

),




body:

GridView.count(


padding:

const EdgeInsets.all(15),



crossAxisCount:

2,



crossAxisSpacing:

12,


mainAxisSpacing:

12,



children:[



// Letter Game

gameCard(

context,

title:

"Qubee\nWalitti Qabi",

icon:

Icons.abc,

color:

Colors.orange,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const LetterGame(),

),

);


},

),






// Matching Game

gameCard(

context,

title:

"Fakkii\nWalitti Qabi",

icon:

Icons.image,

color:

Colors.blue,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const MatchingGame(),

),

);


},

),







// Memory Game

gameCard(

context,

title:

"Yaadannoo\n🧠",

icon:

Icons.memory,

color:

Colors.purple,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const MemoryGame(),

),

);


},

),







// Sound Game

gameCard(

context,

title:

"Sagalee\nBeeki",

icon:

Icons.volume_up,

color:

Colors.green,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const SoundGame(),

),

);


},

),





],


),


);


}







Widget gameCard(

BuildContext context,{

required String title,

required IconData icon,

required Color color,

required VoidCallback onTap,

}){


return InkWell(


onTap:

onTap,



borderRadius:

BorderRadius.circular(25),





child:

Container(


decoration:

BoxDecoration(


color:

color,


borderRadius:

BorderRadius.circular(25),


boxShadow:[


BoxShadow(

blurRadius:5,

offset:

const Offset(0,3),

color:

Colors.black26,

),


],


),




child:

Column(


mainAxisAlignment:

MainAxisAlignment.center,



children:[



Icon(

icon,

size:

60,

color:

Colors.white,

),




const SizedBox(

height:15,

),





Text(


title,


textAlign:

TextAlign.center,



style:

const TextStyle(


fontSize:

20,


fontWeight:

FontWeight.bold,


color:

Colors.white,


),



),





],


),



),



);



}



}