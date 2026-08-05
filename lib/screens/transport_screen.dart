import 'package:flutter/material.dart';

import '../data/transport_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class TransportScreen extends StatelessWidget {


  const TransportScreen({

    super.key,

  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🚗 Geejjiba Koo",



      color:

      Colors.teal,



      items:

      transportData,



      rajiMessage:

      "Geejjiba adda addaa haa barannu!",



      // ProgressProvider lesson ID

      lessonId:

      LessonIds.transport,



    );


  }



}