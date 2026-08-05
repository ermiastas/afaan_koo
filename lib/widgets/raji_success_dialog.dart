import 'package:flutter/material.dart';



void showRajiSuccess(
BuildContext context,
String message,
){



showDialog(

context:context,


builder:(context){


return AlertDialog(


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(30),

),



content:

Column(

mainAxisSize:
MainAxisSize.min,


children:[



const Text(

"🎉",

style:

TextStyle(

fontSize:70,

),

),



const Text(

"Raji",

style:

TextStyle(

fontSize:28,

fontWeight:
FontWeight.bold,

),

),



Text(

message,

textAlign:
TextAlign.center,

style:

const TextStyle(

fontSize:18,

),

),



],


),



);


},


);


}