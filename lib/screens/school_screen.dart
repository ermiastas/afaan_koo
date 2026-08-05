import 'package:flutter/material.dart';

import '../data/school_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class SchoolScreen extends StatelessWidget {


  const SchoolScreen({

    super.key,

  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🏫 Mana Barumsaa Koo",



      color:

      Colors.blue,



      items:

      schoolData,



      rajiMessage:

      "Waa'ee mana barumsaa waliin haa barannu!",



      // ProgressProvider lesson ID

      lessonId:

      LessonIds.school,



    );


  }


}