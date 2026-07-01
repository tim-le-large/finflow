/// Supabase credentials via compile-time environment variables.
///
/// CI (GitHub Actions): set `SUPABASE_URL` and `SUPABASE_ANON_KEY` secrets.
///
/// Local dev:
/// ```bash
/// flutter run -d chrome --dart-define-from-file=dart_defines.json
/// ```
/// Copy `dart_defines.example.json` → `dart_defines.json` and fill in values.
abstract final class SupabaseConfig {
  static String get url {
    const fromEnv = String.fromEnvironment('SUPABASE_URL');
    return _normalizeProjectUrl(fromEnv);
  }

  static String _normalizeProjectUrl(String raw) {
    var value = raw.trim();
    if (value.endsWith('/rest/v1') || value.endsWith('/rest/v1/')) {
      value = value.replaceFirst(RegExp(r'/rest/v1/?$'), '');
    }
    if (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  static String get anonKey {
    return const String.fromEnvironment('SUPABASE_ANON_KEY');
  }

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
