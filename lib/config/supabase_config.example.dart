/// Copy to `supabase_config.dart` and fill in your project credentials.
/// Get them from: Supabase Dashboard → Project Settings → API Keys
abstract final class SupabaseConfig {
  static const _localUrl = '';
  static const _localAnonKey = '';

  static String get url {
    const fromEnv = String.fromEnvironment('SUPABASE_URL');
    final raw = fromEnv.isNotEmpty ? fromEnv : _localUrl;
    return _normalizeProjectUrl(raw);
  }

  static String get anonKey {
    const fromEnv = String.fromEnvironment('SUPABASE_ANON_KEY');
    return fromEnv.isNotEmpty ? fromEnv : _localAnonKey;
  }

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

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
}
