import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/multiplication_game_data.dart';
import '../../models/multiplication_question.dart';
import '../../providers/reward_provider.dart';



class MultiplicationGameScreen extends StatefulWidget {


const MultiplicationGameScreen({

super.key,

});



@override
State<MultiplicationGameScreen> createState()

=> _MultiplicationGameScreenState();


}




class _MultiplicationGameScreenState

extends State<MultiplicationGameScreen>{



late List<MultiplicationQuestion> questions;


int current=0;


int tappedGroups=0;


bool finished=false;



@override
void initState(){


super.initState();


questions =
generateMultiplicationQuestions();


}





MultiplicationQuestion get question =>

questions[current];






void tapGroup(){



setState((){

tappedGroups++;

});




if(tappedGroups == question.groups){


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

"Baay'ee gaarii! ✖️⭐",

);





Future.delayed(

const Duration(seconds:2),

(){

next();

},

);



}







void next(){


if(current < questions.length-1){


setState((){


current++;

tappedGroups=0;


});


}

else{


finish();


}


}





void finish(){



setState((){

finished=true;

});



showDialog(

context:context,

builder:(context)=>AlertDialog(



title:

const Text(

"🏆 Herrega Xumurteetta",

),



content:

const Text(

"Baay'ee gaarii! Baay'ina lakkoofsotaa baratte.",

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






void showRaji(String message){


ScaffoldMessenger.of(context)

.showSnackBar(


SnackBar(

content:

Text(

"😊 Raji: $message",

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

"✖️ Baay'isuu Taphadhu",

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

"${question.groups} × ${question.items}",

style:

const TextStyle(

fontSize:40,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:20),





Text(

"Tuuta ${question.groups} keessa jiru",

style:

const TextStyle(

fontSize:20,

),

),




const SizedBox(height:30),




Wrap(

spacing:15,

runSpacing:15,

children:

List.generate(

question.groups,

(index){



return GestureDetector(



onTap:

tapGroup,



child:

AnimatedContainer(

duration:

const Duration(

milliseconds:300,

),



padding:

const EdgeInsets.all(15),



decoration:

BoxDecoration(

color:

index < tappedGroups

? Colors.green

: Colors.orange,



borderRadius:

BorderRadius.circular(20),


),




child:

Column(

children:[



Text(

List.generate(

question.items,

(i)=>"🍎",

).join(),

style:

const TextStyle(

fontSize:35,

),

),



Text(

"Tuuta ${index+1}",

style:

const TextStyle(

color:Colors.white,

fontWeight:

FontWeight.bold,

),

),



],


),



),



);



},

),



),





const SizedBox(height:35),




Text(

"Ida'ama: ${tappedGroups * question.items}",

style:

const TextStyle(

fontSize:28,

fontWeight:

FontWeight.bold,

),

),




],



),



),



);



}



}