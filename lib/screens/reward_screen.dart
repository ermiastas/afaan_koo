import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reward_provider.dart';
import '../providers/progress_provider.dart';



class RewardScreen extends StatelessWidget {


const RewardScreen({super.key});



@override
Widget build(BuildContext context){


final reward =
Provider.of<RewardProvider>(context);



final progress =
Provider.of<ProgressProvider>(context);



return Scaffold(


appBar:

AppBar(

title:

const Text(
"Badhaasa Koo ⭐"
),

),



body:

Padding(

padding:
const EdgeInsets.all(20),


child:

Column(

children:[



CircleAvatar(

radius:60,

backgroundColor:
Colors.amber,

child:

const Icon(

Icons.star,

size:70,

color:Colors.white,

),

),




const SizedBox(
height:20,
),




Text(

"Urjii Kee",

style:

const TextStyle(

fontSize:25,

fontWeight:
FontWeight.bold,

),

),




Text(

"${reward.stars} ⭐",

style:

const TextStyle(

fontSize:45,

fontWeight:
FontWeight.bold,

color:Colors.orange,

),

),




const SizedBox(
height:30,
),





Card(

child:

ListTile(

leading:

const Icon(

Icons.menu_book,

color:Colors.green,

),


title:

const Text(
"Barnoota xumurame"
),


trailing:

Text(

"${progress.completedCount}",

style:

const TextStyle(

fontSize:22,

),

),


),

),





const SizedBox(
height:20,
),





Card(

child:

ListTile(

leading:

const Icon(

Icons.emoji_events,

color:Colors.orange,

),



title:

const Text(
"Sadarkaa"
),



trailing:

Text(

_getLevel(
reward.stars
),

style:

const TextStyle(

fontWeight:
FontWeight.bold,

),

),



),

),





],

),

),


);


}





String _getLevel(int stars){


if(stars >= 50){

return "Goota Barnootaa 🏆";

}


if(stars >= 20){

return "Barataa Jabaataa ⭐";

}


if(stars >= 5){

return "Jalqabaa 🌱";

}


return "Haaraa 👋";


}



}