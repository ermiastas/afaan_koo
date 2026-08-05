import 'package:flutter/material.dart';



class LetterStroke {


final String letter;


final List<List<Offset>> strokes;



const LetterStroke({

required this.letter,

required this.strokes,

});

}



final Map<String,LetterStroke> alphabetStrokeMap = {



"A":

LetterStroke(

letter:"A",

strokes:[


[

Offset(120,250),

Offset(200,50),

Offset(280,250),

],



[

Offset(150,170),

Offset(250,170),

],


],

),






"a":

LetterStroke(

letter:"a",

strokes:[


[

Offset(230,120),

Offset(150,120),

Offset(120,180),

Offset(150,240),

Offset(230,230),

Offset(230,120),

],



[

Offset(230,120),

Offset(230,250),

],


],

),







"B":

LetterStroke(

letter:"B",

strokes:[



[

Offset(120,50),

Offset(120,260),

],



[

Offset(120,60),

Offset(240,90),

Offset(120,150),

],



[

Offset(120,150),

Offset(250,200),

Offset(120,250),

],



],

),






"Ch":

LetterStroke(

letter:"Ch",

strokes:[



[

Offset(220,70),

Offset(150,50),

Offset(90,120),

Offset(90,200),

Offset(150,250),

Offset(220,230),

],



[

Offset(250,50),

Offset(250,250),

],


],

),





"Dh":

LetterStroke(

letter:"Dh",

strokes:[


[

Offset(120,50),

Offset(120,250),

],


[

Offset(120,60),

Offset(220,100),

Offset(220,200),

Offset(120,250),

],


[

Offset(250,80),

Offset(250,220),

],


],

),






"Ny":

LetterStroke(

letter:"Ny",

strokes:[


[

Offset(100,250),

Offset(100,80),

Offset(200,180),

Offset(280,80),

Offset(280,250),

],


[

Offset(120,150),

Offset(260,150),

],


],

),






"Ph":

LetterStroke(

letter:"Ph",

strokes:[


[

Offset(120,50),

Offset(120,250),

],


[

Offset(120,70),

Offset(230,100),

Offset(120,160),

],


[

Offset(250,80),

Offset(250,230),

],


],

),





"Sh":

LetterStroke(

letter:"Sh",

strokes:[


[

Offset(100,80),

Offset(100,220),

],


[

Offset(100,100),

Offset(220,100),

Offset(220,220),

Offset(100,220),

],


[

Offset(250,80),

Offset(250,230),

],


],

),




};