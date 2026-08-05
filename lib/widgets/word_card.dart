import 'dart:io';

import 'package:flutter/material.dart';



class WordCard extends StatelessWidget {


final String word;

final String image;

final VoidCallback onTap;




const WordCard({

super.key,

required this.word,

required this.image,

required this.onTap,

});







@override
Widget build(BuildContext context){



return InkWell(



onTap:

onTap,



borderRadius:

BorderRadius.circular(20),






child:

Card(



elevation:

5,



shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(20),

),







child:

Padding(

padding:

const EdgeInsets.all(10),





child:

Column(



mainAxisAlignment:

MainAxisAlignment.center,



children:[





Expanded(

child:

buildImage(),

),







const SizedBox(

height:10,

),







Text(



word,



textAlign:

TextAlign.center,



style:

const TextStyle(



fontSize:

25,



fontWeight:

FontWeight.bold,



),



),





],



),



),



),



);



}








Widget buildImage(){



if(image.isEmpty){



return const Icon(

Icons.image,

size:80,

);



}







// Admin saved local image

if(image.startsWith("/")){



return ClipRRect(



borderRadius:

BorderRadius.circular(15),





child:

Image.file(



File(image),



fit:

BoxFit.cover,



errorBuilder:

(context,error,stack){



return const Icon(

Icons.broken_image,

size:80,

);



},



),



);



}







// JSON asset image

return ClipRRect(



borderRadius:

BorderRadius.circular(15),





child:

Image.asset(



image,



fit:

BoxFit.cover,



errorBuilder:

(context,error,stack){



return const Icon(

Icons.broken_image,

size:80,

);



},



),



);



}



}