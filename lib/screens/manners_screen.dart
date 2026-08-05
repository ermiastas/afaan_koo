import 'package:flutter/material.dart';

import '../data/manners_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class MannersScreen extends StatelessWidget {


  const MannersScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "😊 Naamusa Gaarii",




      color:

      Colors.orange,




      items:

      mannersData,




      rajiMessage:

      "Raji:\n"

      "Amala gaarii qabaachuun nama jaallatamaa fi kabajamaa si taasisa!",





      // Connected with ProgressProvider
      lessonId:

      LessonIds.manners,



    );


  }


}