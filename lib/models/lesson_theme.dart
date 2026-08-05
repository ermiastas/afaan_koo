import 'package:flutter/material.dart';



class LessonTheme {


  final String title;

  final String emoji;

  final String image;


  final Color startColor;

  final Color endColor;


  final String category;
  final IconData icon;



  const LessonTheme({


    required this.title,

    required this.emoji,

    required this.image,

    required this.startColor,

    required this.endColor,

    required this.category,
    required this.icon,


  });





  // ===============================
  // Afaan fi Lakkoofsa
  // ===============================


  static const alphabet = LessonTheme(

    title: "Qubee Koo",

    emoji: "🔤",

    image:
    "assets/images/cards/alphabet.png",

    startColor:
    Colors.deepPurple,

    endColor:
    Colors.purpleAccent,

    category:
    "Afaan fi Lakkoofsa",

          icon:
          Icons.abc

  );





  static const numbers = LessonTheme(

    title: "Lakkoofsa Koo",

    emoji: "🔢",

    image:
    "assets/images/cards/numbers.png",

    startColor:
    Colors.blue,

    endColor:
    Colors.lightBlueAccent,

    category:
    "Afaan fi Lakkoofsa",
            icon:
          Icons.numbers

  );





  static const words = LessonTheme(

    title: "Jechoota Koo",

    emoji:"📝",

    image:
    "assets/images/cards/words.png",

    startColor:
    Colors.orange,

    endColor:
    Colors.amber,

    category:
    "Afaan fi Lakkoofsa",
              icon:
          Icons.numbers

  );






  // ===============================
  // Uumama
  // ===============================


  static const animals = LessonTheme(

    title:"Bineensa Koo",

    emoji:"🐾",

    image:
    "assets/images/cards/animals.png",

    startColor:
    Colors.green,

    endColor:
    Colors.lightGreen,

    category:
    "Uumama",
            icon:
          Icons.nature

  );





  static const fruits = LessonTheme(

    title:"Firii Koo",

    emoji:"🍎",

    image:
    "assets/images/cards/fruits.png",

    startColor:
    Colors.red,

    endColor:
    Colors.pinkAccent,

    category:
    "Uumama",
            icon:
          Icons.nature

  );





  static const plants = LessonTheme(

    title:"Biqiltuu Koo",

    emoji:"🌱",

    image:
    "assets/images/cards/plants.png",

    startColor:
    Colors.green,

    endColor:
    Colors.teal,

    category:
    "Uumama",
          icon:
          Icons.nature
  );







  // ===============================
  // Fayyaa
  // ===============================


  static const hygiene = LessonTheme(

    title:"Qulqullina Qaamaa",

    emoji:"🧼",

    image:
    "assets/images/cards/hygiene.png",

    startColor:
    Colors.blue,

    endColor:
    Colors.cyan,

    category:
    "Fayyaa fi Nageenya",
          icon:
          Icons.health_and_safety

  );





  static const traffic = LessonTheme(

    title:"Nageenya Daandii",

    emoji:"🚦",

    image:
    "assets/images/cards/traffic.png",

    startColor:
    Colors.orange,

    endColor:
    Colors.deepOrange,

    category:
    "Fayyaa fi Nageenya",

          icon:
          Icons.safety_check

  );







  // ===============================
  // Aadaa Oromoo
  // ===============================


  static const culture = LessonTheme(

    title:"Aadaa Oromoo",

    emoji:"🏛️",

    image:
    "assets/images/cards/culture.png",

    startColor:
    Colors.brown,

    endColor:
    Colors.orange,

    category:
    "Aadaa fi Safuu Oromoo",

          icon:
          Icons.health_and_safety

  );





  static const story = LessonTheme(

    title:"Oduu Durii",

    emoji:"📖",

    image:
    "assets/images/cards/story.png",

    startColor:
    Colors.indigo,

    endColor:
    Colors.deepPurple,

    category:
    "Aadaa fi Safuu Oromoo",

          icon:
          Icons.question_mark

  );



}