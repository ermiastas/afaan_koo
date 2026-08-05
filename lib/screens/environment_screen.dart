import 'package:flutter/material.dart';

import '../data/environment_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class EnvironmentScreen extends StatelessWidget {


  const EnvironmentScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🌍 Naannoo Koo",





      color:

      Colors.green,





      items:

      environmentData,





      rajiMessage:

      "Naannoo keenya beekuu, qulqullina isaa eeguu fi uumama tiksuu haa barannu! 🌱😊",





      // Uniform lesson tracking ID

      lessonId:

      LessonIds.environment,



    );



  }



}