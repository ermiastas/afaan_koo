import 'package:flutter/material.dart';

import '../services/progress_service.dart';

import '../services/badge_service.dart';



class ProgressScreen extends StatefulWidget {


const ProgressScreen({super.key});


@override
State<ProgressScreen> createState()

=> _ProgressScreenState();


}





class _ProgressScreenState extends State<ProgressScreen>{



int stars = 0;

int lessons = 0;

int badges = 0;



final int totalLessons = 100;




@override
void initState(){

super.initState();

loadProgress();

}





Future<void> loadProgress() async{


final savedStars =

await ProgressService.getStars();



final savedLessons =

await ProgressService.getLessons();



final savedBadges =

await BadgeService.getBadges();



setState((){


stars = savedStars;

lessons = savedLessons;

badges = savedBadges.length;


});


}





@override
Widget build(BuildContext context){



double progress =

lessons / totalLessons;



if(progress > 1){

progress = 1;

}



return Scaffold(



appBar:

AppBar(

title:

const Text(

"📊 Guddina Koo",

),

centerTitle:true,

),




body:

SingleChildScrollView(



padding:

const EdgeInsets.all(20),



child:

Column(



children:[



// Raji


const CircleAvatar(

radius:45,

child:

Text(

"😊",

style:

TextStyle(

fontSize:45,

),

),

),



const SizedBox(height:15),



const Text(

"Raajiin siiin boonaa jira!",

style:

TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:25),





// Stars Card


_progressCard(

icon:"⭐",

title:"Stars",

value:

stars.toString(),

color:

Colors.amber,

),





// Lessons


_progressCard(

icon:"📚",

title:"Lessons Xumuraman",

value:

lessons.toString(),

color:

Colors.green,

),





// Badges


_progressCard(

icon:"🏆",

title:"Badges",

value:

badges.toString(),

color:

Colors.orange,

),





const SizedBox(height:30),





const Text(

"Barnoota Keessan",

style:

TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:15),





LinearProgressIndicator(


value:

progress,


minHeight:

18,


),





const SizedBox(height:10),



Text(

"${(progress*100).toInt()}% xumurame",

style:

const TextStyle(

fontSize:18,

),

),





],

),



),



);



}





Widget _progressCard({

required String icon,

required String title,

required String value,

required Color color,


}){


return Card(

margin:

const EdgeInsets.only(

bottom:15,

),


elevation:4,



child:

ListTile(



leading:

CircleAvatar(

backgroundColor:

color,

child:

Text(

icon,style: const TextStyle(

fontSize:22,
)

),

),



title:

Text(

title,

style:

const TextStyle(

fontSize:18,

fontWeight:

FontWeight.bold,

),

),



trailing:

Text(

value,

style:

const TextStyle(

fontSize:24,

fontWeight:

FontWeight.bold,

),

),



),



);


}



}