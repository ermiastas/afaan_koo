import 'package:flutter/material.dart';
import '../screens/quiz_screen.dart';


class QuizHomeCard extends StatelessWidget {


const QuizHomeCard({
super.key,
});


@override
Widget build(BuildContext context){

return InkWell(

onTap:(){

Navigator.push(

context,

MaterialPageRoute(
builder:(_)=>const QuizScreen(),
),

);

},


child:Container(

padding:
const EdgeInsets.all(20),

decoration:

BoxDecoration(

gradient:

const LinearGradient(

colors:[
Colors.purple,
Colors.deepPurple,
],

),

borderRadius:
BorderRadius.circular(25),

),


child:

const Row(

children:[


Text(
"⭐",
style:
TextStyle(
fontSize:45,
),
),


SizedBox(width:15),


Expanded(

child:

Text(

"Quiz Koo\n"
"Beekumsa kee qoradhu!",

style:

TextStyle(

color:
Colors.white,

fontSize:
20,

fontWeight:
FontWeight.bold,

),

),

),


Icon(

Icons.arrow_forward_ios,

color:
Colors.white,

),

],

),

),

);

}

}
