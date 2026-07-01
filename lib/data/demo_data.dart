import '../models/account.dart';
import '../models/transaction.dart';

const demoAccounts = <Account>[
  Account(id: 'giro', name: 'Girokonto', initialBalanceCents: 245000),
  Account(id: 'card', name: 'Kreditkarte', initialBalanceCents: 0),
];

/// Default seed for new non-demo users (first sign-up).
final demoTransactions = buildStandardDemoTransactions();

/// Rich portfolio dataset for the shared demo account.
final richDemoAccounts = <Account>[
  Account(id: 'giro', name: 'Girokonto', initialBalanceCents: 245000),
  Account(id: 'card', name: 'Kreditkarte', initialBalanceCents: 0),
  Account(id: 'savings', name: 'Tagesgeld', initialBalanceCents: 150000),
  Account(id: 'cash', name: 'Bargeld', initialBalanceCents: 5000),
];

final richDemoTransactions = buildRichDemoTransactions();

List<Transaction> buildStandardDemoTransactions() {
  return [
    Transaction(
      id: '1',
      accountId: 'giro',
      categoryId: 'income',
      amountCents: 320000,
      note: 'Gehalt',
      date: DateTime(2026, 6, 1),
      type: TransactionType.income,
    ),
    Transaction(
      id: '2',
      accountId: 'giro',
      categoryId: 'housing',
      amountCents: 85000,
      note: 'Miete',
      date: DateTime(2026, 6, 3),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '3',
      accountId: 'giro',
      categoryId: 'subs',
      amountCents: 1299,
      note: 'Netflix',
      date: DateTime(2026, 6, 5),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '4',
      accountId: 'giro',
      categoryId: 'subs',
      amountCents: 1099,
      note: 'Spotify',
      date: DateTime(2026, 6, 5),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '5',
      accountId: 'card',
      categoryId: 'food',
      amountCents: 4720,
      note: 'REWE',
      date: DateTime(2026, 6, 8),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '6',
      accountId: 'card',
      categoryId: 'food',
      amountCents: 3180,
      note: 'EDEKA',
      date: DateTime(2026, 6, 12),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '7',
      accountId: 'card',
      categoryId: 'transport',
      amountCents: 290,
      note: 'KVV',
      date: DateTime(2026, 6, 9),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '8',
      accountId: 'card',
      categoryId: 'fun',
      amountCents: 1850,
      note: 'Café',
      date: DateTime(2026, 6, 10),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '9',
      accountId: 'card',
      categoryId: 'fun',
      amountCents: 4200,
      note: 'Restaurant',
      date: DateTime(2026, 6, 18),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '10',
      accountId: 'giro',
      categoryId: 'transport',
      amountCents: 4900,
      note: 'DB Ticket',
      date: DateTime(2026, 6, 22),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '11',
      accountId: 'card',
      categoryId: 'food',
      amountCents: 6200,
      note: 'REWE',
      date: DateTime(2026, 5, 14),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '12',
      accountId: 'giro',
      categoryId: 'housing',
      amountCents: 85000,
      note: 'Miete',
      date: DateTime(2026, 5, 3),
      type: TransactionType.expense,
    ),
  ];
}

List<Transaction> buildRichDemoTransactions() {
  final transactions = <Transaction>[];
  var id = 1;

  void add({
    required String accountId,
    required String categoryId,
    required int amountCents,
    required String note,
    required DateTime date,
    required TransactionType type,
  }) {
    transactions.add(
      Transaction(
        id: '${id++}',
        accountId: accountId,
        categoryId: categoryId,
        amountCents: amountCents,
        note: note,
        date: date,
        type: type,
      ),
    );
  }

  for (final month in [4, 5, 6, 7]) {
    add(
      accountId: 'giro',
      categoryId: 'income',
      amountCents: 320000,
      note: 'Gehalt',
      date: DateTime(2026, month, 1),
      type: TransactionType.income,
    );
    add(
      accountId: 'giro',
      categoryId: 'income',
      amountCents: 45000,
      note: 'Nebenprojekt',
      date: DateTime(2026, month, 15),
      type: TransactionType.income,
    );
    add(
      accountId: 'giro',
      categoryId: 'housing',
      amountCents: 85000,
      note: 'Miete',
      date: DateTime(2026, month, 3),
      type: TransactionType.expense,
    );
    add(
      accountId: 'giro',
      categoryId: 'housing',
      amountCents: 12000,
      note: 'Strom',
      date: DateTime(2026, month, 8),
      type: TransactionType.expense,
    );
    add(
      accountId: 'giro',
      categoryId: 'subs',
      amountCents: 1299,
      note: 'Netflix',
      date: DateTime(2026, month, 5),
      type: TransactionType.expense,
    );
    add(
      accountId: 'giro',
      categoryId: 'subs',
      amountCents: 1099,
      note: 'Spotify',
      date: DateTime(2026, month, 5),
      type: TransactionType.expense,
    );
    add(
      accountId: 'giro',
      categoryId: 'subs',
      amountCents: 999,
      note: 'iCloud',
      date: DateTime(2026, month, 6),
      type: TransactionType.expense,
    );
    add(
      accountId: 'giro',
      categoryId: 'subs',
      amountCents: 1999,
      note: 'Cursor Pro',
      date: DateTime(2026, month, 7),
      type: TransactionType.expense,
    );
  }

  final groceries = [
    ('REWE', 4720),
    ('EDEKA', 3180),
    ('Lidl', 2890),
    ('Aldi', 2340),
    ('Bio-Shop', 5670),
  ];
  final cafes = [
    ('Café', 1850),
    ('Bäckerei', 420),
    ('Restaurant', 4200),
    ('Kino', 2800),
    ('Bowling', 3500),
  ];
  final transport = [
    ('KVV Monatsticket', 8900),
    ('DB ICE', 4900),
    ('Uber', 1650),
    ('Tankstelle', 7200),
  ];

  for (var month = 4; month <= 7; month++) {
    for (var i = 0; i < groceries.length; i++) {
      add(
        accountId: i.isEven ? 'card' : 'cash',
        categoryId: 'food',
        amountCents: groceries[i].$2 + (month * 10),
        note: groceries[i].$1,
        date: DateTime(2026, month, 4 + i * 2),
        type: TransactionType.expense,
      );
    }
    for (var i = 0; i < cafes.length; i++) {
      add(
        accountId: 'card',
        categoryId: 'fun',
        amountCents: cafes[i].$2,
        note: cafes[i].$1,
        date: DateTime(2026, month, 10 + i * 3),
        type: TransactionType.expense,
      );
    }
    for (var i = 0; i < transport.length; i++) {
      add(
        accountId: i == 3 ? 'giro' : 'card',
        categoryId: 'transport',
        amountCents: transport[i].$2,
        note: transport[i].$1,
        date: DateTime(2026, month, 6 + i * 4),
        type: TransactionType.expense,
      );
    }
    add(
      accountId: 'savings',
      categoryId: 'income',
      amountCents: 50000,
      note: 'Zinsen',
      date: DateTime(2026, month, 28),
      type: TransactionType.income,
    );
    add(
      accountId: 'giro',
      categoryId: 'income',
      amountCents: 25000,
      note: 'Sparplan',
      date: DateTime(2026, month, 25),
      type: TransactionType.expense,
    );
  }

  return transactions;
}
