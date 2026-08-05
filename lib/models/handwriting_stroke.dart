class HandwritingStroke {

  /// The order this stroke should be written
  final int order;


  /// Points that make up this stroke
  /// Example:
  /// [
  ///   [100,200],
  ///   [120,180],
  ///   [150,100]
  /// ]
  final List<List<double>> points;


  /// Writing direction
  /// Examples:
  /// "down"
  /// "up"
  /// "left_to_right"
  /// "right_to_left"
  final String direction;



  const HandwritingStroke({

    required this.order,

    required this.points,

    required this.direction,

  });




  /// Create stroke from JSON
  factory HandwritingStroke.fromJson(
      Map<String, dynamic> json,
      ) {

    return HandwritingStroke(

      order:
      json['order'] ?? 0,


      points:

      (json['points'] as List)

          .map(

            (point) =>

            List<double>.from(point),

      )

          .toList(),


      direction:

      json['direction'] ?? "unknown",

    );

  }




  /// Convert stroke to JSON
  Map<String, dynamic> toJson() {

    return {

      "order": order,

      "points": points,

      "direction": direction,

    };

  }




  /// Number of points in this stroke
  int get pointCount {

    return points.length;

  }




  /// First point of stroke
  List<double>? get startPoint {

    if(points.isEmpty){

      return null;

    }

    return points.first;

  }




  /// Last point of stroke
  List<double>? get endPoint {

    if(points.isEmpty){

      return null;

    }

    return points.last;

  }


}