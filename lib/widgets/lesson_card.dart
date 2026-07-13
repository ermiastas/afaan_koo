import 'package:flutter/material.dart';



class LessonCard extends StatelessWidget {


final String title;

final IconData icon;

final Color color;

final VoidCallback onTap;



const LessonCard({

super.key,

required this.title,

required this.icon,

required this.color,

required this.onTap,

});




@override
Widget build(BuildContext context){


return InkWell(


onTap:onTap,

borderRadius:

BorderRadius.circular(30),



child:

Container(


margin:

const EdgeInsets.all(10),



decoration:

BoxDecoration(

color:

color,

borderRadius:

BorderRadius.circular(30),

boxShadow:[


const BoxShadow(

blurRadius:8,

offset:

Offset(0,5),

color:

Colors.black26,

),


],


),





child:

Column(


mainAxisAlignment:

MainAxisAlignment.center,



children:[




Container(

padding:

const EdgeInsets.all(15),


decoration:

const BoxDecoration(

color:

Colors.white,

shape:

BoxShape.circle,

),



child:

Icon(

icon,

size:

55,

color:

Colors.orange,

),


),





const SizedBox(

height:15,

),






Text(

title,

textAlign:

TextAlign.center,


style:

const TextStyle(

fontSize:20,

fontWeight:

FontWeight.bold,

color:

Colors.white,

),

),





],



),



),



);


}


}