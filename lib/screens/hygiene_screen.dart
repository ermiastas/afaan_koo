import 'package:flutter/material.dart';

import '../data/hygiene_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class HygieneScreen extends StatelessWidget {


  const HygieneScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context) {



    return LearningScreen(



      title:

      "🧼 Qulqullina Qaamaa",





      color:

      Colors.blue,





      items:

      hygieneData,





      rajiMessage:

      "Qulqullina qaama keenyaa eeggachuu waliin ha barannu. Qulqullina qaama keenyaa eeguun fayyaa keenya eeggachuu dha!",





      // Uniform ProgressProvider lesson ID

      lessonId:

      LessonIds.hygiene,



    );


  }


}