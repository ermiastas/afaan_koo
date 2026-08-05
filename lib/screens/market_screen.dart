import 'package:flutter/material.dart';

import '../data/market_data.dart';
import '../data/lesson_ids.dart';

import 'learning_screen.dart';



class MarketScreen extends StatelessWidget {


  const MarketScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context){



    return LearningScreen(



      title:

      "🛒 Gabaa Koo",




      color:

      Colors.teal,




      items:

      marketData,




      rajiMessage:

      "Raji:\n"

      "Gabaa keessatti wantoota adda addaa maqaa isaanii waliin haa barannu!",





      // Connected to ProgressProvider
      lessonId:

      LessonIds.market,



    );


  }



}