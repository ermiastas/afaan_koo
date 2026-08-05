import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/subtraction_game_data.dart';
import '../../models/subtraction_question.dart';
import '../../providers/reward_provider.dart';



class SubtractionGameScreen extends StatefulWidget {


const SubtractionGameScreen({

super.key,

});



@override
State<SubtractionGameScreen> createState()

=> _SubtractionGameScreenState();


}





class _SubtractionGameScreenState

extends State<SubtractionGameScreen>{



late List<SubtractionQuestion> questions;



int current=0;


int removed=0;


List<bool> visible=[];



@override
void initState(){


super.initState();


questions =
generateSubtractionQuestions();


resetObjects();


}




SubtractionQuestion get question =>

questions[current];





void resetObjects(){


visible = List.generate(

question.total,

(index)=>true,

);


removed=0;


}




void removeBird(int index){



if(!visible[index]) return;



setState((){


visible[index]=false;


removed++;


});




if(removed == question.remove){


success();


}


}






void success(){


final reward =

Provider.of<RewardProvider>(

context,

listen:false,

);



reward.addStars(2);

reward.addCoins(1);



showRaji(

"Sirrii dha! Baay'ee gaarii hojjetta ⭐",

);




Future.delayed(

const Duration(seconds:2),

(){


nextQuestion();


},

);


}







void nextQuestion(){



if(current < questions.length-1){



setState((){


current++;


resetObjects();



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

"Hir'isuu sirriitti baratte!",

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

"➖ Hir'isuu Taphadhu",

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

"${question.total} - ${question.remove} = ?",

style:

const TextStyle(

fontSize:35,

fontWeight:

FontWeight.bold,

),

),




const SizedBox(height:30),





Wrap(



spacing:8,


children:

List.generate(

question.total,


(index){



return AnimatedOpacity(



duration:

const Duration(

milliseconds:400,

),



opacity:

visible[index]

?1

:0,



child:

GestureDetector(



onTap:(){

removeBird(index);

},



child:

const Text(

"🐥",

style:

TextStyle(

fontSize:55,

),

),



),



);



},


),



),






const SizedBox(height:40),






Container(



padding:

const EdgeInsets.all(20),



decoration:

BoxDecoration(



color:

Colors.orange.shade100,

borderRadius:

BorderRadius.circular(25),



),



child:

Text(

"🐥 Tuuta keessaa ${question.remove} balleessi",

style:

const TextStyle(

fontSize:20,

),

),



),




const SizedBox(height:25),




Text(

"Kan hafee: ${question.total - removed}",

style:

const TextStyle(

fontSize:25,

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