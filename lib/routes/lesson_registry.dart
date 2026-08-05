import 'package:afaan_koo_app/screens/traffic_screen.dart';
import 'package:flutter/material.dart';


// Existing screens
import '../screens/alphabet_screen.dart';
import '../screens/number_screen.dart';
import '../screens/word_screen.dart';

import '../screens/animal_screen.dart';
import '../screens/fruit_screen.dart';
import '../screens/vegetable_screen.dart';
import '../screens/plant_screen.dart';

import '../screens/hygiene_screen.dart';

// New screens
import '../screens/body_screen.dart';
import '../screens/clothing_screen.dart';
import '../screens/transport_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/shape_screen.dart';
import '../screens/home_object_screen.dart';

import '../screens/family_screen.dart';
import '../screens/school_screen.dart';
import '../screens/money_screen.dart';

import '../screens/story_screen.dart';
import '../screens/hibboo_screen.dart';
import '../screens/mammaaksa_screen.dart';
import '../screens/manners_screen.dart';



class LessonRegistry {



static final Map<String, Widget Function()> lessons = {



"Qubee Koo":

() => const AlphabetScreen(),



"Lakkoofsa Koo":

() => const NumberScreen(),



"Jechoota Koo":

() => const WordScreen(),




"Bineensa":

() => const AnimalScreen(),



"Firii":

() =>  FruitScreen(),



"Kuduraa":

() =>  VegetableScreen(),



"Biqiltuu":

() => const PlantScreen(),




"Qulqullina Qaamaa":

() => const HygieneScreen(),



"Nageenya Daandii":

() => const TrafficScreen(),




"Qaama Koo":

() => const BodyScreen(),



"Uffata Koo":

() => const ClothingScreen(),



"Geejjiba Koo":

() => const TransportScreen(),



"Haala Qilleensaa":

() => const WeatherScreen(),



"Bocaalee Koo":

() => const ShapeScreen(),



"Meeshaalee Manaa":

() => const HomeObjectScreen(),




"Maatii Koo":

() => const FamilyScreen(),



"Mana Barumsaa Koo":

() => const SchoolScreen(),



"Qarshii Koo":

() => const MoneyScreen(),





"Oduu Durii":

() => const StoryScreen(),



"Hibboo":

() => const HibbooScreen(),



"Mammaaksa":

() => const MammaaksaScreen(),



"Naamusa Gaarii":

() => const MannersScreen(),



};



static Widget? open(String lessonName){


final lesson =

lessons[lessonName];



if(lesson != null){

return lesson();

}


debugPrint(

"Lesson not registered: $lessonName"

);


return null;


}



}