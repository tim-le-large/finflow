import 'package:finflow/config/demo_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DemoConfig', () {
    test('exposes public portfolio defaults', () {
      expect(DemoConfig.defaultEmail, 'demo@finflow.lelarge.dev');
      expect(DemoConfig.defaultPassword, isNotEmpty);
    });

    test('uses default email when DEMO_EMAIL is not set at compile time', () {
      expect(DemoConfig.email, DemoConfig.defaultEmail);
    });

    test('uses default password when DEMO_PASSWORD is not set at compile time', () {
      expect(DemoConfig.password, DemoConfig.defaultPassword);
    });

    test('demo button is always enabled for portfolio', () {
      expect(DemoConfig.isConfigured, isTrue);
    });
  });
}
