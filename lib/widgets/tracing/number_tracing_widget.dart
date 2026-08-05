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
  State<NumberTracingWidget> createState()
      => _NumberTracingWidgetState();


}






class _NumberTracingWidgetState
    extends State<NumberTracingWidget>
    with SingleTickerProviderStateMixin {



  final List<Offset> userPoints = [];


  List<Offset> currentStroke = [];



  double accuracy = 0;


  bool completed = false;



  late AnimationController animation;



  @override
  void initState(){


    super.initState();


    animation =
        AnimationController(

          vsync:this,

          duration:
          const Duration(seconds:2),

        )
          ..repeat();


  }







  @override
  void dispose(){


    animation.dispose();

    super.dispose();

  }







  List<Offset> getNumberPath(){


    switch(widget.number){



      case 0:

        return [

          const Offset(.5,.1),

          const Offset(.25,.25),

          const Offset(.25,.75),

          const Offset(.5,.9),

          const Offset(.75,.75),

          const Offset(.75,.25),

          const Offset(.5,.1),

        ];




      case 1:

        return [

          const Offset(.4,.25),

          const Offset(.55,.1),

          const Offset(.55,.9),

        ];




      case 2:

        return [

          const Offset(.25,.25),

          const Offset(.5,.1),

          const Offset(.75,.25),

          const Offset(.25,.9),

          const Offset(.75,.9),

        ];




      case 3:

        return [

          const Offset(.3,.2),

          const Offset(.7,.25),

          const Offset(.35,.5),

          const Offset(.7,.75),

          const Offset(.3,.9),

        ];




      case 4:

        return [

          const Offset(.7,.9),

          const Offset(.7,.1),

          const Offset(.25,.6),

          const Offset(.8,.6),

        ];




      case 5:

        return [

          const Offset(.7,.1),

          const Offset(.3,.1),

          const Offset(.3,.5),

          const Offset(.7,.5),

          const Offset(.7,.9),

          const Offset(.3,.9),

        ];




      case 6:

        return [

          const Offset(.7,.2),

          const Offset(.35,.5),

          const Offset(.3,.8),

          const Offset(.6,.9),

          const Offset(.75,.7),

          const Offset(.5,.5),

          const Offset(.3,.6),

        ];




      case 7:

        return [

          const Offset(.25,.1),

          const Offset(.75,.1),

          const Offset(.35,.9),

        ];




      case 8:

        return [

          const Offset(.5,.1),

          const Offset(.25,.3),

          const Offset(.5,.5),

          const Offset(.25,.7),

          const Offset(.5,.9),

          const Offset(.75,.7),

          const Offset(.5,.5),

          const Offset(.75,.3),

          const Offset(.5,.1),

        ];




      case 9:

        return [

          const Offset(.7,.7),

          const Offset(.7,.25),

          const Offset(.5,.1),

          const Offset(.25,.3),

          const Offset(.5,.5),

          const Offset(.7,.5),

        ];




      default:

        return [];

    }

  }








  void startStroke(
      DragStartDetails details,
      Size size
      ){


    setState((){


      currentStroke=[

        normalize(

          details.localPosition,

          size,

        )

      ];


    });


  }







  void updateStroke(
      DragUpdateDetails details,
      Size size
      ){


    setState((){


      currentStroke.add(

        normalize(

          details.localPosition,

          size,

        ),

      );


    });


  }







  void endStroke(){



    final score =
    calculateAccuracy(

      currentStroke,

      getNumberPath(),

    );




    setState((){


      accuracy=score;




      if(score >= .70){



        userPoints.addAll(
            currentStroke
        );



        completed=true;


        giveReward();



      }


      else{


        currentStroke=[];


      }



    });



  }








  double calculateAccuracy(

      List<Offset> user,

      List<Offset> target

      ){


    if(user.isEmpty) {
      return 0;
    }



    double error=0;



    for(final p in user){


      error += target.map(

              (t)=>

              (t-p).distance

      )
          .reduce(min);


    }



    error/=user.length;



    return max(

      0,

      1-(error*3),

    );


  }







  Offset normalize(

      Offset position,

      Size size

      ){


    return Offset(

      position.dx / size.width,

      position.dy / size.height,

    );


  }







  void giveReward(){



    RajiAudioService.reward();


    widget.onComplete?.call();



    String medal;



    if(accuracy>=.95){

      medal="🥇 Gold";

    }

    else if(accuracy>=.85){

      medal="🥈 Silver";

    }

    else{

      medal="🥉 Bronze";

    }





    if (!mounted) return;

    showDialog(

      context:context,

      builder:(context){

        return AlertDialog(

          title:

          const Text(
              "🎉 Raajii"
          ),


          content:

          Text(

            "Baay'ee gaarii!\n\n"

                "Lakkoofsa ${widget.number} xumurte.\n\n"

                "Medal: $medal\n"

                "⭐ Urjii argatte",

          ),

        );

      },

    );



  }








  void reset(){


    setState((){


      userPoints.clear();

      currentStroke=[];

      accuracy=0;

      completed=false;


    });


  }








  @override
  Widget build(BuildContext context){



    return Column(

      children:[



        Text(

          "${widget.number}",

          style:

          const TextStyle(

            fontSize:70,

            fontWeight:
            FontWeight.bold,

          ),

        ),



        Text(

          completed

              ?

          "🎉 Xumurte!"

              :

          "Lakkoofsa hordofi ✍️",

          style:

          const TextStyle(

            fontSize:20,

            fontWeight:
            FontWeight.bold,

          ),

        ),






        const SizedBox(height:20),




        Center(

          child: ConstrainedBox(

            constraints: const BoxConstraints(maxWidth: 500),

            child: SizedBox(

          height: Responsive.tracingHeight(context),

          width:double.infinity,



          child:

          LayoutBuilder(

            builder:(context,constraints){



              final size =
              Size(

                constraints.maxWidth,

                constraints.maxHeight,

              );



              return GestureDetector(


                onPanStart:(d)=>

                    startStroke(d,size),


                onPanUpdate:(d)=>

                    updateStroke(d,size),


                onPanEnd:(d)=>

                    endStroke(),



                child:

                CustomPaint(

                  size:size,


                  painter:

                  NumberPainter(

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

        ),





        const SizedBox(height:15),




        Text(

          "Sirrii: ${(accuracy*100).round()}%",

          style:

          const TextStyle(

            fontSize:18,

          ),

        ),





        ElevatedButton.icon(

          onPressed:reset,

          icon:

          const Icon(
              Icons.refresh
          ),

          label:

          const Text(
              "Yaali irra deebi'i"
          ),

        )


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
      Size size
      ){



    final paint =
    Paint()

      ..strokeWidth=6

      ..strokeCap=
      StrokeCap.round;



    paint.color=Colors.grey;



    for(int i=0;i<guide.length-1;i++){



      canvas.drawLine(

        Offset(

          guide[i].dx*size.width,

          guide[i].dy*size.height,

        ),


        Offset(

          guide[i+1].dx*size.width,

          guide[i+1].dy*size.height,

        ),


        paint,

      );

    }





    paint.color=Colors.blue;



    drawStroke(
      canvas,
      user,
      size,
      paint,
    );



    drawStroke(
      canvas,
      current,
      size,
      paint,
    );



  }







  void drawStroke(

      Canvas canvas,

      List<Offset> points,

      Size size,

      Paint paint

      ){



    for(int i=0;i<points.length-1;i++){


      canvas.drawLine(

        Offset(

          points[i].dx*size.width,

          points[i].dy*size.height,

        ),


        Offset(

          points[i+1].dx*size.width,

          points[i+1].dy*size.height,

        ),


        paint,

      );


    }


  }







  @override
  bool shouldRepaint(
      covariant NumberPainter oldDelegate
      ){

    return true;

  }


}
