import 'package:flutter/material.dart';

import '../data/clothing_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class ClothingScreen extends StatelessWidget {


  const ClothingScreen({

    super.key,

  });





  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "👕 Uffata Koo",





      color:

      Colors.pink,





      items:

      clothingData,





      rajiMessage:

      "Uffata uffannuu fi maqaa isaanii waliin haa barannu! 👕😊",





      // Uniform lesson tracking ID

      lessonId:

      LessonIds.clothing,



    );



  }


}