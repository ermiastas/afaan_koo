import 'package:flutter/material.dart';

import '../data/badge_data.dart';

import '../services/badge_service.dart';



class BadgeScreen extends StatefulWidget {


const BadgeScreen({super.key});



@override

State<BadgeScreen> createState()

=> _BadgeScreenState();


}



class _BadgeScreenState extends State<BadgeScreen>{



List<String> unlockedBadges=[];



@override
void initState(){

super.initState();

loadBadges();

}





Future<void> loadBadges() async{


final badges =

await BadgeService.getBadges();


setState((){


unlockedBadges = badges;


});


}





@override
Widget build(BuildContext context){


return Scaffold(



appBar:

AppBar(

title:

const Text(

"🏆 Badges Koo",

),

centerTitle:true,

),





body:

ListView.builder(



padding:

const EdgeInsets.all(16),



itemCount:

badgeData.length,



itemBuilder:

(context,index){



final badge =

badgeData[index];




final unlocked =

unlockedBadges.contains(

badge.id,

);





return Card(


elevation:5,


margin:

const EdgeInsets.only(

bottom:16,

),



shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(20),

),




child:

ListTile(




leading:

CircleAvatar(


radius:30,


backgroundImage:

AssetImage(

badge.image,

),



),





title:

Text(

badge.nameOromo,


style:

TextStyle(

fontSize:18,

fontWeight:

FontWeight.bold,

color:

unlocked

? Colors.green

: Colors.grey,

),

),





subtitle:

Text(

badge.description,

),





trailing:

Icon(

unlocked

? Icons.lock_open

: Icons.lock,


color:

unlocked

? Colors.green

: Colors.grey,

),




),



);



},



),



);



}



}