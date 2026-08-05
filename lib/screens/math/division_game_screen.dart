import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/division_game_data.dart';
import '../../models/division_question.dart';
import '../../providers/reward_provider.dart';



class DivisionGameScreen extends StatefulWidget {


const DivisionGameScreen({

super.key,

});



@override
State<DivisionGameScreen> createState()

=> _DivisionGameScreenState();


}





class _DivisionGameScreenState

extends State<DivisionGameScreen>{



late List<DivisionQuestion> questions;


int current = 0;


int distributed = 0;



List<int> childBoxes=[];




@override
void initState(){


super.initState();


questions =
generateDivisionQuestions();


createBoxes();


}




DivisionQuestion get question =>

questions[current];





void createBoxes(){


childBoxes = List.filled(

question.groups,

0,

);


distributed=0;


}





void giveApple(int child){



if(distributed >= question.total){

return;

}



setState((){


childBoxes[child]++;

distributed++;


});





if(distributed == question.total){


checkResult();


}



}






void checkResult(){



bool correct=true;



for(final value in childBoxes){


if(value != question.answer){

correct=false;

}

}





if(correct){


final reward =

Provider.of<RewardProvider>(

context,

listen:false,

);



reward.addStars(3);

reward.addCoins(2);



showRaji(

"Sirrii dha! hiruu bareedaadha! ⭐",

);



Future.delayed(

const Duration(seconds:2),

nextQuestion,

);


}

else{


showRaji(

"Irra deebi'ii hiri 😊",

);



}


}






void nextQuestion(){


if(current < questions.length-1){


setState((){


current++;

createBoxes();


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

"Qooduu sirriitti baratte!",

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

"➗ Qooduu Taphadhu",

),

),





body:

SingleChildScrollView(



padding:

const EdgeInsets.all(20),



child:

Column(



children:[





Text(

"${question.total} ÷ ${question.groups}",

style:

const TextStyle(

fontSize:40,

fontWeight:

FontWeight.bold,

),

),




const SizedBox(height:20),





const Text(

"🍎 Hirmaattotaaf walqoodi",

style:

TextStyle(

fontSize:22,

),

),





const SizedBox(height:25),





Wrap(



spacing:8,



children:

List.generate(

question.total,


(index)=>

const Text(

"🍎",

style:

TextStyle(

fontSize:40,

),

),

),



),





const SizedBox(height:35),






Wrap(



spacing:15,


children:

List.generate(

question.groups,


(index){



return DragTarget<String>(



onAcceptWithDetails:(details){


giveApple(index);


},




builder:

(context,accepted,rejected){



return Container(



width:100,

height:130,



decoration:

BoxDecoration(


color:

Colors.blue.shade100,


borderRadius:

BorderRadius.circular(20),


),



child:

Column(

mainAxisAlignment:

MainAxisAlignment.center,

children:[



Text(

index==0

?"👧"

:"👦",

style:

const TextStyle(

fontSize:40,

),

),



Text(

"🍎"*childBoxes[index],

style:

const TextStyle(

fontSize:22,

),

),



],

),



);



},



);



},


),



),






const SizedBox(height:35),




Wrap(

spacing:10,


children:

List.generate(

question.total,


(index)=>

Draggable<String>(


data:"apple",



feedback:

const Text(

"🍎",

style:

TextStyle(

fontSize:55,

),

),



child:

const Text(

"🍎",

style:

TextStyle(

fontSize:45,

),

),



),



),



),





const SizedBox(height:20),





Text(

"Qoodame: $distributed / ${question.total}",

style:

const TextStyle(

fontSize:22,

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