import 'package:flutter/material.dart';

import '../models/game_item.dart';


final List<GameItem> games = [

GameItem(
id:"handwriting_trace",
title:"Shaakallii Barreessuu",
description:"Badhaasa argachuuf qubee jiru barreessuu yaali",
icon:"✍️",
iconData: Icons.draw_rounded,
rewardXP:60,
rewardCoins:20,
rewardStars:3,
category:"Writing",
),

GameItem(
id:"alphabet_trace",
title:"Qubee Barreessi",
description:"Qubee shan hordofiitii badhaasa argadhu",
icon:"✍️",
iconData: Icons.gesture_rounded,
rewardXP:45,
rewardCoins:15,
rewardStars:2,
category:"Afaan",
),

GameItem(
id:"balloon_count",
title:"Baloonii Lakkaa'i",
description:"Baloonota lakkaa'iitii lakkoofsa sirrii filadhu",
icon:"🎈",
iconData: Icons.celebration_rounded,
rewardXP:35,
rewardCoins:10,
rewardStars:1,
category:"Lakkoofsa",
),



GameItem(

id:"alphabet_match",

title:"Walitti Qabi Qubee",

description:
"Qubee sirrii jecha waliin walitti qabi",

icon:"🔤",

iconData:
Icons.abc,

rewardXP:30,

rewardCoins:10,

rewardStars:1,

category:"Afaan",

),




GameItem(

id:"word_memory",

title:"Yaadannoo Jechootaa",

description:
"Jechoota wal fakkaatan barbaadi",

icon:"🧠",

iconData:
Icons.memory,

rewardXP:50,

rewardCoins:15,

rewardStars:2,

category:"Yaadannoo",

),




GameItem(

id:"animal_quiz",

title:"Qormaata Bineensotaa",

description:
"Maqaa bineensotaa beektaa?",

icon:"🦁",

iconData:
Icons.pets,

rewardXP:40,

rewardCoins:10,

rewardStars:1,

category:"Uumama",

),




GameItem(

id:"listening",

title:"Dhaggeeffadhu",

description:
"Sagalee dhaggeeffachuun filadhu",

icon:"🎧",

iconData:
Icons.headphones,

rewardXP:40,

rewardCoins:10,

rewardStars:1,

category:"Sagalee",

),



];
