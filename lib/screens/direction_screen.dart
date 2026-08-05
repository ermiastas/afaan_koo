import 'package:flutter/material.dart';

import '../data/direction_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class DirectionScreen extends StatelessWidget {


  const DirectionScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🧭 Kallattii Koo",





      color:

      Colors.indigo,





      items:

      directionData,





      rajiMessage:

      "Kallattiiwwan adda addaa waliin haa barannu! 🧭😊",





      // Uniform lesson tracking ID

      lessonId:

      LessonIds.direction,



    );



  }



}