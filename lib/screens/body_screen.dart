import 'package:flutter/material.dart';

import '../data/body_data.dart';
import 'learning_screen.dart';



class BodyScreen extends StatelessWidget {


  const BodyScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🧍 Qaama Koo",



      color:

      Colors.pink,



      items:

      bodyData,



      rajiMessage:

      "Qaamota keenya haa barannu haa kunuunsinu!",



      // Unique lesson ID for ProgressProvider
      lessonId:

      "body",



    );


  }



}