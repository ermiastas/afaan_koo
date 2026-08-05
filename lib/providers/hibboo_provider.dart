import 'package:flutter/material.dart';
import '../models/hibboo_item.dart';
import '../data/hibboo_data.dart';


class HibbooProvider extends ChangeNotifier {


  int currentIndex = 0;

  int score = 0;

  int coins = 0;

  bool answered = false;

  bool correct = false;



  HibbooItem get currentHibboo =>
      hibbooData[currentIndex];



  void checkAnswer(String userAnswer) {

    answered = true;


    if(userAnswer.trim().toLowerCase() ==
        currentHibboo.answer.toLowerCase()) {

      correct = true;

      score += currentHibboo.xpReward;

      coins += currentHibboo.coinsReward;

    }

    else {

      correct = false;

    }


    notifyListeners();

  }



  void nextHibboo(){

    if(currentIndex < hibbooData.length -1){

      currentIndex++;

      answered = false;

      correct = false;

    }


    notifyListeners();

  }


}