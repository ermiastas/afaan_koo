import 'package:flutter/material.dart';

import '../data/family_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class FamilyScreen extends StatelessWidget {


  const FamilyScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "👨‍👩‍👧 Maatii Koo",





      color:

      Colors.pink,





      items:

      familyData,





      rajiMessage:

      "Maqaa miseensota maatii keenya haa barannu; jaalala fi kabaja maatiif qabnu haa guddifannu! ❤️😊",





      // Uniform lesson tracking ID

      lessonId:

      LessonIds.family,



    );



  }



}