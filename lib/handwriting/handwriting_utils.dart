import 'dart:math';
import 'package:flutter/material.dart';

class HandwritingUtils {


  static double distance(
    Offset a,
    Offset b,
  ) {

    final dx = a.dx - b.dx;
    final dy = a.dy - b.dy;

    return sqrt(
      dx * dx + dy * dy,
    );

  }





  static Offset toOffset(
    List<double> point,
  ) {

    return Offset(
      point[0],
      point[1],
    );

  }





  static Offset lerp(
    Offset a,
    Offset b,
    double t,
  ) {

    return Offset(

      a.dx + (b.dx - a.dx) * t,

      a.dy + (b.dy - a.dy) * t,

    );

  }


}