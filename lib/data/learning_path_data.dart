import 'package:flutter/material.dart';

import '../models/learning_task.dart';



final List<LearningTask> dailyLearningTasks = [



LearningTask(

id:"daily_qubee",

title:"Qubee B 🔤",

description:
"Qubee Afaan Oromoo haa barannu",

route:"/alphabet",

icon:
Icons.abc,

color:
Colors.blue,

rewardXP:10,

),



LearningTask(

id:"daily_numbers",

title:"Lakkoofsa 🔢",

description:
"1 hanga 10 lakkaa'i",

route:"/numbers",

icon:
Icons.numbers,

color:
Colors.orange,

rewardXP:10,

),



LearningTask(

id:"daily_animals",

title:"Bineensota 🐘",

description:
"Maqaa bineensotaa baradhu",

route:"/animals",

icon:
Icons.pets,

color:
Colors.green,

rewardXP:10,

),



LearningTask(

id:"daily_color",

title:"Halluu 🎨",

description:
"Suura halluu dibii",

route:"/coloring",

icon:
Icons.palette,

color:
Colors.pink,

rewardXP:15,

),


];