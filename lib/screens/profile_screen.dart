import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_profile.dart';
import '../providers/user_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';



class ProfileScreen extends StatelessWidget {


const ProfileScreen({super.key});



@override
Widget build(BuildContext context){


final userProvider =
Provider.of<UserProvider>(context);


final progress =
Provider.of<ProgressProvider>(context);


final reward =
Provider.of<RewardProvider>(context);



final user =
userProvider.user;




return Scaffold(


appBar:

AppBar(

title:

const Text(
"Ani 👤"
),

),




body:

user == null

?

_createProfile(context)

:

_showProfile(

user,

progress,

reward,

),


);


}







Widget _createProfile(BuildContext context){



final nameController =
TextEditingController();



final ageController =
TextEditingController();




return Padding(


padding:

const EdgeInsets.all(20),



child:

Column(


children:[




const CircleAvatar(

radius:50,

child:

Icon(

Icons.child_care,

size:50,

),

),




const SizedBox(

height:20,

),




TextField(

controller:

nameController,


decoration:

const InputDecoration(

labelText:

"Maqaa mucaa"

),

),





TextField(

controller:

ageController,


keyboardType:

TextInputType.number,


decoration:

const InputDecoration(

labelText:

"Umurii"

),

),





const SizedBox(

height:20,

),





ElevatedButton(

onPressed:(){



final profile =

UserProfile(


id:

DateTime.now()
.toString(),



name:

nameController.text,



age:

int.tryParse(
ageController.text
) ?? 0,



avatar:

"assets/images/kooree.png",

);




Provider.of<UserProvider>(

context,

listen:false,

)

.setUser(profile);




},



child:

const Text(
"Kuusi"
),



),




],


),



);



}









Widget _showProfile(

UserProfile user,

ProgressProvider progress,

RewardProvider reward,

){



return SingleChildScrollView(



padding:

const EdgeInsets.all(20),



child:

Column(



children:[





CircleAvatar(


radius:60,


backgroundImage:

AssetImage(
user.avatar
),


),





const SizedBox(

height:20,

),





Text(

user.name,

style:

const TextStyle(

fontSize:30,

fontWeight:

FontWeight.bold,

),

),





Text(

"Umurii: ${user.age}",


style:

const TextStyle(

fontSize:20,

),

),





const SizedBox(

height:25,

),






Card(

child:

ListTile(


leading:

const Icon(

Icons.star,

color:

Colors.orange,

),



title:

const Text(
"Urjii"
),



trailing:

Text(

"${reward.stars} ⭐",

style:

const TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),



),


),







Card(

child:

ListTile(


leading:

const Icon(

Icons.book,

color:

Colors.green,

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







Card(

child:

ListTile(


leading:

const Icon(

Icons.games,

color:

Colors.blue,

),



title:

const Text(
"Taphoota xumurame"
),



trailing:

Text(

"${progress.progress.gamesCompleted}",

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






Text(

"Sadarkaa Barnootaa",

style:

const TextStyle(

fontSize:20,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(

height:10,

),





LinearProgressIndicator(

minHeight:

12,

value:

progress.completionPercentage,

),




const SizedBox(

height:15,

),





Text(

_getLevel(
reward.stars
),

style:

const TextStyle(

fontSize:22,

fontWeight:

FontWeight.bold,

),

),





],

),


);



}








String _getLevel(int stars){


if(stars >= 100){

return "🏆 Afaan Koo Goota";

}


if(stars >= 50){

return "🥇 Barataa Olaanaa";

}


if(stars >=20){

return "⭐ Barataa Jabaataa";

}


return "🌱 Jalqabaa";


}



}