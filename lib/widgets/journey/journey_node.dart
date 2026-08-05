import 'package:flutter/material.dart';

import '../../models/journey_item.dart';



class JourneyNode extends StatelessWidget {


final JourneyItem item;

final VoidCallback onTap;



const JourneyNode({

super.key,

required this.item,

required this.onTap,

});



@override
Widget build(BuildContext context){


return GestureDetector(

onTap:
item.unlocked ? onTap : null,


child:

Column(

children:[


AnimatedContainer(

duration:
const Duration(milliseconds:500),


width:90,

height:90,


decoration:

BoxDecoration(


shape:
BoxShape.circle,


gradient:

item.unlocked ?

const LinearGradient(

colors:[

Colors.blue,

Colors.purple,

],

)

:

const LinearGradient(

colors:[

Colors.grey,

Colors.black12,

],

),


boxShadow:

item.completed ?

[

const BoxShadow(

blurRadius:20,

color:
Colors.amber,

)

]

:

[],


),



child:

Center(

child:

Text(

item.unlocked ?

item.icon

:

"🔒",


style:

const TextStyle(

fontSize:40,

),

),

),

),



const SizedBox(height:8),



Text(

item.title,

style:

const TextStyle(

fontWeight:
FontWeight.bold,

),

),



if(item.completed)

Text(

"⭐"*item.stars,

),

],

),


);


}

}