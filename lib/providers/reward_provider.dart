import 'package:flutter/material.dart';

import '../services/reward_service.dart';



class RewardProvider extends ChangeNotifier {


final RewardService service =
RewardService();



int _stars = 0;



int get stars =>
_stars;



RewardProvider(){

loadStars();

}



Future<void> loadStars() async{


_stars =
await service.getStars();


notifyListeners();


}



Future<void> addStars(int amount) async{


_stars += amount;


await service.addStars(amount);


notifyListeners();


}



}