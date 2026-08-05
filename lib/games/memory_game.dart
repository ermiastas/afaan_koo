import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/animal_data.dart';
import '../models/memory_card.dart';
import '../providers/reward_provider.dart';
import '../models/game_item.dart';
import '../models/raji_message.dart';
import '../widgets/raji/raji_widget.dart';


class MemoryGame extends StatefulWidget {


  final GameItem game;


  const MemoryGame({

    super.key,

    required this.game,

  });



  @override
  State<MemoryGame> createState()
      => _MemoryGameState();


}



class _MemoryGameState extends State<MemoryGame>{


  late GameItem game;



List<MemoryCard> cards = [];


int? firstIndex;


int score = 0;


int moves = 0;


int combo = 0;


int seconds = 60;


bool lockBoard = false;


Timer? timer;




@override

@override
void initState(){

super.initState();


game = widget.game;


createCards();

startTimer();


}



void createCards(){


final animals =
animalData.take(6).toList();



cards = [


for(var animal in animals)

MemoryCard(

image:
animal.image,

),



for(var animal in animals)

MemoryCard(

image:
animal.image,

),



];



cards.shuffle(Random());


}




void startTimer(){


timer =
Timer.periodic(

const Duration(seconds:1),

(timer){


if(seconds == 0){

timer.cancel();

finishGame();

}


else{


setState((){

seconds--;

});


}


});


}




void flipCard(int index){



if(lockBoard){

return;

}



if(cards[index].isOpen ||
cards[index].isMatched){

return;

}



setState((){

cards[index].isOpen=true;

});



if(firstIndex == null){


firstIndex=index;


}


else{


moves++;


lockBoard=true;


checkMatch(

firstIndex!,

index,

);


}



}






void checkMatch(

int first,

int second

){



if(cards[first].image ==
cards[second].image){



setState((){


cards[first].isMatched=true;

cards[second].isMatched=true;


score++;


combo++;


lockBoard=false;


});






_showMessage(

"Sirrii dha! 🔥 Combo $combo ⭐"

);



firstIndex=null;



if(score == cards.length ~/2){

finishGame();

}



}



else{



combo=0;



Future.delayed(

const Duration(seconds:1),

(){



setState((){


cards[first].isOpen=false;

cards[second].isOpen=false;


lockBoard=false;


});



},


);



firstIndex=null;



}



}







int calculateXP(){


int base=40;


if(combo >=5){

return base+20;

}


if(combo>=3){

return base+10;

}


return base;


}






int calculateStars(){


double accuracy =

score ==0

?0

:

score / moves;



if(accuracy >=0.9){

return 3;

}


if(accuracy >=0.6){

return 2;

}


return 1;


}






void finishGame(){



timer?.cancel();



//final stars =
//calculateStars();


context
.read<RewardProvider>()
.completeGame(

xp:

game.rewardXP,

coins:

game.rewardCoins,

stars:

game.rewardStars,

gameId:

game.id,

);

showDialog(

context:context,

builder:(context){


return AlertDialog(


shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(25),

),



content:

Column(

mainAxisSize:

MainAxisSize.min,

children:[



RajiWidget(

message:

RajiMessage(

text:

"Baay'ee gaariidha! Yaadannoo cimaa qabda 🧠🎉",

mood:

RajiMood.celebrating,

),

),



const SizedBox(height:15),



Text(

"⭐"*game.rewardStars,

style:

const TextStyle(

fontSize:35,

),

),



Text(

"+${game.rewardXP} XP",

style:

const TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),



Text(

"+${game.rewardCoins} 🪙",

style:

const TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),


],

),



);


},

);



}






void _showMessage(String text){


ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

content:

Text(text),

),

);


}







@override
void dispose(){


timer?.cancel();

super.dispose();


}






@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

Text(

"Yaadannoo 🧠 ⭐ $score"

),



actions:[

Padding(

padding:

const EdgeInsets.all(12),


child:

Center(

child:

Text(

"⏱ $seconds",

style:

const TextStyle(

fontSize:18,

),

),

),

)

],



),





body:

Column(

children:[



 Padding(

padding:

EdgeInsets.all(10),


child:

RajiWidget(

message:

RajiMessage(

text:

"Fakkiiwwan wal fakkaatan yaadadhuu walitti fidi! 🧠",

mood:

RajiMood.encouraging,

),

),

),





Expanded(


child:

GridView.builder(


padding:

const EdgeInsets.all(20),



gridDelegate:

const SliverGridDelegateWithFixedCrossAxisCount(


crossAxisCount:3,


crossAxisSpacing:10,


mainAxisSpacing:10,


),




itemCount:

cards.length,




itemBuilder:

(context,index){



final card =
cards[index];





return GestureDetector(



onTap:(){

flipCard(index);

},





child:

AnimatedContainer(

duration:

const Duration(milliseconds:300),



decoration:

BoxDecoration(

borderRadius:

BorderRadius.circular(15),

color:

card.isMatched

?

Colors.green.shade300

:

Colors.white,

boxShadow:[


const BoxShadow(

blurRadius:5,

color:

Colors.black26,

)

],

),




child:

Center(



child:

card.isOpen ||

card.isMatched



?

Image.asset(

card.image,

height:70,

)



:

const Icon(

Icons.help_outline,

size:50,

),



),



),



);



},



),


),



],

),



);



}


}