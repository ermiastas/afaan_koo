class BackendConfig {
  BackendConfig._();

  // ============================================================
  // SUPABASE PROJECT URL
  // ============================================================

  static const String supabaseUrl =
      'https://osjemkwxstkayhabwwgf.supabase.co';

  // ============================================================
  // SUPABASE PUBLISHABLE KEY
  //
  // This is safe to use in the Flutter client.
  // NEVER use the Supabase secret/service_role key here.
  // ============================================================

  static const String supabasePublishableKey =
      'sb_publishable_xddN_UzQMAdpGxyEz_saXg_3mXUxLoS';

  // ============================================================
  // CONFIGURATION CHECK
  // ============================================================

  static bool get isConfigured {
    return supabaseUrl.trim().isNotEmpty &&
        supabasePublishableKey.trim().isNotEmpty &&
        supabaseUrl.startsWith('https://');
  }
}