import 'package:flutter/material.dart';

//import '../screens/admin_dashboard_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/alphabet_screen.dart';
import '../screens/alphabet_menu_screen.dart';

import '../screens/animal_screen.dart';
import '../screens/avatar_selection_screen.dart';
import '../screens/body_screen.dart';

import '../screens/clothing_screen.dart';
import '../screens/color_screen_bk.dart';
import '../screens/coloring/coloring_home_screen.dart';
import '../screens/paint/paint_canvas_screen.dart';
import '../screens/parent_dashboard_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/school_supplies_screen.dart';
import '../screens/teacher_dashboard_screen.dart';
import '../screens/time_screen.dart';

// ignore: unused_import
import '../screens/coloring_book_screen.dart';
import '../screens/consonant_screen.dart';
import '../screens/day_screen.dart';
import '../screens/direction_screen.dart';
import '../screens/environment_screen.dart';

import '../screens/family_screen.dart';
import '../screens/food_screen.dart';
import '../screens/fruit_screen.dart';

import '../screens/hibboo_screen.dart';
import '../screens/home_object_screen.dart';
import '../screens/hygiene_screen.dart';

import '../screens/journey_screen.dart';
import '../screens/learning_screen.dart';

import '../screens/lowercase_screen.dart';
import '../screens/mammaaksa_screen.dart';
import '../screens/manners_screen.dart';

import '../screens/market_screen.dart';
import '../screens/math/addition_game_screen.dart';
import '../screens/math/counting_game_screen.dart';
import '../screens/math/division_game_screen.dart';
import '../screens/math/fraction_game_screen.dart';
import '../screens/math/money_math_game_screen.dart';
import '../screens/math/multiplication_game_screen.dart';
import '../screens/math/subtraction_game_screen.dart';
import '../screens/math/time_math_game_screen.dart';
import '../screens/math_screen.dart';
import '../screens/money_screen.dart';
import '../screens/month_screen.dart';

import '../screens/number_screen.dart';
import '../screens/number_menu_screen.dart';

import '../screens/occupation_screen.dart';
import '../screens/oromo_culture_screen.dart';

import '../screens/plant_screen.dart';
import '../screens/story_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/school_screen.dart';

import '../screens/shape_screen.dart';
import '../screens/song_screen.dart';


import '../screens/traffic_screen.dart';
import '../screens/transport_screen.dart';

import '../screens/tv/afaankoo_tv_home_screen.dart';
import '../screens/tv/downloads_screen.dart';
import '../screens/tv/offline_library_screen.dart';
import '../screens/vegetable_screen.dart';
import '../screens/vowel_screen.dart';

import '../screens/weather_screen.dart';
import '../screens/word_screen.dart';
import '../screens/age_selection_screen.dart';
import '../screens/handwriting_category_screen.dart';
import '../screens/settings_screen.dart';

import '../screens/double_letter_screen.dart';
import '../screens/tracing_practice_screen.dart';



final Map<String, WidgetBuilder> lessonRoutes = {


  "/qubee":
      (_) => const AlphabetMenuScreen(),


  "/alphabet":
      (_) => const AlphabetScreen(),


  "/alphabet-menu":
      (_) => const AlphabetMenuScreen(),



  "/animals":
      (_) => const AnimalScreen(),


  "/body":
      (_) => const BodyScreen(),



  "/clothing":
      (_) => const ClothingScreen(),


  "/colors":
      (_) => const ColorScreen(),



  "/consonant":
      (_) => const ConsonantScreen(),


'  /counting_game':

      (context)=>
      const CountingGameScreen(),

  "/days":
      (_) => const DayScreen(),



  "/direction":
      (_) => const DirectionScreen(),

  "/double-letter": (_) =>
      const DoubleLetterScreen(),

  "/environment":
      (_) => const EnvironmentScreen(),



  "/family":
      (_) => const FamilyScreen(),



  "/food":
      (_) => const FoodScreen(),



  "/fruits":
      (_) => FruitScreen(),



  "/hibboo":
      (_) => const HibbooScreen(),



  "/home-objects":
      (_) => const HomeObjectScreen(),



  "/hygiene":
      (_) => const HygieneScreen(),



  "/journey":
      (_) => const JourneyScreen(),

"/downloads":
    (_) => const DownloadsScreen(),

  // Learning screen needs arguments
  "/learning":
      (_) => LearningScreen(
        title: "Barnoota",
        color: Colors.blue,
        items: const [],
        rajiMessage:
            "Barnoota kee itti fufi!",
        lessonId:
            "learning",
      ),



  "/lowercase":
      (_) => const LowercaseScreen(),



  "/mammaaksa":
      (_) => const MammaaksaScreen(),



  "/manner":
      (_) => const MannersScreen(),



  "/market":
      (_) => const MarketScreen(),

'/math':

(context)=>const MathScreen(),

  "/money":
      (_) => const MoneyScreen(),



  "/month":
      (_) => const MonthScreen(),



  "/numbers":
      (_) => const NumberScreen(),



  "/number-menu":
      (_) => const NumberMenuScreen(),



  "/occupation":
      (_) => const OccupationScreen(),



  "/oromo_culture":
      (_) => const OromoCultureScreen(),

  "/avatar-selection":
    (_) => const AvatarSelectionScreen(),
  
"/profile-setup":
    (_) => const ProfileSetupScreen(),

  "/plants":
      (_) => const PlantScreen(),

  "/time": (_) => const TimeScreen(),

  '/paint': (context) => PaintCanvasScreen(),

  "/quiz":
      (_) => const QuizScreen(),

  "/afaankoo_tv":
    (_) => const AfaanKooTVHomeScreen(),

  "/school":
      (_) => const SchoolScreen(),

  "/school_supplies": (_) => const SchoolSuppliesScreen(),

  "/shape":
      (_) => const ShapeScreen(),



  "/songs":
      (_) => const SongScreen(),



"/offline-library":
    (_) => const OfflineLibraryScreen(),



  "/story":
      (_) => const StoryScreen(),


  "/tracing": (_) =>
      const TracingPracticeScreen(
        mode: TracingMode.alphabet,
      ),



  "/traffic":
      (_) => const TrafficScreen(),



  "/transport":
      (_) => const TransportScreen(),



  "/vegetables":
      (_) => VegetableScreen(),



  "/vowel":
      (_) => const VowelScreen(),



  "/weather":
      (_) => const WeatherScreen(),



  "/words":
      (_) => const WordScreen(),
  '/handwriting':
    (context) => const HandwritingCategoryScreen(),



'/coloring': (_) => const ColoringHomeScreen(),


  '/counting_game': (context)=> const CountingGameScreen(),

'/addition_game': (context)=> const AdditionGameScreen(),

'/subtraction_game': (context)=> const SubtractionGameScreen(),

'/multiplication_game': (context)=> const MultiplicationGameScreen(),

'/division_game': (context)=> const DivisionGameScreen(),

'/fraction_game': (context)=> const FractionGameScreen(),

'/money_math_game': (context)=> const MoneyMathGameScreen(),

'/time_math_game': (context)=> const TimeMathGameScreen(),


"/parent_dashboard": (_) => const ParentDashboardScreen(),

"/teacher_dashboard": (_) => const TeacherDashboardScreen(),

"/admin_dashboard": (_) => const AdminScreen(),
"/age-selection":
    (_) => const AgeSelectionScreen(),

"/settings":
    (_) => const SettingsScreen(),

};
