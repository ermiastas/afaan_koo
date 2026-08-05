import 'package:flutter/material.dart';

import '../widgets/reward_popup.dart';

import '../services/raji_service.dart';



void showReward(

BuildContext context,

{


required int xp,

required int coins,

required int stars,


}){


RajiService.showMessage(

context,

);



showDialog(

context:context,

builder:

(_)=>

RewardPopup(

xp:xp,

coins:coins,

stars:stars,

),

);



}