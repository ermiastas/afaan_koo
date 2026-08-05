import 'package:flutter/material.dart';


class ColoringStateService {


final Map<String,Color> _colors = {};



void updateColor(

String id,

Color color,

){

_colors[id] = color;

}



Color getColor(String id){

return _colors[id]
?? Colors.white;

}



Map<String,Color> get savedColors =>
_colors;



void clear(){

_colors.clear();

}



}