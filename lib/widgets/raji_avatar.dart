import 'package:flutter/material.dart';



class RajiAvatar extends StatefulWidget {


  final double size;


  const RajiAvatar({

    super.key,

    this.size = 90,

  });



  @override
  State<RajiAvatar> createState()
  => _RajiAvatarState();


}





class _RajiAvatarState
extends State<RajiAvatar>
with SingleTickerProviderStateMixin {



late AnimationController controller;


late Animation<double> bounce;




@override
void initState(){


super.initState();



controller =
AnimationController(

vsync:this,

duration:
const Duration(seconds:2),

)..repeat(
reverse:true,
);



bounce =
Tween<double>(

begin:0,

end:12,

).animate(

CurvedAnimation(

parent:
controller,

curve:
Curves.easeInOut,

),

);



}




@override
void dispose(){

controller.dispose();

super.dispose();

}




@override
Widget build(BuildContext context){



return AnimatedBuilder(


animation:
bounce,


builder:(context,child){



return Transform.translate(


offset:

Offset(

0,

-bounce.value,

),



child:

Stack(


alignment:
Alignment.center,


children:[



// Floating stars


Positioned(

top:0,

right:0,


child:

Text(

"✨",

style:

TextStyle(

fontSize:
widget.size/4,

),

),

),





CircleAvatar(

radius:
widget.size/2,


backgroundColor:

Colors.yellow.shade100,




child:

Text(

"😊",

style:

TextStyle(

fontSize:
widget.size/2,

),

),


),



],


),


);



},


);



}


}