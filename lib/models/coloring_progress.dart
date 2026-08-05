class ColoringProgress {


  final String pageId;


  final int totalParts;


  final int coloredParts;



  const ColoringProgress({

    required this.pageId,

    required this.totalParts,

    required this.coloredParts,

  });



  double get percentage {


    if(totalParts == 0){

      return 0;

    }


    return coloredParts / totalParts;

  }



  bool get completed =>

      percentage >= 1.0;


}