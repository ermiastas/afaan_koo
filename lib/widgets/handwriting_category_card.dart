import 'package:flutter/material.dart';

import '../models/handwriting_category.dart';



class HandwritingCategoryCard extends StatelessWidget {


final HandwritingCategory item;

final int letterCount;

final int completedCount;

final VoidCallback onTap;



const HandwritingCategoryCard({

super.key,

required this.item,

required this.letterCount,

required this.completedCount,

required this.onTap,

});




@override
Widget build(BuildContext context){


final stars =
completedCount == 0
? 0
: ((completedCount / letterCount) * 5)
    .round();



return InkWell(


onTap:onTap,


borderRadius:
BorderRadius.circular(25),



child:

Card(


elevation:6,


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(25),

),



child:

Padding(

padding:
const EdgeInsets.all(18),



child:

Row(

children:[



Container(

padding:
const EdgeInsets.all(12),


decoration:

BoxDecoration(

shape:BoxShape.circle,

color:
Colors.orange.shade100,

),



child:

Text(

item.emoji,

style:

const TextStyle(

fontSize:40,

),

),


),




const SizedBox(width:15),





Expanded(

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[



Text(

item.title,

style:

const TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

),

),




Text(

item.subtitle,

style:

const TextStyle(

fontSize:17,

),

),




const SizedBox(height:8),




Row(

children:[



Text(

"$letterCount Qubee",

style:

const TextStyle(

fontSize:16,

fontWeight:
FontWeight.bold,

),

),


const SizedBox(width:15),



Text(

"⭐"*stars +

"☆"*(5-stars),


style:

const TextStyle(

fontSize:18,

),

),



],


),



],


),


),




const Icon(

Icons.arrow_forward_ios,

),



],


),


),


),


);



}


}