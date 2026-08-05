import 'package:flutter/material.dart';

import '../data/time_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class TimeScreen extends StatelessWidget {


  const TimeScreen({

    super.key,

  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🕒 Yeroo Koo",



      color:

      Colors.deepOrange,



      items:

      timeData,



      rajiMessage:

      "Yeroo sirriitti fayyadamu haa barannu!",



      // ProgressProvider lesson ID

      lessonId:

      LessonIds.time,



    );


  }



}