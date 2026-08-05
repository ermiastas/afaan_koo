import 'package:flutter/material.dart';

import '../data/oromo_culture_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class OromoCultureScreen extends StatelessWidget {


  const OromoCultureScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🏛️ Aadaa Oromoo",



      color:

      Colors.brown,



      items:

      oromoCultureData,



      rajiMessage:

      "Aadaa fi duudhaa Oromoo keenya haa waliin barannu!",



      // ProgressProvider lesson ID
      lessonId:

      LessonIds.oromoCulture,



    );


  }


}