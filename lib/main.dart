import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ai/raji/services/raji_speech_service.dart';
import 'app/app.dart';

// =====================================================
// EXISTING PROVIDERS
// =====================================================

import 'providers/admin_provider.dart';
import 'providers/age_provider.dart';
import 'providers/assignment_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/class_provider.dart';
import 'providers/coloring_catalog_provider.dart';
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
import 'providers/video_catalog_provider.dart';

// =====================================================
// RAJI AI
// =====================================================

import 'ai/raji/providers/raji_provider.dart';
import 'ai/raji/services/raji_client.dart';

// =====================================================
// SERVICES
// =====================================================

import 'services/backend_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RajiSpeechService.initialize();

  // ===================================================
  // INITIALIZE SUPABASE
  // ===================================================

  if (BackendConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: BackendConfig.url,
        publishableKey: BackendConfig.anonKey,
      );

      debugPrint('✅ Supabase initialized.');
    } catch (e, s) {
      debugPrint('❌ Failed to initialize Supabase');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $s');
    }
  } else {
    debugPrint(
      '⚠️ Supabase is not configured. '
      'Running in LOCAL mode.',
    );
  }

  // ===================================================
  // CREATE PERSISTENT PROVIDERS
  // ===================================================

  final progressProvider = ProgressProvider();
  final rewardProvider = RewardProvider();
  final profileProvider = ProfileProvider();
  final settingsProvider = SettingsProvider();

  // ===================================================
  // LOAD LOCAL / CLOUD DATA
  // ===================================================

  try {
    await progressProvider.load();
  } catch (e) {
    debugPrint(
      '⚠️ Progress load failed: $e',
    );
  }

  try {
    await rewardProvider.load();
  } catch (e) {
    debugPrint(
      '⚠️ Reward load failed: $e',
    );
  }

  try {
    await profileProvider.load();
  } catch (e) {
    debugPrint(
      '⚠️ Profile load failed: $e',
    );
  }

  try {
    await settingsProvider.load();
  } catch (e) {
    debugPrint(
      '⚠️ Settings load failed: $e',
    );
  }

  // ===================================================
  // START AFAANKOO
  // ===================================================

  runApp(
    MultiProvider(
      providers: [
        // =================================================
        // USER
        // =================================================

        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),

        // =================================================
        // AGE
        // =================================================

        ChangeNotifierProvider(
          create: (_) => AgeProvider(),
        ),

        // Shared educational image catalog and offline colouring cache.
        ChangeNotifierProvider(
          create: (_) => ColoringCatalogProvider(),
        ),

        // =================================================
        // AUTH
        // =================================================

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        // =================================================
        // TEACHER
        // =================================================

        ChangeNotifierProvider(
          create: (_) => TeacherProvider(),
        ),

        // =================================================
        // ASSIGNMENTS
        // =================================================

        ChangeNotifierProvider(
          create: (_) => AssignmentProvider(),
        ),

        // =================================================
        // LESSONS
        // =================================================

        ChangeNotifierProvider(
          create: (_) => LessonProvider(),
        ),

        // =================================================
        // MAMMAAKSA
        // =================================================

        ChangeNotifierProvider(
          create: (_) => MammaaksaProvider(),
        ),

        // =================================================
        // LEARNING PATH
        // =================================================

        ChangeNotifierProvider(
          create: (_) => LearningPathProvider(),
        ),

        // =================================================
        // PROFILE
        // =================================================

        ChangeNotifierProvider.value(
          value: profileProvider,
        ),

        // =================================================
        // PROGRESS
        // =================================================

        ChangeNotifierProvider.value(
          value: progressProvider,
        ),

        // =================================================
        // REWARDS
        // =================================================

        ChangeNotifierProvider.value(
          value: rewardProvider,
        ),

        // =================================================
        // SETTINGS
        // =================================================

        ChangeNotifierProvider.value(
          value: settingsProvider,
        ),

        // =================================================
        // GAMES
        // =================================================

        ChangeNotifierProvider(
          create: (_) => GameProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => VideoCatalogProvider()..load(),
        ),

        // =================================================
        // CLASSES
        // =================================================

        ChangeNotifierProvider(
          create: (_) {
            final provider = ClassProvider();

            provider.loadClasses();

            return provider;
          },
        ),

        // =================================================
        // ADMIN
        // =================================================

        ChangeNotifierProvider(
          create: (_) => AdminProvider(),
        ),

        // =================================================
        // RAJI AI ASSISTANT
        // =================================================

        ChangeNotifierProvider(
          create: (_) {
            final client = RajiClient(
              baseUrl: BackendConfig.rajiUrl,
            );

            return RajiProvider(
              client: client,
            );
          },
        ),
      ],

      // =================================================
      // ROOT APP
      // =================================================

      child: const AfaanKooApp(),
    ),
  );
}
