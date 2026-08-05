import 'tracing_point.dart';


class LetterTracingPath {


  final String letter;


  final List<TracingStroke> strokes;



  LetterTracingPath({

    required this.letter,

    required this.strokes,

  });



}




class TracingStroke {


  final int order;


  final List<TracingPoint> points;



  TracingStroke({

    required this.order,

    required this.points,

  });



}