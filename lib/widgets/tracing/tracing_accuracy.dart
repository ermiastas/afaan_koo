import 'dart:math';

import 'tracing_point.dart';
import 'tracing_path.dart';



class TracingResult {


  final double accuracy;


  final bool correct;


  final String medal;



  const TracingResult({

    required this.accuracy,

    required this.correct,

    required this.medal,

  });

}





class TracingAccuracy {



  static TracingResult checkStroke({


    required List<TracingPoint> childStroke,


    required TracingStroke targetStroke,


  }) {



    if(childStroke.isEmpty){

      return const TracingResult(

        accuracy:0,

        correct:false,

        medal:"",

      );

    }



    double pathScore =
        calculatePathSimilarity(

          childStroke,

          targetStroke.points,

        );




    double startScore =
        calculateStartPoint(

          childStroke.first,

          targetStroke.points.first,

        );





    double endScore =
        calculateEndPoint(

          childStroke.last,

          targetStroke.points.last,

        );





    double directionScore =
        calculateDirection(

          childStroke,

          targetStroke.points,

        );





    double finalScore =

        (

          pathScore * .55

          +

          startScore * .15

          +

          endScore * .15

          +

          directionScore * .15

        );





    bool passed =

        finalScore >= .70;





    return TracingResult(

      accuracy:finalScore,

      correct:passed,

      medal:getMedal(finalScore),

    );



  }







  static double calculatePathSimilarity(


      List<TracingPoint> child,


      List<TracingPoint> target,


      ){



    double total =0;



    for(final point in child){


      double closest = target.map((t){


        return distance(

          point,

          t,

        );


      }).reduce(min);



      total += closest;


    }




    double average =

        total / child.length;




    return max(

      0,

      1-(average*3),

    );


  }









  static double calculateStartPoint(


      TracingPoint child,


      TracingPoint target,

      ){


    double d = distance(

      child,

      target,

    );



    return max(

      0,

      1-(d*5),

    );


  }









  static double calculateEndPoint(


      TracingPoint child,


      TracingPoint target,

      ){



    double d = distance(

      child,

      target,

    );


    return max(

      0,

      1-(d*5),

    );

  }









  static double calculateDirection(


      List<TracingPoint> child,


      List<TracingPoint> target,

      ){



    if(child.length < 2 ||
       target.length < 2){

      return 0;

    }



    final childDirection =

    TracingPoint(

      dx:

      child.last.dx -
      child.first.dx,


      dy:

      child.last.dy -
      child.first.dy,

    );




    final targetDirection =

    TracingPoint(

      dx:

      target.last.dx -
      target.first.dx,


      dy:

      target.last.dy -
      target.first.dy,

    );





    double dot =


        childDirection.dx *
        targetDirection.dx

        +

        childDirection.dy *
        targetDirection.dy;





    double magnitude =


        length(childDirection)

        *

        length(targetDirection);






    if(magnitude==0){

      return 0;

    }





    double similarity =

        dot/magnitude;




    return max(

      0,

      similarity,

    );



  }









  static double distance(

      TracingPoint a,

      TracingPoint b,

      ){


    return sqrt(

      pow(a.dx-b.dx,2)

      +

      pow(a.dy-b.dy,2)

    );


  }








  static double length(

      TracingPoint p

      ){


    return sqrt(

      pow(p.dx,2)

      +

      pow(p.dy,2)

    );

  }









  static String getMedal(double score){



    if(score >= .97){

      return "🥇 Gold";

    }


    if(score >= .90){

      return "🥈 Silver";

    }


    if(score >= .70){

      return "🥉 Bronze";

    }


    return "🔄 Try Again";

  }



}