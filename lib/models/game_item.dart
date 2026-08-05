import 'package:flutter/material.dart';


class GameItem {


  final String id;

  final String title;

  final String description;

  final String icon;

  final IconData iconData;


  // Rewards
  final int rewardXP;

  final int rewardCoins;

  final int rewardStars;


  // Status
  final bool unlocked;

  final String category;

  final bool completed;



  GameItem({


    required this.id,


    required this.title,


    required this.description,


    required this.icon,


    required this.iconData,


    required this.rewardXP,


    this.rewardCoins = 5,


    this.rewardStars = 1,


    this.unlocked = true,


    this.category = "General",


    this.completed = false,


  });


}