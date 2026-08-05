import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/money_game_data.dart';
import '../../models/money_question.dart';
import '../../providers/reward_provider.dart';



class MoneyMathGameScreen extends StatefulWidget {


const MoneyMathGameScreen({

super.key,

});



@override
State<MoneyMathGameScreen> createState()

=> _MoneyMathGameScreenState();


}




class _MoneyMathGameScreenState

extends State<MoneyMathGameScreen>{



late List<MoneyQuestion> questions;


int current=0;


int moneyGiven=0;


bool completed=false;



@override
void initState(){


super.initState();


questions =
generateMoneyQuestions();


}




MoneyQuestion get question =>

questions[current];







void addMoney(int value){


setState((){

moneyGiven += value;

});



if(moneyGiven >= question.price){


checkPayment();


}


}







void checkPayment(){



if(moneyGiven == question.price){



final reward =
Provider.of<RewardProvider>(

context,

listen:false,

);



reward.addStars(3);

reward.addCoins(2);



showRaji(

"Sirrii dha! Bittaa xumurteetta 🛒⭐",

);



Future.delayed(

const Duration(seconds:2),

nextQuestion,

);



}

else{


showRaji(

"Maallaqa baay'ee kennite. Yaali 😊",

);


}



}







void nextQuestion(){


if(current < questions.length-1){


setState((){


current++;

moneyGiven=0;


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

"🏪 Mana Daldalaa Xumurteetta",

),



content:

const Text(

"Herrega maallaqaa sirriitti baratte!",

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

"🛒 Mana Daldalaa Koo",

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

"😊 Raji Shop",

style:

const TextStyle(

fontSize:30,

fontWeight:

FontWeight.bold,

),

),






const SizedBox(height:20),






Text( question.emoji,

style:

const TextStyle(

fontSize:80,

),

),




Text(

question.item,

style:

const TextStyle(

fontSize:28,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:15),




Text(

"Gatiin: \$${question.price}",

style:

const TextStyle(

fontSize:25,

),

),






const SizedBox(height:30),





Container(

padding:

const EdgeInsets.all(20),


decoration:

BoxDecoration(

color:

Colors.green.shade100,

borderRadius:

BorderRadius.circular(25),

),



child:

Text(

"💵 Kennite: \$$moneyGiven",

style:

const TextStyle(

fontSize:25,

fontWeight:

FontWeight.bold,

),

),



),





const SizedBox(height:30),




Wrap(

spacing:15,


children:[



moneyButton(1),

moneyButton(2),

moneyButton(5),


],



),





const SizedBox(height:25),




Text(

"Barbaachisummaa: \$${question.price}",

style:

const TextStyle(

fontSize:20,

),

),




],



),



),



);



}







Widget moneyButton(int amount){



return ElevatedButton(



onPressed:

(){

addMoney(amount);

},



child:

Text(

"\$$amount 💵",

style:

const TextStyle(

fontSize:20,

),

),



);



}




}