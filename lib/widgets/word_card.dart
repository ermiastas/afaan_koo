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

onTap:onTap,


child:

Card(

elevation:5,

child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


Image.asset(

image,

height:100,

),



Text(

word,

style:

const TextStyle(

fontSize:25,

fontWeight:
FontWeight.bold,

),

),


],

),

),

);

}

}
