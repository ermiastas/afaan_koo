import 'package:flutter/material.dart';

import '../widgets/kooree_widget.dart';
import '../widgets/lesson_card.dart';

import 'alphabet_screen.dart';
import 'animal_screen.dart';
import 'word_screen.dart';
import 'quiz_screen.dart';
import 'admin_screen.dart';



class HomeScreen extends StatelessWidget {


const HomeScreen({super.key});



@override
Widget build(BuildContext context){


return Scaffold(


body:

SafeArea(


child:

SingleChildScrollView(


padding:

const EdgeInsets.all(20),



child:

Column(


crossAxisAlignment:

CrossAxisAlignment.start,



children:[



const KooreeWidget(

message:

"Akkam! Har'a haa barannu 👋",

),




const SizedBox(

height:25,

),





const Text(

"Barnoota Koo 📚",

style:

TextStyle(

fontSize:28,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(

height:15,

),






GridView.count(


shrinkWrap:

true,


physics:

const NeverScrollableScrollPhysics(),



crossAxisCount:

2,



children:[


LessonCard(

title:"Admin 🔐",

icon:Icons.admin_panel_settings,

color:Colors.red,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const AdminScreen(),

),

);


},

),

LessonCard(

title:

"Qubee Koo 🔤",

icon:

Icons.abc,

color:

Colors.orange,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const AlphabetScreen(),

),

);


},


),





LessonCard(

title:

"Bineensa Koo 🐾",

icon:

Icons.pets,

color:

Colors.green,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

AnimalScreen(),

),

);


},


),





LessonCard(

title:

"Jechoota Koo 📝",

icon:

Icons.menu_book,

color:

Colors.blue,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const WordScreen(),

),

);


},


),





LessonCard(

title:

"Quiz ⭐",

icon:

Icons.quiz,

color:

Colors.purple,


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)

=>

const QuizScreen(),

),

);


},


),





],



),




],

),



),


),


);


}



}