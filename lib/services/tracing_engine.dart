import 'package:flutter/material.dart';

import '../models/handwriting_stroke.dart';



class TracingEngine {



  static double calculateAccuracy(

    List<Offset> userPoints,

    List<HandwritingStroke> strokes,

  ){

    if(userPoints.isEmpty){

      return 0;

    }



    int matched = 0;

    int total = 0;



    for(final stroke in strokes){


      for(final point in stroke.points){


        total++;


        final targetPoint = Offset(

          point[0],

          point[1],

        );



        bool found = userPoints.any(

          (userPoint){


            if(userPoint == Offset.infinite){

              return false;

            }



            double distance =

                (userPoint - targetPoint)
                    .distance;



            return distance < 35;

          },

        );



        if(found){

          matched++;

        }



      }

    }



    if(total == 0){

      return 0;

    }



    return matched / total;


  }



}