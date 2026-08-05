import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'backend_config.dart';

class SupabaseService {
  SupabaseService._();

  /// Returns true only when the app has valid Supabase configuration.
  static bool get isAvailable => BackendConfig.isConfigured;

  /// Safe client getter.
  ///
  /// Returns null when Supabase is not configured instead of throwing.
  static SupabaseClient? get client {
    if (!isAvailable) {
      return null;
    }

    try {
      return Supabase.instance.client;
    } catch (e) {
      debugPrint('Supabase client unavailable: $e');
      return null;
    }
  }

  /// Current authenticated user.
  static User? get currentUser {
    final c = client;
    if (c == null) return null;
    return c.auth.currentUser;
  }

  /// Current user ID.
  static String? get userId => currentUser?.id;

  /// Whether a user is signed in.
  static bool get isSignedIn => currentUser != null;
}