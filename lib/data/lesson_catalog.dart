import 'package:flutter/material.dart';

import '../models/app_lesson.dart';


final List<AppLesson> lessonCatalog = [


  // ============================
  // Afaan fi Qubee
  // ============================


  AppLesson(
    id: "alphabet",
    title: "Qubee Koo",
    description: "Qubee Afaan Oromoo baradhu, dubbisi, barreessi.",
    category: "Afaan fi Qubee",
    emoji: "🔤",
    color: Colors.blue,
    route: "/qubee",
    badgeId: "qubee_master",
    ages: [3,4,5,6,7,8],
  ),


  AppLesson(
    id: "words",
    title: "Jechoota Koo",
    description: "Jechoota Afaan Oromoo fi hiika isaanii baradhu.",
    category: "Afaan fi Qubee",
    emoji: "📝",
    color: Colors.green,
    route: "/words",
    badgeId: "word_master",
    ages: [3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"numbers",
    title:"Lakkoofsa Koo",
    description:"Lakkoofsa 1 hanga dhibbaatti baradhu.",
    category:"Lakkoofsa",
    emoji:"🔢",
    color:Colors.orange,
    route:"/numbers",
    badgeId:"number_master",
    ages:[3,4,5,6,7,8],
  ),



  AppLesson(
    id:"math",
    title:"Herrega Koo",
    description:"Herrega salphaa baradhu.",
    route:"/math",
    category:"Barnoota",
    badgeId:"math_master",
    emoji:"➕",
    color:Colors.green,
    ages:[5,6,7,8,9,10],
  ),



  AppLesson(
    id:"time_math",
    title:"Yeroo",
    description:"Sa'aatii dubbisuu fi yeroo beekuu baradhu.",
    category:"Herrega Koo",
    route:"/time_math_game",
    emoji:"🕒",
    color:Colors.orange,
    badgeId:"time_master",
    ages:[5,6,7,8,9,10],
  ),



  AppLesson(
    id:"quiz",
    title:"Quiz",
    description:"Waan baratte qoradhu.",
    category:"Taphawwan",
    emoji:"⭐",
    color:Colors.red,
    route:"/quiz",
    badgeId:"quiz_champion",
    ages:[3,4,5,6,7,8,9,10],
  ),



  // ============================
  // Uumama
  // ============================


  AppLesson(
    id:"animals",
    title:"Bineensota",
    description:"Maqaa bineensotaa baradhu.",
    category:"Uumama",
    emoji:"🐒",
    color:Colors.brown,
    route:"/animals",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"plants",
    title:"Biqiltuu Koo",
    description:"Biqiltuu fi muka adda addaa baradhu.",
    category:"Uumama",
    emoji:"🌱",
    color:Colors.green,
    route:"/plants",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"weather",
    title:"Haala Qilleensaa",
    description:"Rooba, aduu fi qilleensa baradhu.",
    category:"Uumama",
    emoji:"⛅",
    color:Colors.lightBlue,
    route:"/weather",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),




  // ============================
  // Jireenya Guyyaa Guyyaa
  // ============================


  AppLesson(
    id:"fruits",
    title:"Muduraa Koo",
    description:"Maqaa muduraa adda addaa baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"🍎",
    color:Colors.red,
    route:"/fruits",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"vegetables",
    title:"Kuduraa Koo",
    description:"Kuduraalee nyaataa baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"🥕",
    color:Colors.green,
    route:"/vegetables",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),


/*
  AppLesson(
    id:"home_objects",
    title:"Mana Koo",
    description:"Wantoota mana keessaa baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"🏠",
    color:Colors.brown,
    route:"/home_objects",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),
*/



  AppLesson(
    id: "paint_studio",
    title: "🎨 Isuudiyoo Fakkii",
    description: "Fakkii kaasii fi halluu dibi.",
    category: "Kalaqa",
    emoji: "🎨",
    color: Colors.deepPurple,
    route: "/paint",
    badgeId: "artist_master",
    ages: [3,4,5,6,7,8,9,10,11,12],
  ),


  AppLesson(
    id:"coloring",
    title:"Kitaaba Halluu",
    description:"Halluu itti fayyadamuun kalaqa kee mul'isi.",
    category:"Uumama fi Kalaqa",
    emoji:"🖍️",
    color:Colors.pink,
    route:"/coloring",
    badgeId:"color_master",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),

  

  AppLesson(
    id:"market",
    title:"Gabaa Koo",
    description:"Wantoota gabaa keessatti argaman baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"🛒",
    color:Colors.teal,
    route:"/market",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"money",
    title:"Qarshii Koo",
    description:"Qarshii itti fayyadamuu baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"💰",
    color:Colors.amber,
    route:"/money",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"time",
    title:"Yeroo Koo",
    description:"Sa'aatii fi yeroo baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"🕒",
    color:Colors.deepOrange,
    route:"/time",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"month",
    title:"Ji'oota Waggaa",
    description:"Ji'oota waggaa kudha lama baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"📆",
    color:Colors.green,
    route:"/month",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"occupation",
    title:"Ogummaa Koo",
    description:"Hojiiwwan adda addaa baradhu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"👨‍🔧",
    color:Colors.blue,
    route:"/occupation",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"transport",
    title:"Geejjiba Koo",
    description:"Geejjiba adda addaa beekuu.",
    category:"Jireenya Guyyaa Guyyaa",
    emoji:"🚗",
    color:Colors.teal,
    route:"/transport",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  // ============================
  // Fayyaa fi Nageenya
  // ============================


  AppLesson(
    id:"hygiene",
    title:"Qulqullina Qaamaa",
    description:"Qulqullina qaamaa eeguu baradhu.",
    category:"Fayyaa fi Nageenya",
    emoji:"🧼",
    color:Colors.blue,
    route:"/hygiene",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"traffic",
    title:"Nageenya Daandii",
    description:"Seera daandii fi nageenya baradhu.",
    category:"Fayyaa fi Nageenya",
    emoji:"🚦",
    color:Colors.orange,
    route:"/traffic",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  // ============================
  // Aadaa Oromoo
  // ============================


  AppLesson(
    id:"oromo_culture",
    title:"Aadaa Oromoo",
    description:"Aadaa fi duudhaa Oromoo baradhu.",
    category:"Aadaa Oromoo",
    emoji:"🏛️",
    color:Colors.brown,
    route:"/oromo_culture",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"hibboo",
    title:"Hibboo Koo",
    description:"Gaaffii hibboo fi yaada Oromoo baradhu.",
    category:"Aadaa Oromoo",
    emoji:"💡",
    color:Colors.amber,
    route:"/hibboo",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"mammaaksa",
    title:"Mammaaksa Koo",
    description:"Mammaaksa Oromoo fi barumsa isaanii.",
    category:"Aadaa Oromoo",
    emoji:"🗣️",
    color:Colors.brown,
    route:"/mammaaksa",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  // ============================
  // Mana Barumsaa
  // ============================


  AppLesson(
    id:"school",
    title:"Mana Barumsaa Koo",
    description:"Wantoota mana barumsaa keessatti argaman.",
    category:"Mana Barumsaa",
    emoji:"🏫",
    color:Colors.blue,
    route:"/school",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"school_supplies",
    title:"Meeshaalee Barumsaa",
    description:"Meeshaalee barumsaa baradhu.",
    category:"Mana Barumsaa",
    emoji:"🎒",
    color:Colors.purple,
    route:"/school_supplies",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  AppLesson(
    id:"shape",
    title:"Bocaalee Koo",
    description:"Bocaalee adda addaa baradhu.",
    category:"Herrega",
    emoji:"🔷",
    color:Colors.purple,
    route:"/shape",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),



  // ============================
  // Seenaa fi Sirba
  // ============================


  AppLesson(
    id:"story",
    title:"Seenaa Koo",
    description:"Seenaa nama gammachiisaa dubbisi.",
    category:"Aadaa fi Afaan",
    emoji:"📖",
    color:Colors.indigo,
    route:"/story",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),


AppLesson(

  id:"afaankoo_tv",

  title:"AfaanKoo TV+",

  description:
      "Viidiyoo barnootaa ilaali, buufadhu fi offline baradhu.",

  category:"Media fi Barnoota",

  emoji:"📺",

  color:Colors.blue,

  route:"/afaankoo_tv",

  badgeId:"tv_explorer",

  ages:[
    3,4,5,6,7,8,9,10,11,12
  ],

),



  AppLesson(
    id:"songs",
    title:"Sirba Koo",
    description:"Sirboota Afaan Oromoo dhaggeeffadhu.",
    category:"Aadaa fi Afaan",
    emoji:"🎵",
    color:Colors.pink,
    route:"/songs",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),


 AppLesson(
    id:"multiplication_game",
    title:"Baay'isuu",
    description:"Lakkofsa waliin haa baay'snu",
    badgeId:"multiplication_master",
    category:"Taphawwan",
    route:"/multiplication_game",
    emoji:"✖️",
    color:Color.fromARGB(255, 32, 15, 216),
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),





 AppLesson(
    id:"division_game",
    title:"Hiruu",
    description:"Lakkofsa waliif haa hirru",
    badgeId:"division_master",
    category:"Taphawwan",
    route:"/division_game",
    emoji:"➗",
    color:Color.fromARGB(255, 32, 15, 216),
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),


  AppLesson(
    id:"handwriting",
    title:"Barreessi",
    description:"Qubee fi lakkoofsa qubbiin barreessi.",
    badgeId:"handwriting_master",
    category:"Taphawwan",
    route:"/handwriting",
    emoji:"✍️",
    color:Colors.pink,
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),


/*
  AppLesson(
    id:"drawing",
    title:"Halluu Dibuu",
    description:"Suuraalee halluu dibi.",
    badgeId:"badge_coloring",
    route:"/coloring",
    emoji:"🖍️",
    color:Colors.pink,
    category:"Creative",
    ages:[3,4,5,6,7,8,9,10,11,12],
  ),
*/
];