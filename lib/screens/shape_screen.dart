import 'package:flutter/material.dart';

import '../data/shape_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class ShapeScreen extends StatelessWidget {


  const ShapeScreen({

    super.key,

  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🔷 Bocaalee Koo",



      color:

      Colors.purple,



      items:

      shapeData,



      rajiMessage:

      "Bocaalee adda addaa waliin haa barannu!",



      // ProgressProvider lesson ID

      lessonId:

      LessonIds.shape,



    );


  }



}