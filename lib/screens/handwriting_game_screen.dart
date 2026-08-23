import 'package:flutter/material.dart';

import '../data/handwriting_data.dart';
import '../models/handwriting_item.dart';

import '../widgets/handwriting_canvas.dart';
import '../widgets/handwriting_progress.dart';
import '../widgets/handwriting_toolbar.dart';
import '../widgets/handwriting_success.dart';
import '../widgets/handwriting_navigation.dart';
import '../utils/responsive.dart';



class HandwritingGameScreen extends StatefulWidget {


  final String category;



  const HandwritingGameScreen({

    super.key,

    required this.category,

  });



  @override
  State<HandwritingGameScreen> createState()
      => _HandwritingGameScreenState();

}







class _HandwritingGameScreenState
extends State<HandwritingGameScreen> {



int index = 0;


bool completed = false;



late List<HandwritingItem> lessons;


final GlobalKey<HandwritingCanvasState>
canvasKey =
GlobalKey<HandwritingCanvasState>();



@override
void initState(){

  super.initState();


  lessons =
      handwritingData
      .where(
        (item)=>
        item.category ==
            widget.category,
      )
      .toList();


}







HandwritingItem get currentItem =>
    lessons[index];






void previous() {
  if (index > 0) {
    setState(() {
      index--;
      completed = false;
    });
  }
}

void next() {
  if (index < lessons.length - 1) {
    setState(() {
      index++;
      completed = false;
    });
  } else {
    _showFinishedDialog();
  }
}






void _showFinishedDialog(){


showDialog(

context:context,

builder:(ctx)=>AlertDialog(

title:
const Text(
"🎉 Xumura",
),


content:
Text(
"${widget.category} barnoota xumurte!",
),


actions:[


TextButton(

onPressed:(){

Navigator.pop(ctx);

setState((){

index=0;

completed=false;

});

},

child:
const Text(
"Deebisi",
),

),



TextButton(

onPressed:(){

Navigator.pop(ctx);

Navigator.pop(context);

},

child:
const Text(
"Cufi",
),

),



],


),


);


}









@override
Widget build(BuildContext context){



if(lessons.isEmpty){


return Scaffold(

body:
Center(

child:
Text(
"Barnoonni kun hin jiru",
),

),

);


}






final item=currentItem;






return Scaffold(

appBar:

AppBar(

title:

Text(
"✍️ ${widget.category}",
),

centerTitle:true,

),




body:

SafeArea(

child:

LayoutBuilder(
  builder: (context, constraints) => SingleChildScrollView(
    padding: EdgeInsets.only(bottom: Responsive.pagePadding(context)),
    child: Column(

children:[






HandwritingProgress(

current:index+1,
total:lessons.length,

),











SizedBox(
  height: (constraints.maxHeight * .42).clamp(220.0, 360.0).toDouble(),
  child: HandwritingCanvas(
    key: canvasKey,
    target: item.character,
    strokes: item.strokes,
    onComplete: () {
      setState(() {
        completed = true;
      });
    },
  ),
),


/*
HandwritingLetterHeader(

uppercase:item.character,

lowercase:item.lowercase,

name:item.name,

sound:item.sound,

category:item.category,

),
*/




HandwritingNavigation(

canGoBack:index>0,

canGoNext:completed,

isLast:index ==
lessons.length-1,

onBack:previous,

onNext:next,

),


HandwritingToolbar(

onReplay:(){

  canvasKey.currentState
      ?.replay();

},


onUndo:(){

  canvasKey.currentState?.undo();

},


onClear:(){

  canvasKey.currentState
      ?.clear();

},


),






HandwritingSuccess(

visible:completed,

),










],


),
  ),
),
  ),


);


}


}
