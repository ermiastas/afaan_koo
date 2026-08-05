import 'package:flutter/material.dart';


class DrawingBoard extends StatefulWidget {


  final ValueChanged<List<Offset>> onChanged;


  const DrawingBoard({

    super.key,

    required this.onChanged,

  });



  @override
  State<DrawingBoard> createState()
      => _DrawingBoardState();

}






class _DrawingBoardState
extends State<DrawingBoard>{


final List<Offset> points=[];



void addPoint(Offset point){


setState((){

points.add(point);

});


widget.onChanged(
List.from(points),
);


}





void clear(){


setState((){

points.clear();

});


widget.onChanged(
points,
);


}






@override
Widget build(BuildContext context){


return GestureDetector(


onPanUpdate:(details){


addPoint(
details.localPosition,
);


},



onPanEnd:(details){


addPoint(
Offset.infinite,
);


},



child:

Container(

color:
Colors.transparent,

),



);


}



}