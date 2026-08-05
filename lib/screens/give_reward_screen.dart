import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reward_provider.dart';



class GiveRewardScreen extends StatelessWidget {


final String studentId;



const GiveRewardScreen({

super.key,

required this.studentId,

});





@override
Widget build(BuildContext context){



return Scaffold(


appBar:

AppBar(

title:

const Text(
"Badhaasa Kenni 🎁",
),

),





body:

Padding(

padding:

const EdgeInsets.all(20),



child:

Column(


children:[



_rewardButton(

context,

"⭐ Barataa Gaarii",

"Excellent learner",

10,

3,

"gold",

),




_rewardButton(

context,

"🏅 Qubee Beekaa",

"Alphabet master",

20,

5,

"alphabet",

),





_rewardButton(

context,

"🏆 Cimaa",

"Great progress",

50,

10,

"master",

),



],


),


),


);


}






Widget _rewardButton(

BuildContext context,

String title,

String description,

int xp,

int stars,

String badge,

){


return Padding(


padding:

const EdgeInsets.only(bottom:15),



child:

SizedBox(


width:

double.infinity,



child:

ElevatedButton(


onPressed:(){



context

.read<RewardProvider>()

.giveStudentReward(



studentId:

studentId,



title:

title,



description:

description,



xp:

xp,



stars:

stars,



badge:

badge,


);



Navigator.pop(context);



},



child:

Text(title),



),


),


);



}


}