import 'package:flutter/material.dart';


class LessonCategory {


final String title;

final String subtitle;

final String emoji;

final Color color;


final List<Widget> Function(BuildContext context) pages;



LessonCategory({

required this.title,

required this.subtitle,

required this.emoji,

required this.color,

required this.pages,

});


}