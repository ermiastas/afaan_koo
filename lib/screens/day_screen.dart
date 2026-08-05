import 'package:flutter/material.dart';

import '../data/day_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class DayScreen extends StatelessWidget {


  const DayScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "📅 Guyyoota Torbanii",





      color:

      Colors.blue,





      items:

      dayData,





      rajiMessage:

      "Guyyoota torbanii waliin haa barannu! 📅😊",





      // Uniform lesson tracking ID

      lessonId:

      LessonIds.day,



    );



  }



}