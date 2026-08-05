import 'package:flutter/material.dart';

import '../models/lesson_category.dart';
import '../models/lesson_item.dart';

// Screens
import '../screens/alphabet_menu_screen.dart';
import '../screens/number_screen.dart';
import '../screens/word_screen.dart';

import '../screens/animal_screen.dart';
import '../screens/plant_screen.dart';
import '../screens/weather_screen.dart';

import '../screens/body_screen.dart';
import '../screens/food_screen.dart';
import '../screens/hygiene_screen.dart';

import '../screens/traffic_screen.dart';
import '../screens/environment_screen.dart';

import '../screens/oromo_culture_screen.dart';
import '../screens/story_screen.dart';
import '../screens/hibboo_screen.dart';
import '../screens/mammaaksa_screen.dart';

final List<LessonCategory> categories = [

  /// ===============================
  /// Afaan fi Lakkoofsa
  /// ===============================
  LessonCategory(
    title: "Afaan fi Lakkoofsa",
    subtitle: "Qubee, Lakkoofsa fi Jechoota",
    emoji: "🔤",
    color: Colors.orange,
    lessons: [

      LessonItem(
        id: "alphabet",
        title: "Qubee Koo",
        description: "Qubee Afaan Oromoo baradhu",
        emoji: "🔤",
        icon: Icons.abc,
        color: Colors.orange,
        screen: const AlphabetMenuScreen(),
      ),

      LessonItem(
        id: "numbers",
        title: "Lakkoofsa Koo",
        description: "Lakkoofsa baradhu",
        emoji: "🔢",
        icon: Icons.numbers,
        color: Colors.blue,
        screen: const NumberScreen(),
      ),

      LessonItem(
        id: "words",
        title: "Jechoota Koo",
        description: "Jechoota haaraa baradhu",
        emoji: "📝",
        icon: Icons.menu_book,
        color: Colors.green,
        screen: const WordScreen(),
      ),
    ],
  ),

  /// ===============================
  /// Uumama
  /// ===============================
  LessonCategory(
    title: "Uumama",
    subtitle: "Bineensa, Biqiltuu fi Haala Qilleensaa",
    emoji: "🐾",
    color: Colors.green,
    lessons: [

      LessonItem(
        id: "animals",
        title: "Bineensa Koo",
        description: "Maqaa bineensotaa baradhu",
        emoji: "🐾",
        icon: Icons.pets,
        color: Colors.green,
        screen: const AnimalScreen(),
      ),

      LessonItem(
        id: "plants",
        title: "Biqiltuu Koo",
        description: "Biqiltuu adda addaa baradhu",
        emoji: "🌱",
        icon: Icons.park,
        color: Colors.green,
        screen: const PlantScreen(),
      ),

      LessonItem(
        id: "weather",
        title: "Haala Qilleensaa",
        description: "Qilleensa adda addaa baradhu",
        emoji: "⛅",
        icon: Icons.cloud,
        color: Colors.lightBlue,
        screen: const WeatherScreen(),
      ),
    ],
  ),

  /// ===============================
  /// Jireenya Guyyaa Guyyaa
  /// ===============================
  LessonCategory(
    title: "Jireenya Guyyaa Guyyaa",
    subtitle: "Qaama fi Nyaata",
    emoji: "🏠",
    color: Colors.blue,
    lessons: [

      LessonItem(
        id: "body",
        title: "Qaama Koo",
        description: "Qaama namaa baradhu",
        emoji: "🧍",
        icon: Icons.accessibility_new,
        color: Colors.pink,
        screen: const BodyScreen(),
      ),

      LessonItem(
        id: "food",
        title: "Nyaataa fi Dhugaatii",
        description: "Nyaata adda addaa baradhu",
        emoji: "🍽️",
        icon: Icons.restaurant,
        color: Colors.red,
        screen: const FoodScreen(),
      ),
    ],
  ),

  /// ===============================
  /// Fayyaa fi Nageenya
  /// ===============================
  LessonCategory(
    title: "Fayyaa fi Nageenya",
    subtitle: "Qulqullinaa fi Of Eeggannoo",
    emoji: "❤️",
    color: Colors.red,
    lessons: [

      LessonItem(
        id: "hygiene",
        title: "Qulqullina Qaamaa",
        description: "Qulqullina qaamaa baradhu",
        emoji: "🧼",
        icon: Icons.clean_hands,
        color: Colors.blue,
        screen: const HygieneScreen(),
      ),

      LessonItem(
        id: "traffic",
        title: "Nageenya Daandii",
        description: "Mallattoo daandii baradhu",
        emoji: "🚦",
        icon: Icons.traffic,
        color: Colors.orange,
        screen: const TrafficScreen(),
      ),

      LessonItem(
        id: "environment",
        title: "Naannoo Koo",
        description: "Naannoo keenya kunuunsi",
        emoji: "🌍",
        icon: Icons.eco,
        color: Colors.green,
        screen: const EnvironmentScreen(),
      ),
    ],
  ),

  /// ===============================
  /// Aadaa Oromoo
  /// ===============================
  LessonCategory(
    title: "Aadaa Oromoo",
    subtitle: "Seenaa fi Safuu Oromoo",
    emoji: "🎭",
    color: Colors.brown,
    lessons: [

      LessonItem(
        id: "culture",
        title: "Aadaa Oromoo",
        description: "Aadaa Oromoo baradhu",
        emoji: "🏛️",
        icon: Icons.account_balance,
        color: Colors.brown,
        screen: const OromoCultureScreen(),
      ),

      LessonItem(
        id: "stories",
        title: "Oduu Durii",
        description: "Oduu durii dubbisi",
        emoji: "📖",
        icon: Icons.menu_book,
        color: Colors.brown,
        screen: const StoryScreen(),
      ),

      LessonItem(
        id: "hibboo",
        title: "Hibboo",
        description: "Hibboo hiiki",
        emoji: "💡",
        icon: Icons.lightbulb,
        color: Colors.amber,
        screen: const HibbooScreen(),
      ),

      LessonItem(
        id: "mammaaksa",
        title: "Mammaaksa",
        description: "Mammaaksa Oromoo baradhu",
        emoji: "🗣️",
        icon: Icons.record_voice_over,
        color: Colors.brown,
        screen: const MammaaksaScreen(),
      ),
    ],
  ),
];