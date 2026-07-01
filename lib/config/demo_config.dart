import 'supabase_config.dart';

/// Public demo account for the portfolio live site.
/// Override via `--dart-define` or `dart_defines.json` if needed.
abstract final class DemoConfig {
  static const String defaultEmail = 'demo@finflow.lelarge.dev';
  static const String defaultPassword = 'FinFlowDemo2026!';

  static String get email {
    const fromEnv = String.fromEnvironment('DEMO_EMAIL');
    return fromEnv.isNotEmpty ? fromEnv : defaultEmail;
  }

  static String get password {
    const fromEnv = String.fromEnvironment('DEMO_PASSWORD');
    return fromEnv.isNotEmpty ? fromEnv : defaultPassword;
  }

  /// Show demo button when Supabase is configured (demo creds have public defaults).
  static bool get isConfigured => SupabaseConfig.isConfigured;
}
