import 'package:flutter/material.dart';



class LessonCard extends StatefulWidget {


  final String title;

  final IconData icon;

  final Color color;

  final VoidCallback onTap;



  const LessonCard({

    super.key,

    required this.title,

    required this.icon,

    required this.color,

    required this.onTap,

  });



  @override
  State<LessonCard> createState()

  => _LessonCardState();


}








class _LessonCardState

extends State<LessonCard>

with SingleTickerProviderStateMixin {



late AnimationController controller;



late Animation<double> scale;



@override
void initState(){


super.initState();



controller = AnimationController(

vsync:this,

duration:

const Duration(milliseconds:150),

);



scale = Tween<double>(

begin:1,

end:0.92,

).animate(

CurvedAnimation(

parent:controller,

curve:Curves.easeInOut,

),

);



}








@override
void dispose(){


controller.dispose();

super.dispose();


}









void pressDown(){


controller.forward();


}






void pressUp(){


controller.reverse();


}









@override
Widget build(BuildContext context){



return Semantics(

button:true,

label:widget.title,

child:GestureDetector(



onTapDown:

(_){

pressDown();

},



onTapUp:

(_){

pressUp();

widget.onTap();

},



onTapCancel:

(){

pressUp();

},





child:

ScaleTransition(



scale:

scale,



child:

Container(



decoration:

BoxDecoration(



gradient:

LinearGradient(



colors:[



widget.color.withValues(alpha:0.9),

widget.color.withValues(alpha:0.5),



],



begin:

Alignment.topLeft,



end:

Alignment.bottomRight,



),




borderRadius:

BorderRadius.circular(30),





boxShadow:[



BoxShadow(



color:

Colors.black.withValues(alpha:0.15),



blurRadius:12,



offset:

const Offset(0,8),



),



],



),





child:

Padding(



padding:

const EdgeInsets.all(18),




child:

Column(



mainAxisAlignment:

MainAxisAlignment.center,



children:[





Container(



padding:

const EdgeInsets.all(15),



decoration:

BoxDecoration(



color:

Colors.white,



shape:

BoxShape.circle,



),



child:

Icon(



widget.icon,



size:

45,



color:

widget.color,



),



),





const SizedBox(height:15),





Text(



widget.title,



textAlign:

TextAlign.center,



style:

const TextStyle(



fontSize:20,



fontWeight:

FontWeight.bold,



color:

Colors.white,



),



),





],



),



),



),



),



),

); 



}


}
