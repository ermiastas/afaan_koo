import 'package:flutter/material.dart';

import '../data/home_object_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class HomeObjectScreen extends StatelessWidget {


  const HomeObjectScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context) {



    return LearningScreen(



      title:

      "🏠 Mana Koo",





      color:

      Colors.brown,





      items:

      homeObjectData,





      rajiMessage:

      "Meeshaalee mana keessaa waliin haa barannu!",





      // Uniform ProgressProvider lesson ID

      lessonId:

      LessonIds.homeObject,



    );


  }



}