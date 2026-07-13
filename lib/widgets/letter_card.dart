import 'package:flutter/material.dart';


class LetterCard extends StatelessWidget{


final String letter;

final String word;

final String image;

final VoidCallback onTap;



const LetterCard({

super.key,

required this.letter,

required this.word,

required this.image,

required this.onTap,

});



@override

Widget build(BuildContext context){


return InkWell(

onTap:onTap,


child:

Card(

elevation:5,


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(20),

),


child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


Text(

letter,

style:

const TextStyle(

fontSize:50,

fontWeight:
FontWeight.bold,

),

),



Image.asset(

image,

height:100,

),



Text(

word,

style:

const TextStyle(

fontSize:22,

),

),


],

),

),

);

}

}
