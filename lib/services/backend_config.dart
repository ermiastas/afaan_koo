
/// Backend configuration for AfaanKoo.
///
/// Supabase and Raji backend configuration are provided using
/// --dart-define.
///
/// Example:
///
/// flutter run -d chrome \
///   --dart-define=SUPABASE_URL=https://your-project.supabase.co \
///   --dart-define=SUPABASE_PUBLISHABLE_KEY=your-publishable-key \
///   --dart-define=RAJI_API_URL=https://your-raji-backend.com
///
/// Do NOT put a Supabase secret/service_role key in this file.
///
/// The Supabase publishable key (formerly commonly called
/// the anon key) is intended for use by client applications.
/// Database security must be enforced using Supabase Auth
/// and Row Level Security.
library;

class BackendConfig {
  BackendConfig._();

  // ============================================================
  // SUPABASE PROJECT URL
  // ============================================================

  static const String supabaseUrl =
      String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue:
        'https://osjemkwxstkayhabwwgf.supabase.co',
  );

  // ============================================================
  // SUPABASE PUBLISHABLE KEY
  // ============================================================

  static const String supabasePublishableKey =
      String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue:
        'sb_publishable_xddN_UzQMAdpGxyEz_saXg_3mXUxLoS',
  );

  // ============================================================
  // RAJI AI BACKEND URL
  // ============================================================
  //
  // Example:
  //
  // --dart-define=RAJI_API_URL=https://your-raji-backend.com
  //
  // The default value is intentionally empty so that the
  // application does not accidentally connect to a fake
  // production endpoint.

  static const String rajiUrl =
      String.fromEnvironment(
    'RAJI_API_URL',
    defaultValue: '',
  );

  // ============================================================
  // BACKWARD-COMPATIBILITY ALIASES
  // ============================================================
  //
  // Existing AfaanKoo services can continue using:
  //
  // BackendConfig.url
  // BackendConfig.anonKey
  //
  // while newer code uses:
  //
  // BackendConfig.supabaseUrl
  // BackendConfig.supabasePublishableKey
  //

  static String get url => supabaseUrl;

  static String get anonKey =>
      supabasePublishableKey;

  // ============================================================
  // RAJI CONFIGURATION CHECK
  // ============================================================

  static bool get isRajiConfigured {
    final url = rajiUrl.trim();

    return url.isNotEmpty &&
        (url.startsWith('https://') ||
            url.startsWith('http://'));
  }

  // ============================================================
  // SUPABASE CONFIGURATION CHECK
  // ============================================================

  static bool get isConfigured {
    final url = supabaseUrl.trim();
    final key =
        supabasePublishableKey.trim();

    return url.isNotEmpty &&
        key.isNotEmpty &&
        url.startsWith('https://');
  }

  // ============================================================
  // OVERALL BACKEND STATUS
  // ============================================================

  static bool get hasAnyBackend {
    return isConfigured ||
        isRajiConfigured;
  }
}
