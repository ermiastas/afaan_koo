import 'package:flutter/material.dart';


class LearningTask {


  final String id;

  final String title;

  final String description;

  final String route;

  final IconData icon;

  final Color color;

  final int rewardXP;



  const LearningTask({

    required this.id,

    required this.title,

    required this.description,

    required this.route,

    required this.icon,

    required this.color,

    required this.rewardXP,

  });


}