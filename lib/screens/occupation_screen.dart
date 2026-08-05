import 'package:flutter/material.dart';

import '../data/occupation_data.dart';

import 'learning_screen.dart';



class OccupationScreen extends StatelessWidget {


  const OccupationScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "👨‍🔧 Ogummaa Koo",



      color:

      Colors.blue,



      items:

      occupationData,



      rajiMessage:

      "Waa'ee namoota hojii adda addaa qabanii waliin haa barannu!",



      // ProgressProvider lesson ID
      lessonId:

      "occupations",



    );


  }



}