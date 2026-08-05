import 'package:flutter/material.dart';


class SvgPart {


  final String id;


  final String pathData;


  Color color;



  SvgPart({

    required this.id,

    required this.pathData,

    this.color = Colors.white,

  });


}