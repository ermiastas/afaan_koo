import 'package:flutter/material.dart';

import '../data/traffic_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class TrafficScreen extends StatelessWidget {


  const TrafficScreen({

    super.key,

  });



  @override
  Widget build(BuildContext context) {



    return LearningScreen(



      title:

      "🚦 Nageenya Daandii",




      color:

      Colors.orange,




      items:

      trafficData,





      rajiMessage:

      "Daandii irratti of eeggannoo godhuu waliin haa barannu. Nageenyi barbaachisaa dha!",





      // ProgressProvider lesson ID

      lessonId:

      LessonIds.traffic,



    );


  }


}