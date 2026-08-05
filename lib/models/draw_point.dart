import 'package:flutter/material.dart';

import 'brush_type.dart';
import 'paint_mode.dart';



class DrawingPoint {


  final Offset offset;


  final Paint paint;


  /// Existing brush system
  final BrushType brushType;


  /// New paint tool system
  final PaintMode mode;


  /// Sticker support
  final String? sticker;


  /// Optional text support
  final String? text;



  DrawingPoint({

    required this.offset,

    required this.paint,


    this.brushType =
        BrushType.normal,


    this.mode =
        PaintMode.brush,


    this.sticker,


    this.text,

  });


}