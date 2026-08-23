import 'dart:math';

import 'package:flutter/material.dart';

import '../../services/raji_audio_service.dart';
import '../../utils/responsive.dart';

class NumberTracingWidget extends StatefulWidget {
  final int number;
  final VoidCallback? onComplete;

  const NumberTracingWidget({
    super.key,
    required this.number,
    this.onComplete,
  });

  @override
  State<NumberTracingWidget> createState() =>
      _NumberTracingWidgetState();
}

class _NumberTracingWidgetState extends State<NumberTracingWidget> {
  final List<Offset> userPoints = [];

  List<Offset> currentStroke = [];

  double accuracy = 0;

  bool completed = false;


  @override
  void didUpdateWidget(
      covariant NumberTracingWidget oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.number != widget.number) {
      reset();
    }
  }


  List<Offset> getNumberPath() {
    switch (widget.number) {
      case 0:
        return const [
          Offset(.5, .1),
          Offset(.25, .25),
          Offset(.25, .75),
          Offset(.5, .9),
          Offset(.75, .75),
          Offset(.75, .25),
          Offset(.5, .1),
        ];


      case 1:
        return const [
          Offset(.4, .25),
          Offset(.55, .1),
          Offset(.55, .9),
        ];


      case 2:
        return const [
          Offset(.25, .25),
          Offset(.5, .1),
          Offset(.75, .25),
          Offset(.25, .9),
          Offset(.75, .9),
        ];


      case 3:
        return const [
          Offset(.3, .2),
          Offset(.7, .25),
          Offset(.35, .5),
          Offset(.7, .75),
          Offset(.3, .9),
        ];


      case 4:
        return const [
          Offset(.7, .9),
          Offset(.7, .1),
          Offset(.25, .6),
          Offset(.8, .6),
        ];


      case 5:
        return const [
          Offset(.7, .1),
          Offset(.3, .1),
          Offset(.3, .5),
          Offset(.7, .5),
          Offset(.7, .9),
          Offset(.3, .9),
        ];


      case 6:
        return const [
          Offset(.7, .2),
          Offset(.35, .5),
          Offset(.3, .8),
          Offset(.6, .9),
          Offset(.75, .7),
          Offset(.5, .5),
          Offset(.3, .6),
        ];


      case 7:
        return const [
          Offset(.25, .1),
          Offset(.75, .1),
          Offset(.35, .9),
        ];


      case 8:
        return const [
          Offset(.5, .1),
          Offset(.25, .3),
          Offset(.5, .5),
          Offset(.25, .7),
          Offset(.5, .9),
          Offset(.75, .7),
          Offset(.5, .5),
          Offset(.75, .3),
          Offset(.5, .1),
        ];


      case 9:
        return const [
          Offset(.7, .7),
          Offset(.7, .25),
          Offset(.5, .1),
          Offset(.25, .3),
          Offset(.5, .5),
          Offset(.7, .5),
        ];


      default:
        return [];
    }
  }


  void startStroke(
      DragStartDetails details,
      Size size,
      ) {
    setState(() {
      currentStroke = [
        normalize(
          details.localPosition,
          size,
        ),
      ];
    });
  }


  void updateStroke(
      DragUpdateDetails details,
      Size size,
      ) {
    setState(() {
      currentStroke.add(
        normalize(
          details.localPosition,
          size,
        ),
      );
    });
  }


  void endStroke() {
    if (currentStroke.isEmpty) {
      return;
    }

    final score = calculateAccuracy(
      currentStroke,
      getNumberPath(),
    );


    setState(() {
      accuracy = score;


      if (score >= .70) {
        userPoints.addAll(currentStroke);

        completed = true;
      } else {
        currentStroke = [];
      }
    });


    if (completed) {
      giveReward();
    }
  }


  double calculateAccuracy(
      List<Offset> user,
      List<Offset> target,
      ) {
    if (user.isEmpty || target.isEmpty) {
      return 0;
    }


    double error = 0;


    for (final point in user) {
      error += target
          .map(
            (targetPoint) =>
            (targetPoint - point).distance,
      )
          .reduce(min);
    }


    error /= user.length;


    return max(
      0,
      1 - (error * 3),
    );
  }


  Offset normalize(
      Offset position,
      Size size,
      ) {
    return Offset(
      position.dx / size.width,
      position.dy / size.height,
    );
  }
  void giveReward() {
    RajiAudioService.reward();

    widget.onComplete?.call();


    String medal;

    if (accuracy >= .95) {
      medal = "🥇 Gold";
    } else if (accuracy >= .85) {
      medal = "🥈 Silver";
    } else {
      medal = "🥉 Bronze";
    }


    if (!mounted) return;


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "🎉 Raajii",
          ),

          content: Text(
            "Baay'ee gaarii!\n\n"
            "Lakkoofsa ${widget.number} xumurte.\n\n"
            "Medal: $medal\n"
            "⭐ Urjii argatte",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Tole",
              ),
            ),
          ],
        );
      },
    );
  }



  void reset() {
    setState(() {
      userPoints.clear();

      currentStroke = [];

      accuracy = 0;

      completed = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          "${widget.number}",
          style: const TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
          ),
        ),


        Text(
          completed
              ? "🎉 Xumurte!"
              : "Lakkoofsa hordofi ✍️",

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),


        const SizedBox(height: 20),



        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),

            child: Container(
              height: Responsive.tracingHeight(context),

              width: double.infinity,

              clipBehavior: Clip.hardEdge,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(25),

                border: Border.all(
                  color: Colors.orange,
                  width: 3,
                ),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(alpha: .1),

                    blurRadius: 8,

                    offset:
                    const Offset(0, 4),
                  ),
                ],
              ),


              child: LayoutBuilder(
                builder:
                    (context, constraints) {

                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );


                  return GestureDetector(

                    onPanStart: (details) {
                      startStroke(
                        details,
                        size,
                      );
                    },


                    onPanUpdate: (details) {
                      updateStroke(
                        details,
                        size,
                      );
                    },


                    onPanEnd: (_) {
                      endStroke();
                    },


                    child: CustomPaint(
                      size: size,

                      painter: NumberPainter(
                        getNumberPath(),

                        userPoints,

                        currentStroke,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),



        const SizedBox(height: 15),



        Text(
          "Sirrii: ${(accuracy * 100).round()}%",

          style: const TextStyle(
            fontSize: 18,
          ),
        ),



        const SizedBox(height: 10),



        ElevatedButton.icon(
          onPressed: reset,

          icon: const Icon(
            Icons.refresh,
          ),

          label: const Text(
            "Yaali irra deebi'i",
          ),
        ),

      ],
    );
  }
}
class NumberPainter extends CustomPainter {
  final List<Offset> guide;

  final List<Offset> user;

  final List<Offset> current;


  NumberPainter(
    this.guide,
    this.user,
    this.current,
  );


  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {

    // Guide line
    final guidePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;


    drawStroke(
      canvas,
      guide,
      size,
      guidePaint,
    );


    // User completed stroke
    final userPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;


    drawStroke(
      canvas,
      user,
      size,
      userPaint,
    );


    // Current finger stroke
    drawStroke(
      canvas,
      current,
      size,
      userPaint,
    );
  }



  void drawStroke(
    Canvas canvas,

    List<Offset> points,

    Size size,

    Paint paint,
  ) {

    if (points.length < 2) {
      return;
    }


    for (int i = 0; i < points.length - 1; i++) {

      final start = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );


      final end = Offset(
        points[i + 1].dx * size.width,
        points[i + 1].dy * size.height,
      );


      canvas.drawLine(
        start,
        end,
        paint,
      );
    }
  }



  @override
  bool shouldRepaint(
    covariant NumberPainter oldDelegate,
  ) {

    return oldDelegate.guide != guide ||
        oldDelegate.user.length != user.length ||
        oldDelegate.current.length != current.length;
  }
}
