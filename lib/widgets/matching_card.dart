import 'package:flutter/material.dart';



class MatchingCard extends StatelessWidget {


final String content;

final bool selected;

final VoidCallback onTap;



const MatchingCard({

super.key,

required this.content,

required this.selected,

required this.onTap,

});



@override
Widget build(BuildContext context){


return GestureDetector(

onTap:onTap,


child:

AnimatedContainer(

duration:

const Duration(milliseconds:300),



margin:

const EdgeInsets.all(8),



height:100,

width:100,



decoration:

BoxDecoration(

borderRadius:

BorderRadius.circular(20),


color:

selected

?

Colors.orange

:

Colors.blue,



),



child:

Center(

child:

Text(

content,

style:

const TextStyle(

fontSize:25,

color:
Colors.white,

),

),

),

),

);

}

}