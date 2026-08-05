import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/fraction_game_data.dart';
import '../../models/fraction_question.dart';
import '../../providers/reward_provider.dart';



class FractionGameScreen extends StatefulWidget {


const FractionGameScreen({

super.key,

});



@override
State<FractionGameScreen> createState()

=> _FractionGameScreenState();


}





class _FractionGameScreenState

extends State<FractionGameScreen>{



late List<FractionQuestion> questions;


int current=0;


int selected=0;



@override
void initState(){


super.initState();


questions =
generateFractionQuestions();


}





FractionQuestion get question =>

questions[current];







void selectPiece(){


setState((){

selected++;

});



if(selected == question.parts){


correct();


}


}





void correct(){



final reward =

Provider.of<RewardProvider>(

context,

listen:false,

);



reward.addStars(3);

reward.addCoins(2);



showRaji(

"Gaarii dha! Kutaa lakkoofsaa hubatte ⭐",

);





Future.delayed(

const Duration(seconds:2),

next,

);


}





void next(){



if(current < questions.length-1){


setState((){


current++;

selected=0;


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

"Fraction sirriitti baratte!",

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

"🍕 Kutaa Lakkoofsaa",

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

question.title,

style:

const TextStyle(

fontSize:25,

fontWeight:

FontWeight.bold,

),

),




const SizedBox(height:30),




Wrap(

children:

List.generate(

question.parts,


(index){



return GestureDetector(



onTap:

selectPiece,



child:

AnimatedContainer(

duration:

const Duration(

milliseconds:400,

),



margin:

const EdgeInsets.all(5),



width:70,

height:70,



decoration:

BoxDecoration(



color:

index < selected

?

Colors.green

:

Colors.orange,



borderRadius:

BorderRadius.circular(20),



),



child:

Center(

child:

Text(

question.emoji,

style:

const TextStyle(

fontSize:40,

),

),

),



),



);



},


),



),






const SizedBox(height:30),




Text(

"Kutaa filatame: $selected/${question.parts}",

style:

const TextStyle(

fontSize:22,

),

),






const SizedBox(height:20),





Container(

padding:

const EdgeInsets.all(15),


decoration:

BoxDecoration(

color:

Colors.blue.shade100,

borderRadius:

BorderRadius.circular(20),

),


child:

Text(

"Kutaan tokko: ${question.answer}",

style:

const TextStyle(

fontSize:24,

fontWeight:

FontWeight.bold,

),

),



),



],



),



),



);



}



}