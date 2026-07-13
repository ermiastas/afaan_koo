import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/animal_data.dart';
import '../models/memory_card.dart';
import '../providers/reward_provider.dart';



class MemoryGame extends StatefulWidget {


const MemoryGame({super.key});


@override
State<MemoryGame> createState()
=> _MemoryGameState();


}





class _MemoryGameState extends State<MemoryGame>{


List<MemoryCard> cards = [];



int? firstIndex;

int score = 0;



@override
void initState(){

super.initState();

createCards();

}




void createCards(){


final animals =
animalData.take(6).toList();



cards = [

for(var animal in animals)

MemoryCard(

image:animal.image,

),



for(var animal in animals)

MemoryCard(

image:animal.image,

),



];



cards.shuffle(Random());


}







void flipCard(int index){



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


checkMatch(

firstIndex!,

index

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


});



final reward =
Provider.of<RewardProvider>(

context,

listen:false,

);



reward.addStars(1);



_showMessage(

"Walitti dhufan! ⭐"

);



firstIndex=null;



}


else{


Future.delayed(

const Duration(seconds:1),

(){


setState((){


cards[first].isOpen=false;

cards[second].isOpen=false;


});


},


);



firstIndex=null;



}



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
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

Text(

"Yaadannoo 🧠 ⭐ $score"

),

),





body:

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

Card(



shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(15),

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



);



}



}