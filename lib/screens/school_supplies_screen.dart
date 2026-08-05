import 'package:flutter/material.dart';

import '../data/school_supplies_data.dart';

import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class SchoolSuppliesScreen extends StatelessWidget {


  const SchoolSuppliesScreen({

    super.key,

  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🎒 Meeshaalee Barumsaa",



      color:

      Colors.purple,



      items:

      schoolSuppliesData,



      rajiMessage:

      "Meeshaalee mana barumsaa keenya haa beeknu!",



      // ProgressProvider lesson ID

      lessonId:

      LessonIds.schoolSupplies,



    );


  }



}