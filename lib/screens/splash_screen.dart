import 'package:flutter/material.dart';
import 'main_screen.dart';


class SplashScreen extends StatefulWidget{

const SplashScreen({super.key});


@override
State<SplashScreen> createState()
=> _SplashScreenState();

}



class _SplashScreenState
extends State<SplashScreen>{


@override
void initState(){

  super.initState();


  Future.delayed(

    const Duration(seconds:2),

    (){

      if(!mounted) return;


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:(context)
          =>
          const MainScreen(),

        ),

      );

    },

  );

}

@override

Widget build(BuildContext context){

return Scaffold(

body:

Center(

child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


const Icon(

Icons.menu_book,

size:100,

color:Colors.green,

),



const SizedBox(height:20),



const Text(

"Afaan Koo",

style:

TextStyle(

fontSize:40,

fontWeight:
FontWeight.bold,

),

),



const Text(

"Baradhu • Taphadhu • Guddadhu",

),

],

),

),

);

}

}
