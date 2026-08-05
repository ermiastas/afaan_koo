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



  Offset _scalePoint(
      Offset point,
      Size size,
      ){

    const baseSize = 400.0;


    final scale =
        size.width / baseSize;


    return Offset(
      point.dx * scale,
      point.dy * scale,
    );

  }





  @override
  void paint(
      Canvas canvas,
      Size size,
      ){


    _drawBackgroundLetter(
        canvas,
        size,
    );


    _drawStrokeGuide(
        canvas,
        size,
    );


    _drawAnimatedStroke(
        canvas,
        size,
    );


    _drawUserDrawing(
        canvas,
    );

  }







  void _drawBackgroundLetter(
      Canvas canvas,
      Size size,
      ){


    final painter =
    TextPainter(

      text:

      TextSpan(

        text: letter,

        style:

        const TextStyle(

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


    painter.layout();


    painter.paint(

      canvas,

      Offset(

        (size.width -
            painter.width)/2,

        40,

      ),

    );


  }







  void _drawStrokeGuide(
      Canvas canvas,
      Size size,
      ){


    final paint =
    Paint()

      ..color =
      Colors.orangeAccent

      ..strokeWidth =
      5

      ..style =
      PaintingStyle.stroke

      ..strokeCap =
      StrokeCap.round;



    for(final stroke in strokes){


      final path =
      Path();



      for(int i=0;
      i < stroke.points.length;
      i++){


        final point =
        _scalePoint(

          Offset(
            stroke.points[i][0],
            stroke.points[i][1],
          ),

          size,

        );



        if(i==0){

          path.moveTo(
              point.dx,
              point.dy
          );

        }

        else{

          path.lineTo(
              point.dx,
              point.dy
          );

        }


      }


      canvas.drawPath(
        path,
        paint,
      );

    }


  }







  void _drawAnimatedStroke(
      Canvas canvas,
      Size size,
      ){


    final paint =
    Paint()

      ..color =
      Colors.green

      ..strokeWidth =
      10

      ..strokeCap =
      StrokeCap.round;



    for(int i=0;
    i < animatedPoints.length-1;
    i++){


      canvas.drawLine(

        _scalePoint(
            animatedPoints[i],
            size
        ),

        _scalePoint(
            animatedPoints[i+1],
            size
        ),

        paint,

      );


    }


  }






  void _drawUserDrawing(
      Canvas canvas,
      ){


    final paint =
    Paint()

      ..color =
      Colors.blue

      ..strokeWidth =
      9

      ..strokeCap =
      StrokeCap.round;



    for(int i=0; i < userPoints.length-1; i++){
      final current = userPoints[i];
      final next = userPoints[i+1];
      // Offset.infinite is a stroke separator, never a drawable point.
      if(current == Offset.infinite || next == Offset.infinite){
        continue;
      }
      canvas.drawLine(current, next, paint);
    }


  }







  @override
  bool shouldRepaint(
      covariant HandwritingPainter oldDelegate,
      ){

    return true;

  }


}
