import 'package:flutter/material.dart';

import '../data/month_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class MonthScreen extends StatelessWidget {


  const MonthScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "📆 Ji'oota Waggaa",




      color:

      Colors.green,




      items:

      monthData,




      rajiMessage:

      "Raji:\n"

      "Ji'oota waggaa kudha lamaan haa barannu! "

      "Yeroo fi waqtii sirriitti beekuun baay'ee barbaachisaa dha.",





      // Connected to ProgressProvider
      lessonId:

      LessonIds.month,



    );


  }



}