import 'package:flutter/material.dart';

import 'lesson_theme.dart';



class LessonThemeMapper {


  static LessonTheme getTheme(String lesson) {


    switch(lesson){



      // ===============================
      // Afaan fi Lakkoofsa
      // ===============================


      case "Qubee Koo":

      case "alphabet":

        return LessonTheme.alphabet;



      case "Lakkoofsa Koo":

        return LessonTheme.numbers;



      case "Jechoota Koo":

        return LessonTheme.words;





      // ===============================
      // Uumama
      // ===============================


      case "Bineensa":

      case "Bineensa Koo":

        return LessonTheme.animals;



      case "Firii":

      case "Firii Koo":

        return LessonTheme.fruits;



      case "Biqiltuu":

      case "Biqiltuu Koo":

        return LessonTheme.plants;



      case "Kuduraa":

      case "Kuduraa Koo":

        return const LessonTheme(

          title:"Kuduraa Koo",

          emoji:"🥕",

          image:
          "assets/images/cards/vegetables.png",

          startColor:
          Colors.green,

          endColor:
          Colors.lightGreen,

          category:
          "Uumama",

          icon:Icons.abc

        );






      // ===============================
      // Fayyaa fi Nageenya
      // ===============================


      case "Qulqullina Qaamaa":

        return LessonTheme.hygiene;



      case "Nageenya Daandii":

        return LessonTheme.traffic;








      // ===============================
      // Jireenya Guyyaa Guyyaa
      // ===============================


      case "Nyaataa":

      case "Nyaataa fi Dhugaatii":

        return const LessonTheme(

          title:"Nyaataa fi Dhugaatii",

          emoji:"🍽️",

          image:
          "assets/images/cards/food.png",

          startColor:
          Colors.red,

          endColor:
          Colors.orange,

          category:
          "Jireenya Guyyaa Guyyaa",
          icon:
          Icons.food_bank

        );



      case "Maatii Koo":

        return const LessonTheme(

          title:"Maatii Koo",

          emoji:"👨‍👩‍👧",

          image:
          "assets/images/cards/family.png",

          startColor:
          Colors.pink,

          endColor:
          Colors.pinkAccent,

          category:
          "Jireenya Guyyaa Guyyaa",
          icon:
          Icons.family_restroom_outlined

        );



      case "Mana Barumsaa Koo":

        return const LessonTheme(

          title:"Mana Barumsaa Koo",

          emoji:"🏫",

          image:
          "assets/images/cards/school.png",

          startColor:
          Colors.blue,

          endColor:
          Colors.lightBlueAccent,

          category:
          "Jireenya Guyyaa Guyyaa",

                    icon:
          Icons.school

        );



      case "Qarshii Koo":

        return const LessonTheme(

          title:"Qarshii Koo",

          emoji:"💰",

          image:
          "assets/images/cards/money.png",

          startColor:
          Colors.amber,

          endColor:
          Colors.orange,

          category:
          "Jireenya Guyyaa Guyyaa",
          icon:
          Icons.money

        );





      // ===============================
      // Aadaa Oromoo
      // ===============================


      case "Aadaa Oromoo":

        return LessonTheme.culture;



      case "Oduu Durii":

        return LessonTheme.story;



      case "Hibboo":

        return const LessonTheme(

          title:"Hibboo",

          emoji:"💡",

          image:
          "assets/images/cards/hibboo.png",

          startColor:
          Colors.amber,

          endColor:
          Colors.deepOrange,

          category:
          "Aadaa fi Safuu Oromoo",
          icon:
          Icons.home

        );



      case "Mammaaksa":

        return const LessonTheme(

          title:"Mammaaksa",

          emoji:"🗣️",

          image:
          "assets/images/cards/mammaaksa.png",

          startColor:
          Colors.brown,

          endColor:
          Colors.orange,

          category:
          "Aadaa fi Safuu Oromoo",
          icon:
          Icons.radio_button_checked_outlined

        );




      case "Naamusa Gaarii":

        return const LessonTheme(

          title:"Naamusa Gaarii",

          emoji:"😊",

          image:
          "assets/images/cards/manners.png",

          startColor:
          Colors.purple,

          endColor:
          Colors.purpleAccent,

          category:
          "Aadaa fi Safuu Oromoo",
                    icon:
          Icons.home

        );






      // ===============================
      // Default
      // ===============================


      default:

        return const LessonTheme(

          title:"Barnoota",

          emoji:"📚",

          image:
          "assets/images/cards/default.png",

          startColor:
          Colors.blueGrey,

          endColor:
          Colors.grey,

          category:
          "General",
          icon:
          Icons.home

        );


    }


  }



}