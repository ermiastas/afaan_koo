import 'package:flutter/material.dart';


// ===============================
// Afaan fi Lakkoofsa
// ===============================

import '../screens/qubee_screen.dart';
import '../screens/alphabet_screen.dart';
import '../screens/number_menu_screen.dart';
import '../screens/word_screen.dart';


// ===============================
// Uumama
// ===============================

import '../screens/animal_screen.dart';
import '../screens/fruit_screen.dart';
import '../screens/vegetable_screen.dart';
import '../screens/plant_screen.dart';
import '../screens/environment_screen.dart';


// ===============================
// Jireenya Guyyaa Guyyaa
// ===============================

import '../screens/family_screen.dart';
import '../screens/school_screen.dart';
import '../screens/money_screen.dart';
import '../screens/market_screen.dart';
import '../screens/food_screen.dart';
import '../screens/home_object_screen.dart';
import '../screens/school_supplies_screen.dart';
import '../screens/transport_screen.dart';
import '../screens/time_screen.dart';
import '../screens/shape_screen.dart';
import '../screens/occupation_screen.dart';
import '../screens/month_screen.dart';


// ===============================
// Fayyaa fi Nageenya
// ===============================

import '../screens/hygiene_screen.dart';
import '../screens/traffic_screen.dart';


// ===============================
// Aadaa fi Safuu Oromoo
// ===============================

import '../screens/story_screen.dart';
import '../screens/hibboo_screen.dart';
import '../screens/mammaaksa_screen.dart';
import '../screens/manners_screen.dart';



class LessonRouter {


  static Widget? getLessonScreen(String lesson) {


    switch (lesson) {


      // =====================================
      // Afaan fi Lakkoofsa
      // =====================================


      case "alphabet":
      case "Qubee Koo":

        return const AlphabetMenuScreen();



      case "Qubee Guguddaa":

        return const AlphabetScreen();



      case "Lakkoofsa Koo":

        return const NumberMenuScreen();



      case "Jechoota Koo":

        return const WordScreen();





      // =====================================
      // Uumama
      // =====================================


      case "Bineensa":

        return const AnimalScreen();



      case "Firii":

        return FruitScreen();



      case "Kuduraa":

        return  VegetableScreen();



      case "Biqiltuu":

        return const PlantScreen();



      case "Naannoo Koo":

        return const EnvironmentScreen();







      // =====================================
      // Jireenya Guyyaa Guyyaa
      // =====================================


      case "Maatii Koo":

        return const FamilyScreen();



      case "Mana Barumsaa Koo":

        return const SchoolScreen();



      case "Qarshii Koo":

        return const MoneyScreen();



      case "Gabaa Koo":

        return const MarketScreen();



      case "Nyaataa":

        return const FoodScreen();



      case "Mana Koo":

        return const HomeObjectScreen();



      case "Meeshaalee Barumsaa":

        return const SchoolSuppliesScreen();



      case "Bocaalee Koo":

        return const ShapeScreen();



      case "Yeroo Koo":

        return const TimeScreen();



      case "Ji'oota Waggaa":

        return const MonthScreen();



      case "Ogummaa Koo":

        return const OccupationScreen();



      case "Geejjiba Koo":

        return const TransportScreen();







      // =====================================
      // Fayyaa fi Nageenya
      // =====================================


      case "Qulqullina Qaamaa":

        return const HygieneScreen();



      case "Nageenya Daandii":

        return const TrafficScreen();







      // =====================================
      // Aadaa fi Safuu Oromoo
      // =====================================


      case "Oduu Durii":

        return const StoryScreen();



      case "Hibboo":

        return const HibbooScreen();



      case "Mammaaksa":

        return const MammaaksaScreen();



      case "Naamusa Gaarii":

        return const MannersScreen();





      default:


        debugPrint(
          "⚠️ Lesson screen not found: $lesson",
        );


        return null;


    }


  }


}