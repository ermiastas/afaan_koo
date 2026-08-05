import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/svg_part.dart';
import '../../services/coloring_progress_service.dart';
import '../../services/svg_color_engine.dart';
import '../../services/svg_parser_service.dart';
import '../../services/coloring_state_service.dart';



class InteractiveSvgColoring extends StatefulWidget {


  final String svgAsset;


  final Color selectedColor;


  final ColoringStateService service;

  final int pageReward;

  final int pageId;


  const InteractiveSvgColoring({

    super.key,

    required this.svgAsset,

    required this.selectedColor,

    required this.service,

    required this.pageReward,

    required this.pageId,

  });



  @override
  State<InteractiveSvgColoring> createState() =>
      _InteractiveSvgColoringState();

}





class _InteractiveSvgColoringState
    extends State<InteractiveSvgColoring> {


  final SvgParserService parser =
      SvgParserService();


  int coloredParts = 0;

  int totalParts = 0;

  List<SvgPart> parts = [];

  Map<String, Color> partColors = {};

  final SvgColorEngine colorEngine =

    SvgColorEngine();

  
final ColoringProgressService progressService =
    ColoringProgressService();

String? currentSvg;

  bool loading = true;



  @override
  void initState(){

    super.initState();

    _loadSvg();

  }


Future<void> _loadSvg() async {


final svg =
await DefaultAssetBundle.of(context)
.loadString(widget.svgAsset);



setState((){

currentSvg = svg;

loading=false;

});

final savedColors =
    await progressService.loadColoring(

      widget.pageId.toString(),

    );


setState((){

partColors = savedColors;

});


}




  @override
  Widget build(BuildContext context){


    if(loading){

      return const Center(

        child:CircularProgressIndicator(),

      );

    }



    return InteractiveViewer(


      minScale:1,


      maxScale:5,


      child:

      Stack(

        alignment:
        Alignment.center,


        children:[



          // Original SVG image


        SvgPicture.string(

          currentSvg ?? "",

          fit: BoxFit.contain,

        ),


          // Tap layer

          ...parts.map((part){


            return Positioned.fill(


              child:

              GestureDetector(

                onTap:(){


Future<void> colorPart(String id) async {


final alreadyColored =
    partColors.containsKey(id);



setState((){


partColors[id] =
    widget.selectedColor;



if(!alreadyColored){

  coloredParts++;

}


});



widget.service.updateColor(

id,

widget.selectedColor,

);

progressService.saveColoring(

  pageId:
      widget.pageId.toString(),


  colors:
      partColors,

);

_checkCompletion();


}

                },


                child:

                Container(

                  color:

                  Colors.transparent,

                ),

              ),


            );


          }),



        ],

      ),


    );


  }





  void _colorPart(String id){


    setState((){


      widget.service.updateColor(

        id,

        widget.selectedColor,

      );


    });


    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content:Text(

          "🎨 $id halluu argate",

        ),

      ),

    );


  }

  String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  void _checkCompletion() {
    if (coloredParts == totalParts && totalParts > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Kan-maalkaa! Haa xumaantee!'),
        ),
      );
    }
  }

  void _showRewardDialog(){


showDialog(

context:context,


builder:(context){


return AlertDialog(


shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(25),

),



title:

const Text(

"🎉 Baay'ee Bareedaa!"

),



content:

Column(

mainAxisSize:

MainAxisSize.min,


children:[


const Text(

"🤖 Raji:\n"

"Ati hojii gaarii hojjetta!"

),


const SizedBox(height:15),



Text(

"+${widget.pageReward} XP",

style:

const TextStyle(

fontSize:24,

fontWeight:

FontWeight.bold,

),

),



],


),



actions:[


TextButton(

onPressed:(){

Navigator.pop(context);

},


child:

const Text(

"Galatoomi"

),

)


],


);


},

);


}

}