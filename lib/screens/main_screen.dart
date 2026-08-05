import 'package:flutter/material.dart';

import 'home/home_screen.dart';
import 'game_center_screen.dart';
import 'package:afaan_koo_app/screens/reward_screen.dart';
import 'package:afaan_koo_app/screens/profile_screen.dart';



class MainScreen extends StatefulWidget {


const MainScreen({super.key});



@override
State<MainScreen> createState()

=> _MainScreenState();


}







class _MainScreenState

extends State<MainScreen>

with SingleTickerProviderStateMixin {



int index = 0;



final pages = [


const HomeScreen(),

const GameCenterScreen(),

const RewardScreen(),

const ProfileScreen(),


];





final items = [



{

"title":"Mana",

"icon":Icons.home_rounded,

"color":Colors.orange,

},




{

"title":"Tapha",

"icon":Icons.games_rounded,

"color":Colors.green,

},




{

"title":"Badhaasa",

"icon":Icons.star_rounded,

"color":Colors.amber,

},




{

"title":"Ani",

"icon":Icons.face_rounded,

"color":Colors.blue,

},


];









@override
Widget build(BuildContext context){



return Scaffold(



extendBody:true,



body:

pages[index],







bottomNavigationBar:



Container(



margin:

const EdgeInsets.only(

left:15,

right:15,

bottom:15,

),



decoration:

BoxDecoration(



color:

Colors.white,



borderRadius:

BorderRadius.circular(35),



boxShadow:[



BoxShadow(

color:

Colors.black.withValues(alpha:0.15),

blurRadius:20,

offset:

const Offset(0,8),

),



],



),






child:

Padding(



padding:

const EdgeInsets.symmetric(

vertical:8,

),




child:

Row(



mainAxisAlignment:

MainAxisAlignment.spaceAround,



children:

List.generate(



items.length,



(i){



final item = items[i];



final selected = index == i;





return GestureDetector(



onTap:(){



setState((){


index=i;


});



},





child:

AnimatedContainer(



duration:

const Duration(

milliseconds:300,

),




padding:

EdgeInsets.symmetric(



horizontal:

selected ? 18 : 12,



vertical:

selected ? 8 : 5,



),




decoration:

BoxDecoration(



color:

selected

?

(item["color"] as Color)

.withValues(alpha:0.2)

:

Colors.transparent,



borderRadius:

BorderRadius.circular(25),



),





child:

Column(



mainAxisSize:

MainAxisSize.min,



children:[





AnimatedScale(



duration:

const Duration(

milliseconds:250,

),



scale:

selected ? 1.25 : 1,



child:

Icon(



item["icon"] as IconData,



size:

30,



color:

item["color"] as Color,



),



),





if(selected)



Text(



item["title"] as String,



style:

TextStyle(



fontWeight:

FontWeight.bold,



color:

item["color"] as Color,



),



),





],



),



),



);



},



),



),



),



),



);



}


}