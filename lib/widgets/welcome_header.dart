import 'package:flutter/material.dart';


class WelcomeHeader extends StatelessWidget{


const WelcomeHeader({super.key});


@override

Widget build(BuildContext context){


return Row(

children:[


Image.asset(

"assets/images/kooree.png",

height:80,

),



const SizedBox(width:15),



const Column(

crossAxisAlignment:

CrossAxisAlignment.start,


children:[


Text(

"Akkam 👋",

style:

TextStyle(

fontSize:26,

fontWeight:

FontWeight.bold,

),

),



Text(

"Har'a haa barannu!",

),

],


)

],

);

}

}
