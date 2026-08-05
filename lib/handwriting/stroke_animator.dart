import 'package:flutter/material.dart';

import '../models/handwriting_stroke.dart';


class StrokeAnimator {


  static List<Offset> build(
    List<HandwritingStroke> strokes,
    double progress,
    Size canvasSize,
  ) {


    final all = <Offset>[];


    const baseSize = 400.0;


    final scale =
        canvasSize.width / baseSize;



    for(final stroke in strokes){


      for(final p in stroke.points){


        all.add(

          Offset(

            p[0] * scale,

            p[1] * scale,

          ),

        );


      }

    }





    final visible =
        (all.length * progress)
            .round();



    return all
        .take(visible)
        .toList();


  }


}