import 'package:flutter/material.dart';

import '../models/handwriting_stroke.dart';
import 'handwriting_utils.dart';


class TracingEngine {


  static double calculateAccuracy(

    List<Offset> drawing,

    List<HandwritingStroke> strokes,

    Size canvasSize,

  ) {


    int total = 0;

    int matched = 0;



    const baseSize = 400.0;



    final scale =
        canvasSize.width / baseSize;



    final normalizedDrawing =
        drawing
            .where(
              (p)=>p != Offset.infinite,
            )
            .map(

              (p)=>Offset(
                p.dx / scale,
                p.dy / scale,
              ),

            )
            .toList();





    for(final stroke in strokes){



      for(final point in stroke.points){



        total++;




        final target =
        HandwritingUtils.toOffset(point);




        bool found =
        normalizedDrawing.any(

              (p)=>

          HandwritingUtils.distance(
            p,
            target,
          )
              <
              25,

        );




        if(found){

          matched++;

        }



      }


    }





    if(total==0){

      return 0;

    }



    return matched / total;


  }


}