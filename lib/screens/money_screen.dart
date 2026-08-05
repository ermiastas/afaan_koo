import 'package:flutter/material.dart';

import '../data/money_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class MoneyScreen extends StatelessWidget {


  const MoneyScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "💰 Qarshii Koo",




      color:

      Colors.amber,




      items:

      moneyData,




      rajiMessage:

      "Raji:\n"

      "Qarshii sirriitti fayyadamuu, qusachuu fi itti gaafatamummaa qabaachuu haa barannu!",





      // Connected to ProgressProvider
      lessonId:

      LessonIds.money,



    );


  }



}