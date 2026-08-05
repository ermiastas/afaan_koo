import 'package:flutter/material.dart';



class RewardDialog extends StatelessWidget {


final String rajiMessage;

final int stars;

final String? badge;



const RewardDialog({

super.key,

required this.rajiMessage,

required this.stars,

this.badge,

});





@override
Widget build(BuildContext context){



return AlertDialog(


shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(25),

),



title:

const Text(

"🎉 Baga Gammadde!",

textAlign:

TextAlign.center,

style:

TextStyle(

fontSize:24,

fontWeight:

FontWeight.bold,

),

),



content:

Column(

mainAxisSize:

MainAxisSize.min,

children:[



const Text(

"😊 Rajaiin siin boonaa jira!",

textAlign:

TextAlign.center,

style:

TextStyle(

fontSize:18,

),

),



const SizedBox(height:15),



Text(

"⭐ +$stars Star argatte!",

textAlign:

TextAlign.center,

style:

const TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),




const SizedBox(height:15),



Text(

rajiMessage,

textAlign:

TextAlign.center,

),



if(badge != null)...[


const SizedBox(height:20),



Text(

"🏆 Bajii Haaraa Argatte!\n$badge",

textAlign:

TextAlign.center,

style:

const TextStyle(

fontSize:18,

fontWeight:

FontWeight.bold,

),

),


],



],


),



actions:[


TextButton(

onPressed:(){

Navigator.pop(context);

},


child:

const Text(

"Itti fufi",

),

),



],


);



}



}