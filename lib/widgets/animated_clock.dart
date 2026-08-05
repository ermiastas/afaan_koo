import 'dart:math';

import 'package:flutter/material.dart';



class AnimatedClock extends StatelessWidget {


final int hour;

final int minute;



const AnimatedClock({

super.key,

required this.hour,

required this.minute,

});




@override
Widget build(BuildContext context){



return CustomPaint(



size:

const Size(220,220),



painter:

ClockPainter(

hour,

minute,

),



);



}



}







class ClockPainter extends CustomPainter {



final int hour;

final int minute;



ClockPainter(

this.hour,

this.minute,

);




@override

void paint(Canvas canvas, Size size){



final center =
Offset(

size.width/2,

size.height/2,

);



final radius =
size.width/2;



final paint = Paint()

..style =
PaintingStyle.stroke

..strokeWidth=5;



canvas.drawCircle(

center,

radius,

paint,

);






final textPainter = TextPainter(

textDirection:

TextDirection.ltr,

);





for(int i=1;i<=12;i++){



final angle =
(i*30)*pi/180;



final x =
center.dx +

cos(angle-pi/2)*

(radius-35);



final y =
center.dy +

sin(angle-pi/2)*

(radius-35);



textPainter.text=

TextSpan(

text:"$i",

style:

const TextStyle(

fontSize:18,

color:Colors.black,

),

);



textPainter.layout();



textPainter.paint(

canvas,

Offset(

x-8,

y-10,

),

);



}






final hourAngle =

(hour%12 +

minute/60)*

30*pi/180;



final minuteAngle =

minute*

6*pi/180;







Paint hand = Paint()

..strokeWidth=6

..strokeCap=

StrokeCap.round;



canvas.drawLine(

center,

Offset(

center.dx+

sin(hourAngle)*50,

center.dy-

cos(hourAngle)*50,

),

hand,

);






canvas.drawLine(

center,

Offset(

center.dx+

sin(minuteAngle)*75,

center.dy-

cos(minuteAngle)*75,

),

hand,

);



}



@override

bool shouldRepaint(

ClockPainter old

){

return true;

}



}