import 'package:flutter/material.dart';

import '../../models/coloring_page.dart';
import '../../models/drawing_point.dart';
import '../../models/paint_mode.dart';

import '../../widgets/paint/drawing_canvas.dart';
import '../../widgets/paint/paint_toolbar.dart';


class ColoringCanvasScreen extends StatefulWidget {

  final ColoringPage page;


  const ColoringCanvasScreen({

    super.key,

    required this.page,

  });


  @override
  State<ColoringCanvasScreen> createState() =>
      _ColoringCanvasScreenState();

}



class _ColoringCanvasScreenState
    extends State<ColoringCanvasScreen> {


  final List<DrawingPoint?> points = [];

  final List<DrawingPoint?> redoPoints = [];


  Color selectedColor = Colors.red;

  bool bucketMode = false;

  double brushSize = 10;

  double completion = 0;

  PaintMode selectedMode =
      PaintMode.brush;



  final List<Color> colors = [

    Colors.red,

    Colors.orange,

    Colors.yellow,

    Colors.green,

    Colors.blue,

    Colors.purple,

    Colors.pink,

    Colors.brown,

    Colors.black,

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
          const Color(0xffEAF7FF),


      appBar: AppBar(

        title: Text(

          "${widget.page.emoji} ${widget.page.titleOromo}",

        ),

        centerTitle:true,

      ),



      body: Column(

        children:[



          Expanded(

            child: Container(

              margin:
              const EdgeInsets.all(16),


              decoration:BoxDecoration(

                color:Colors.white,


                borderRadius:
                BorderRadius.circular(25),


              ),



              child:
           

           Stack(

  alignment: Alignment.center,

  children:[


    // ==========================
    // Coloring picture
    // ==========================

    Positioned.fill(

      child: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Image.asset(

          widget.page.image,

          fit: BoxFit.contain,

        ),

      ),

    ),



    // ==========================
    // Drawing layer
    // ==========================

    Positioned.fill(

      child: GestureDetector(

        onPanStart:(details){

          _addPoint(
            details.localPosition
          );

        },


        onPanUpdate:(details){

          _addPoint(
            details.localPosition
          );

        },


        onPanEnd:(_){

          setState((){

            points.add(null);

          });

        },

        onTapDown:(details){

          if(bucketMode){

            _fillColor( details.localPosition);

 }

},

        child: CustomPaint(

          painter: DrawingCanvas(

            points:points,

          ),

        ),

      ),

    ),


  ],

)

            ),

          ),



          SizedBox(

            height:60,

            child:ListView.builder(

              scrollDirection:
              Axis.horizontal,


              itemCount:
              colors.length,


              itemBuilder:(context,index){


                return GestureDetector(

                  onTap:(){

                    setState((){

                      selectedColor =
                          colors[index];

                    });

                  },


                  child:Container(

                    margin:
                    const EdgeInsets.all(8),


                    width:45,

                    decoration:BoxDecoration(

                      color:
                      colors[index],

                      shape:
                      BoxShape.circle,

                      border:Border.all(

                        color:Colors.white,

                        width:3,

                      ),

                    ),

                  ),

                );

              },

            ),

          ),



          PaintToolbar(

            selectedMode:selectedMode,


            brushSize:brushSize,


            onBrushChanged:(value){

              setState((){

                brushSize=value;

              });

            },


            onModeChanged:(mode){

              setState((){

                selectedMode=mode;

                bucketMode = 
                  mode == PaintMode.bucket;

              });

            },


            onUndo:(){

              if(points.isNotEmpty){

                setState((){

                  redoPoints
                      .add(points.removeLast());

                });

              }

            },


            onRedo:(){

              if(redoPoints.isNotEmpty){

                setState((){

                  points
                      .add(redoPoints.removeLast());

                });

              }

            },


            onClear:(){

              setState((){

                points.clear();

              });

            },


            onSave:(){

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                const SnackBar(

                  content:

                  Text(
                    "🎉 Suuraan kuufame!"
                  ),

                ),

              );

            },


            onGallery:(){},

          ),

        

        ],

      ),

    );

  }




  void _addPoint(Offset position){


    final paint = Paint()

      ..color = selectedColor

      ..strokeWidth = brushSize

      ..strokeCap =
          StrokeCap.round

      ..style =
          PaintingStyle.fill;



    points.add(

      DrawingPoint(

        offset:position,

        paint:paint,

        mode:selectedMode,

      ),

    );


    redoPoints.clear();


    setState((){});

  }

  void _fillColor(Offset position) {
    final paint = Paint()
      ..color = selectedColor
      ..style = PaintingStyle.fill
      ..strokeWidth = brushSize
      ..strokeCap = StrokeCap.round;

    setState(() {
      points.add(
        DrawingPoint(
          offset: position,
          paint: paint,
          mode: PaintMode.bucket,
        ),
      );
      redoPoints.clear();
    });
  }

}
