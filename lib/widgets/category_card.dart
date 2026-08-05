import 'package:flutter/material.dart';


class CategoryCard extends StatelessWidget {


final String title;
final String subtitle;
final String emoji;
final Color color;
final VoidCallback onTap;



const CategoryCard({

super.key,

required this.title,

required this.subtitle,

required this.emoji,

required this.color,

required this.onTap,

});




@override
Widget build(BuildContext context){


return InkWell(

onTap:onTap,


borderRadius:
BorderRadius.circular(20),


child:

Container(

padding:
const EdgeInsets.all(12),


decoration:

BoxDecoration(

color:color,

borderRadius:
BorderRadius.circular(20),

),



child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[



Text(

emoji,

style:
const TextStyle(

fontSize:40,

),

),




const SizedBox(height:10),




Text(

title,

textAlign:
TextAlign.center,


maxLines:2,

overflow:
TextOverflow.ellipsis,


style:

const TextStyle(

fontSize:17,

fontWeight:
FontWeight.bold,

color:Colors.white,

),

),




const SizedBox(height:5),




Text(

subtitle,

textAlign:
TextAlign.center,


maxLines:2,

overflow:
TextOverflow.ellipsis,


style:

const TextStyle(

fontSize:12,

color:Colors.white,

),

),



],


),


),


);


}


}