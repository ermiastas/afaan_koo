import 'package:flutter/material.dart';

import '../data/plant_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class PlantScreen extends StatelessWidget {


  const PlantScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {



    return LearningScreen(



      title:

      "🌱 Biqiltuu Koo",



      color:

      Colors.green,



      items:

      plantData,



      rajiMessage:

      "Biqiltoota naannoo keenyatti argaman waliin haa barannu!",



      // ProgressProvider lesson ID
      lessonId:

      LessonIds.plants,



    );


  }


}