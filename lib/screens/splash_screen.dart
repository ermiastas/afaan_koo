import 'package:flutter/material.dart';
import 'main_screen.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState()
  => _SplashScreenState();

}



class _SplashScreenState
extends State<SplashScreen>
with SingleTickerProviderStateMixin {



late AnimationController animation;



late Animation<double> scale;



@override
void initState(){

super.initState();



animation = AnimationController(

vsync:this,

duration:

const Duration(seconds:2),

);



scale = Tween<double>(

begin:0.5,

end:1,

).animate(

CurvedAnimation(

parent:animation,

curve:Curves.elasticOut,

),

);



animation.forward();



Future.delayed(

const Duration(seconds:3),

(){

if(!mounted)return;



Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:(context)

=> const MainScreen(),

),

);



},

);



}



@override
void dispose(){

animation.dispose();

super.dispose();

}




@override
Widget build(BuildContext context){


return Scaffold(

body:

Container(


decoration:

const BoxDecoration(


gradient:

LinearGradient(

colors:[

Color(0xff43CEA2),

Color(0xff185A9D),

],

begin:

Alignment.topLeft,

end:

Alignment.bottomRight,

),

),



child:

Center(


child:

ScaleTransition(

scale:scale,


child:

Column(

mainAxisAlignment:

MainAxisAlignment.center,


children:[


Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
  ),
  child: Image.asset(
    'assets/logo/splash.png',
    width: 180,
    height: 180,
    fit: BoxFit.contain,
  ),
),



const SizedBox(height:25),



const Text(

"Afaan Koo",

style:

TextStyle(

fontSize:45,

fontWeight:

FontWeight.bold,

color:

Colors.white,

),

),



const SizedBox(height:10),



const Text(

"Baradhu • Taphadhu • Guddadhu",

style:

TextStyle(

fontSize:18,

color:

Colors.white,

),

),



const SizedBox(height:30),



const CircularProgressIndicator(

color:

Colors.white,

)



],

),

),


),


),


);



}


}
