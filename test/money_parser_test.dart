import 'package:finflow/utils/money_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseEuroInput', () {
    test('parses comma decimal', () {
      expect(parseEuroInput('12,50'), 1250);
    });

    test('parses dot decimal', () {
      expect(parseEuroInput('12.50'), 1250);
    });

    test('trims whitespace', () {
      expect(parseEuroInput('  9,99  '), 999);
    });

    test('returns 0 for invalid input', () {
      expect(parseEuroInput('abc'), 0);
      expect(parseEuroInput(''), 0);
    });

    test('rounds to nearest cent', () {
      expect(parseEuroInput('10.55'), 1055);
    });
  });
}
