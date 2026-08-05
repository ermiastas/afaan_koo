import 'package:flutter/material.dart';


import '../data/handwriting_categories.dart';

import '../data/handwriting_data.dart';
import '../widgets/handwriting_category_card.dart';

import 'handwriting_game_screen.dart';



class HandwritingCategoryScreen
extends StatelessWidget {


const HandwritingCategoryScreen({

super.key,

});



@override
Widget build(BuildContext context){


return Scaffold(


appBar:

AppBar(

title:

const Text(
"✍️ Barreessi Koo",
),

centerTitle:true,

),



body:

ListView.builder(

padding:
const EdgeInsets.all(16),


itemCount:
handwritingCategories.length,


itemBuilder:(context,index){


final item =
handwritingCategories[index];



final count =
handwritingData
    .where(
      (x)=>
      x.category ==
      item.category,
)
    .length;



return Padding(

padding:
const EdgeInsets.only(
bottom:15,
),



child:

HandwritingCategoryCard(


item:item,


letterCount:
count,


completedCount:
0,


onTap:(){



Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

HandwritingGameScreen(

category:
item.category,

),

),

);



},


),


);



},


),

);

}
}