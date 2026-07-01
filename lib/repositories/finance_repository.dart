import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/demo_config.dart';
import '../data/demo_data.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../providers/auth_provider.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepository(ref.watch(supabaseClientProvider));
});

class FinanceRepository {
  FinanceRepository(this._client);

  final SupabaseClient _client;

  static const _richDemoMinTransactions = 45;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw const AuthException('Not signed in');
    }
    return id;
  }

  bool get _isDemoUser {
    if (!DemoConfig.isConfigured) return false;
    return _client.auth.currentUser?.email == DemoConfig.email;
  }

  Future<List<Account>> fetchAccounts() async {
    final rows = await _client
        .from('accounts')
        .select()
        .eq('user_id', _userId)
        .order('created_at');

    return rows
        .map(
          (row) => Account(
            id: row['id'] as String,
            name: row['name'] as String,
            initialBalanceCents: row['initial_balance_cents'] as int,
          ),
        )
        .toList();
  }

  Future<List<Transaction>> fetchTransactions() async {
    final rows = await _client
        .from('transactions')
        .select()
        .eq('user_id', _userId)
        .order('date', ascending: false);

    return rows.map(_transactionFromRow).toList();
  }

  Future<Transaction> insertTransaction(Transaction transaction) async {
    final row = await _client
        .from('transactions')
        .insert({
          'user_id': _userId,
          'account_id': transaction.accountId,
          'category_id': transaction.categoryId,
          'amount_cents': transaction.amountCents,
          'note': transaction.note,
          'date': transaction.date.toIso8601String(),
          'type': transaction.type.name,
        })
        .select()
        .single();

    return _transactionFromRow(row);
  }

  Future<void> seedDemoDataIfEmpty() async {
    final accounts = await fetchAccounts();
    final transactions =
        accounts.isEmpty ? <Transaction>[] : await fetchTransactions();

    if (_isDemoUser) {
      if (transactions.length >= _richDemoMinTransactions) return;
      if (accounts.isNotEmpty) {
        await _clearUserFinanceData();
      }
      await _insertSeed(
        accountDefs: richDemoAccounts,
        transactionDefs: richDemoTransactions,
      );
      return;
    }

    if (accounts.isNotEmpty) return;

    await _insertSeed(
      accountDefs: demoAccounts,
      transactionDefs: demoTransactions,
    );
  }

  Future<void> _clearUserFinanceData() async {
    await _client.from('transactions').delete().eq('user_id', _userId);
    await _client.from('accounts').delete().eq('user_id', _userId);
  }

  Future<void> _insertSeed({
    required List<Account> accountDefs,
    required List<Transaction> transactionDefs,
  }) async {
    final accountIds = <String, String>{};

    for (final account in accountDefs) {
      final row = await _client
          .from('accounts')
          .insert({
            'user_id': _userId,
            'name': account.name,
            'initial_balance_cents': account.initialBalanceCents,
          })
          .select()
          .single();
      accountIds[account.id] = row['id'] as String;
    }

    final seedRows = transactionDefs.map((transaction) {
      return {
        'user_id': _userId,
        'account_id': accountIds[transaction.accountId]!,
        'category_id': transaction.categoryId,
        'amount_cents': transaction.amountCents,
        'note': transaction.note,
        'date': transaction.date.toIso8601String(),
        'type': transaction.type.name,
      };
    }).toList();

    const batchSize = 100;
    for (var i = 0; i < seedRows.length; i += batchSize) {
      final end = (i + batchSize < seedRows.length) ? i + batchSize : seedRows.length;
      await _client.from('transactions').insert(seedRows.sublist(i, end));
    }
  }

  Transaction _transactionFromRow(Map<String, dynamic> row) {
    return Transaction(
      id: row['id'] as String,
      accountId: row['account_id'] as String,
      categoryId: row['category_id'] as String,
      amountCents: row['amount_cents'] as int,
      note: row['note'] as String? ?? '',
      date: DateTime.parse(row['date'] as String),
      type: TransactionType.values.byName(row['type'] as String),
    );
  }
}
