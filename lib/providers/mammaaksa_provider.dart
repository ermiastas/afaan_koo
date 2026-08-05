import 'package:flutter/material.dart';
import '../data/mammaaksa_data.dart';
import '../models/mammaaksa_item.dart';


class MammaaksaProvider extends ChangeNotifier {

  int currentIndex = 0;

  int xp = 0;

  bool completed = false;


  List<MammaaksaItem> get mammaaksaList =>
      mammaaksaData;



  void changeIndex(int index){

    currentIndex = index;

    completed = false;

    notifyListeners();

  }



  void completeMammaaksa(){

    if(!completed){

      xp += 10;

      completed = true;

      notifyListeners();

    }

  }

}