import 'package:flutter/material.dart';

import '../data/food_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class FoodScreen extends StatelessWidget {


  const FoodScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🍽️ Nyaataa fi Dhugaatii",





      color:

      Colors.red,





      items:

      foodData,





      rajiMessage:

      "Nyaata fi dhugaatii fayyaa keenyaaf gaarii ta'an waliin haa barannu! 🍎🥛😊",





      // Uniform lesson tracking ID

      lessonId:

      LessonIds.food,



    );



  }



}