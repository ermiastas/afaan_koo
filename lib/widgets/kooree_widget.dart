import 'package:flutter/material.dart';



class KooreeWidget extends StatelessWidget {


final String message;



const KooreeWidget({

super.key,

required this.message,

});




@override
Widget build(BuildContext context){


return Container(


padding:

const EdgeInsets.all(15),



decoration:

BoxDecoration(

color:

Colors.yellow.shade100,

borderRadius:

BorderRadius.circular(25),

),




child:

Row(

children:[



Image.asset(

"assets/images/kooree.png",

height:

100,

),




const SizedBox(

width:15,

),





Expanded(

child:

Text(

message,


style:

const TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),


),





],


),


);


}


}