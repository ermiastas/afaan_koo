import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reward_provider.dart';



class RewardPanel extends StatelessWidget{


const RewardPanel({super.key});


@override
Widget build(BuildContext context){


final reward =
context.watch<RewardProvider>();


return Card(

child:

Padding(

padding:
const EdgeInsets.all(16),


child:

Row(

mainAxisAlignment:
MainAxisAlignment.spaceAround,


children:[


Column(
children:[

const Text("⭐"),

Text(
"${reward.xp} XP"
),

],
),



Column(
children:[

const Text("🪙"),

Text(
"${reward.coins}"
),

],
),



Column(
children:[

const Text("📚"),

Text(
"${reward.lessons}"
),

],
),



],

),

),

);


}

}