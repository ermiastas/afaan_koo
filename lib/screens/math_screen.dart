import 'package:flutter/material.dart';

import '../data/math_data.dart';

import 'math_lesson_detail_screen.dart';
import '../utils/responsive.dart';



class MathScreen extends StatelessWidget {


const MathScreen({
super.key,
});



@override
Widget build(BuildContext context){


return Scaffold(


appBar:

AppBar(

title:

const Text(
"➕ Herrega Koo",
),

),




body:

GridView.builder(


padding:

EdgeInsets.all(Responsive.pagePadding(context)),



gridDelegate:

Responsive.homeGridDelegate(
context,

crossAxisSpacing:15,

mainAxisSpacing:15,

),




itemCount:

mathLessons.length,




itemBuilder:(context,index){


final lesson =
mathLessons[index];



return InkWell(


borderRadius:
BorderRadius.circular(25),


onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

MathLessonDetailScreen(

lesson:lesson,

),

),

);


},




child:

Container(


decoration:

BoxDecoration(

color:
lesson.color,

borderRadius:
BorderRadius.circular(25),

),



child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,

children:[


Icon(

lesson.icon,

size:60,

color:
Colors.white,

),



const SizedBox(height:15),



Text(

lesson.titleOromo,

textAlign:
TextAlign.center,

style:

const TextStyle(

color:
Colors.white,

fontSize:22,

fontWeight:
FontWeight.bold,

),

),


],


),



),


);


},


),



);


}



}
