import 'package:flutter/material.dart';


class SvgPartColor {

  final String id;

  final Path path;

  Color color;


  SvgPartColor({

    required this.id,

    required this.path,

    this.color = Colors.white,

  });

}