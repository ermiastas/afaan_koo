import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class AlphabetTracingWidget extends StatefulWidget {
  final String capitalLetter;
  final String smallLetter;
  final VoidCallback onComplete;

  const AlphabetTracingWidget({
    super.key,
    required this.capitalLetter,
    required this.smallLetter,
    required this.onComplete,
  });

  @override
  State<AlphabetTracingWidget> createState() =>
      _AlphabetTracingWidgetState();
}


class _AlphabetTracingWidgetState
    extends State<AlphabetTracingWidget> {


  List<Offset?> points = [];
  bool _completed = false;


  @override
  void didUpdateWidget(
      AlphabetTracingWidget oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);


    // Clear handwriting when alphabet changes
    if (oldWidget.capitalLetter != widget.capitalLetter ||
        oldWidget.smallLetter != widget.smallLetter) {


      setState(() {

        points.clear();
        _completed = false;

      });


    }
  }





  void clearDrawing(){

    setState(() {

      points.clear();
      _completed = false;

    });

  }





  void addPoint(
      Offset point
      ){

    setState(() {

      points.add(point);

    });

  }





  void finish(){

    if(!_completed && points.whereType<Offset>().length > 20){

      _completed = true;

      widget.onComplete();

    }

  }






  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              height: Responsive.tracingHeight(context),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.orange,
                  width: 3,
                ),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  addPoint(details.localPosition);
                },
                onPanEnd: (details) {
                  setState(() => points.add(null));
                  finish();
                },
                child: CustomPaint(
                  painter: LetterTracePainter(
                    points: points,
                    letter: widget.capitalLetter,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: clearDrawing,
              icon: const Icon(Icons.refresh),
              label: const Text("Haquu"),
            ),
            ElevatedButton.icon(
              onPressed: finish,
              icon: const Icon(Icons.check),
              label: const Text("Xumuri"),
            ),
          ],
        ),
      ],
    );
  }
}







class LetterTracePainter
    extends CustomPainter {


  final List<Offset?> points;

  final String letter;



  LetterTracePainter({

    required this.points,

    required this.letter,

  });





  @override
  void paint(
      Canvas canvas,
      Size size,
      ){



    // Draw target alphabet

    final textPainter =
    TextPainter(

      text:

      TextSpan(

        text:letter,


        style:

        TextStyle(

          fontSize:220,

          fontWeight:
          FontWeight.bold,


          color:
          Colors.orange.withValues(alpha:0.25),

        ),

      ),


      textDirection:
      TextDirection.ltr,


    );



    textPainter.layout();



    textPainter.paint(

      canvas,

      Offset(

        (size.width -
            textPainter.width)/2,

        (size.height -
            textPainter.height)/2,

      ),

    );






    // Draw child's handwriting

    final paint =
    Paint()

      ..color =
      Colors.blue

      ..strokeWidth =
      8

      ..strokeCap =
      StrokeCap.round;





    for(int i=0;i<points.length-1;i++){


      if(points[i]!=null &&
          points[i+1]!=null){


        canvas.drawLine(

          points[i]!,

          points[i+1]!,

          paint,

        );


      }


    }



  }







  @override
  bool shouldRepaint(
      covariant LetterTracePainter oldDelegate
      ){

    // The list is updated in place while tracing, so identity comparison would
    // incorrectly suppress repainting after a new stroke sample is added.
    return true;

  }



}
