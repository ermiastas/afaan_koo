import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

import 'providers/admin_provider.dart';
import 'providers/age_provider.dart';
import 'providers/assignment_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/class_provider.dart';
import 'providers/game_provider.dart';
import 'providers/learning_path_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/mammaaksa_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/reward_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/teacher_provider.dart';
import 'providers/user_provider.dart';

import 'services/backend_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------
  // Initialize Supabase (only if configured)
  // ---------------------------------------------------

  if (BackendConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: BackendConfig.url,
        publishableKey: BackendConfig.anonKey,
      );

      debugPrint("✅ Supabase initialized.");
    } catch (e, s) {
      debugPrint("❌ Failed to initialize Supabase");
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  } else {
    debugPrint(
      "⚠️ Supabase is not configured. Running in LOCAL mode.",
    );
  }

  // ---------------------------------------------------
  // Create providers
  // ---------------------------------------------------

  final progressProvider = ProgressProvider();
  final rewardProvider = RewardProvider();
  final profileProvider = ProfileProvider();
  final settingsProvider = SettingsProvider();

  // ---------------------------------------------------
  // Load local data
  // ---------------------------------------------------

  try {
    await progressProvider.load();
  } catch (e) {
    debugPrint("Progress load failed: $e");
  }

  try {
    await rewardProvider.load();
  } catch (e) {
    debugPrint("Reward load failed: $e");
  }

  try {
    await profileProvider.load();
  } catch (e) {
    debugPrint("Profile load failed: $e");
  }

  try {
    await settingsProvider.load();
  } catch (e) {
    debugPrint("Settings load failed: $e");
  }

  // ---------------------------------------------------
  // Start App
  // ---------------------------------------------------

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        
        ChangeNotifierProvider(
          create: (_) => AgeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => TeacherProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AssignmentProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => LessonProvider(),
        ),


             ChangeNotifierProvider(
  create: (_) => MammaaksaProvider(),
),


        ChangeNotifierProvider(
          create: (_) => LearningPathProvider(),
        ),

        ChangeNotifierProvider.value(
          value: profileProvider,
        ),

        ChangeNotifierProvider.value(
          value: progressProvider,
        ),

        ChangeNotifierProvider.value(
          value: rewardProvider,
        ),

        ChangeNotifierProvider.value(
          value: settingsProvider,
        ),

        ChangeNotifierProvider(
          create: (_) => GameProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) {
            final provider = ClassProvider();
            provider.loadClasses();
            return provider;
          },
        ),

        ChangeNotifierProvider(
          create: (_) => AdminProvider(),
        ),
      ],

      child: const AfaanKooApp(),
    ),
  );
}
