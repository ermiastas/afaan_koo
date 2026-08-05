import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class InteractiveSvgCanvas extends StatefulWidget {


  final String asset;


  final Color selectedColor;



  const InteractiveSvgCanvas({

    super.key,

    required this.asset,

    required this.selectedColor,

  });



  @override
  State<InteractiveSvgCanvas> createState()
      => _InteractiveSvgCanvasState();

}



class _InteractiveSvgCanvasState
    extends State<InteractiveSvgCanvas> {



  Map<String, Color> filledColors = {};



  @override
  Widget build(BuildContext context) {


    return SvgPicture.asset(

      widget.asset,

      fit: BoxFit.contain,


      colorFilter: ColorFilter.mode(

        Colors.transparent,

        BlendMode.dst,

      ),


    );


  }


}