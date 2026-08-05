import 'package:flutter/material.dart';


class TracingPainter extends CustomPainter{


final List<List<Offset>> strokes;

final double animation;



TracingPainter({

required this.strokes,

required this.animation,

});





@override

void paint(Canvas canvas,Size size){



final paint = Paint()

..color = Colors.blue.withValues(alpha: .5)

..strokeWidth=4;



for(final stroke in strokes){



for(int i=0;i<stroke.length-1;i++){


final start=stroke[i];

final end=stroke[i+1];



for(double t=0;t<1;t+=0.15){



final p=

Offset.lerp(start,end,t)!;



canvas.drawCircle(

p,

4,

paint,

);


}



}



}


}





@override

bool shouldRepaint(

TracingPainter oldDelegate

)=>true;



}