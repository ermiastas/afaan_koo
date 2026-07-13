import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'game_center_screen.dart';
import 'package:afaan_koo_app/screens/reward_screen.dart';
import 'package:afaan_koo_app/screens/profile_screen.dart';


class MainScreen extends StatefulWidget{

const MainScreen({super.key});


@override
State<MainScreen> createState()
=> _MainScreenState();

}



class _MainScreenState 
extends State<MainScreen>{


int index = 0;


final pages = [

const HomeScreen(),

const GameCenterScreen(),

const RewardScreen(),

const ProfileScreen(),

];



@override

Widget build(BuildContext context){


return Scaffold(


body:
pages[index],



bottomNavigationBar:

BottomNavigationBar(


currentIndex:index,


onTap:(value){

setState((){

index=value;

});

},


items:[


const BottomNavigationBarItem(

icon:Icon(Icons.home),

label:"Mana",

),



const BottomNavigationBarItem(

icon:Icon(Icons.games),

label:"Tapha",

),



const BottomNavigationBarItem(

icon:Icon(Icons.star),

label:"Badhaasa",

),



const BottomNavigationBarItem(

icon:Icon(Icons.person),

label:"Ani",

),


],


),


);


}

}
