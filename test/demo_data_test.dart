import 'package:finflow/data/demo_data.dart';
import 'package:finflow/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('demo seed data', () {
    test('standard dataset has 12 transactions', () {
      expect(demoTransactions, hasLength(12));
    });

    test('rich dataset has four accounts', () {
      expect(richDemoAccounts, hasLength(4));
    });

    test('rich dataset has enough transactions for demo reseed threshold', () {
      expect(richDemoTransactions.length, greaterThanOrEqualTo(45));
    });

    test('rich transactions span income and expense types', () {
      final types = richDemoTransactions.map((t) => t.type).toSet();
      expect(types, contains(TransactionType.income));
      expect(types, contains(TransactionType.expense));
    });
  });
}
