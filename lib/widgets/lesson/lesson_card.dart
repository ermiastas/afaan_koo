import 'package:flutter/material.dart';

import '../../models/lesson.dart';

import '../animations/floating_bubbles.dart';
import '../animations/completion_glow.dart';
import '../animations/achievement_badge.dart';
import '../animations/sparkle_effect.dart';
import '../animations/bounce_tap.dart';

import 'category_gradient.dart';



class LessonCard extends StatelessWidget {


final Lesson lesson;

final VoidCallback onTap;


const LessonCard({

super.key,

required this.lesson,

required this.onTap,

});



@override
Widget build(BuildContext context){


return BounceTap(

onTap:onTap,


child:

CompletionGlow(

completed:lesson.completed,


child:

Container(

margin:
const EdgeInsets.all(12),


height:220,


decoration:BoxDecoration(

borderRadius:
BorderRadius.circular(28),


gradient:

CategoryGradient.get(
lesson.category
),


boxShadow:[

BoxShadow(

blurRadius:15,

color:
Colors.black.withValues(alpha: 0.15),

offset:
const Offset(0,8),

)

],


),



child:

ClipRRect(

borderRadius:
BorderRadius.circular(28),


child:

Stack(

children:[


FloatingBubblesBackground(

child:
const SizedBox.expand(),

),



Padding(

padding:
const EdgeInsets.all(18),


child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Row(

children:[


Expanded(

child:

Text(

lesson.title,

style:
const TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

color:
Colors.white,

),

),

),



AchievementBadge(

unlocked:
lesson.completed,

)

],

),



const Spacer(),



// Raji assistant

Row(

children:[


CircleAvatar(

radius:28,


backgroundColor:
Colors.white,


child:

Text(
"🤖",
style:
TextStyle(
fontSize:32,
),

),

),


const SizedBox(width:10),


Expanded(

child:

Text(

lesson.rajiMessage,


style:

const TextStyle(

color:
Colors.white,

fontSize:14,

),

),

)

],

),



const SizedBox(height:12),



LinearProgressIndicator(

value:
lesson.progress,


backgroundColor:
Colors.white30,


color:
Colors.white,


minHeight:8,


borderRadius:
BorderRadius.circular(10),

),



const SizedBox(height:8),



Text(

"${(lesson.progress*100).toInt()}% Complete",

style:

const TextStyle(

color:Colors.white,

fontWeight:
FontWeight.bold,

),

),


],


),

),



if(lesson.completed)

const Positioned(

right:30,

top:80,

child:

SparkleEffect(
show:true,
),

),


],

),

),

),

),

);


}

}