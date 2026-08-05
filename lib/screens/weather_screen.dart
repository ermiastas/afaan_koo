import 'package:flutter/material.dart';

import '../data/weather_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class WeatherScreen extends StatelessWidget {


  const WeatherScreen({

    super.key,

  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "⛅ Haala Qilleensaa",



      color:

      Colors.lightBlue,



      items:

      weatherData,





      rajiMessage:

      "Haala qilleensaa guyyaa guyyaa haa barannu!",





      // ProgressProvider lesson ID

      lessonId:

      LessonIds.weather,



    );


  }


}