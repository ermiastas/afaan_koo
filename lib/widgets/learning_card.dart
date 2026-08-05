import 'package:flutter/material.dart';

import '../models/learning_item.dart';


class LearningCard extends StatelessWidget {


final LearningItem item;

final VoidCallback onTap;


const LearningCard({

super.key,

required this.item,

required this.onTap,

});



@override
Widget build(BuildContext context){


return GestureDetector(

onTap:onTap,


child:Card(

elevation:5,

shape:RoundedRectangleBorder(

borderRadius:BorderRadius.circular(20),

),



child:Column(

mainAxisAlignment:MainAxisAlignment.center,


children:[


Expanded(

child:Image.asset(

item.image,

fit:BoxFit.contain,

errorBuilder:(context,error,stackTrace){

return const Icon(

Icons.image,

size:70,

);

},

),

),



Text(

item.nameOromo,

style:const TextStyle(

fontSize:20,

fontWeight:FontWeight.bold,

),

),



Text(

item.nameEnglish,

style:const TextStyle(

color:Colors.grey,

),

),


],

),

),


);


}


}