import 'package:flutter/material.dart';

import '../models/handwriting_stroke.dart';



class HandwritingPainter extends CustomPainter {


  final String letter;

  final List<HandwritingStroke> strokes;

  final List<Offset> animatedPoints;

  final List<Offset> userPoints;



  HandwritingPainter({

    required this.letter,

    required this.strokes,

    required this.animatedPoints,

    required this.userPoints,

  });





  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {



    // White background

    final backgroundPaint = Paint()
      ..color = Colors.white;


    canvas.drawRect(
      Offset.zero & size,
      backgroundPaint,
    );





    // Scale old 300x300 coordinates
    // to current screen size

    final scaleX = size.width / 300;

    final scaleY = size.height / 300;





    canvas.save();


    canvas.scale(
      scaleX,
      scaleY,
    );




    // =========================
    // Large guide letter
    // =========================


    final textPainter = TextPainter(

      text: TextSpan(

        text: letter,

        style: const TextStyle(

          fontSize:200,

          fontWeight:
          FontWeight.bold,

          color:
          Colors.black12,

        ),

      ),


      textDirection:
      TextDirection.ltr,

    );



    textPainter.layout();



    textPainter.paint(

      canvas,

      const Offset(
        50,
        35,
      ),

    );







    // =========================
    // Stroke guide
    // =========================


    final guidePaint = Paint()

      ..color =
      Colors.blueGrey.shade300

      ..strokeWidth = 4

      ..style =
      PaintingStyle.stroke

      ..strokeCap =
      StrokeCap.round;






    for(final stroke in strokes){


      final path = Path();



      for(int i=0;
      i < stroke.points.length;
      i++){



        final point = Offset(

          stroke.points[i][0],

          stroke.points[i][1],

        );



        if(i==0){

          path.moveTo(
            point.dx,
            point.dy,
          );


        }

        else{


          path.lineTo(

            point.dx,

            point.dy,

          );


        }


      }



      canvas.drawPath(

        path,

        guidePaint,

      );


    }









    // =========================
    // Animated pencil guide
    // =========================


    final animationPaint = Paint()

      ..color =
      Colors.green

      ..strokeWidth = 8

      ..strokeCap =
      StrokeCap.round;





    for(int i=0;
    i < animatedPoints.length-1;
    i++){



      canvas.drawLine(

        animatedPoints[i],

        animatedPoints[i+1],

        animationPaint,

      );


    }









    // =========================
    // Child drawing
    // =========================


    final drawingPaint = Paint()

      ..color =
      Colors.blue

      ..strokeWidth = 8

      ..strokeCap =
      StrokeCap.round;






    for(int i=0;
    i < userPoints.length-1;
    i++){



      if(
      userPoints[i] != Offset.infinite &&
          userPoints[i+1] != Offset.infinite
      ){


        canvas.drawLine(

          userPoints[i],

          userPoints[i+1],

          drawingPaint,

        );


      }


    }




    canvas.restore();


  }







  @override
  bool shouldRepaint(
      covariant HandwritingPainter oldDelegate
      ){

    return true;

  }


}