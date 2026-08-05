import 'package:flutter/material.dart';

import '../data/lesson_categories.dart';

import '../widgets/category_card.dart';

import 'lesson_list_screen.dart';



class CategoryScreen extends StatelessWidget {


const CategoryScreen({super.key});



@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

const Text(

"📚 Barnoota AfaanKoo",

),

centerTitle:true,

),





body:

GridView.builder(



padding:

const EdgeInsets.all(16),




gridDelegate:

const SliverGridDelegateWithFixedCrossAxisCount(


crossAxisCount:2,


crossAxisSpacing:15,


mainAxisSpacing:15,


),





itemCount:

categories.length,





itemBuilder:

(context,index){



final category = categories[index];




return CategoryCard(



title:

category.title,



subtitle:

category.subtitle,



emoji:

category.emoji,



color:

category.color,




onTap:(){



Navigator.push(


context,


MaterialPageRoute(



builder:(context)

=> LessonListScreen(

category:category,

),



),



);



},



);



},




),




);



}



}