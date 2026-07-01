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

  /// Portfolio demo is always available (public credentials with compile-time overrides).
  static bool get isConfigured => true;
}
