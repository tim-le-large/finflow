import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw const AuthException('Not signed in');
    }
    return id;
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
    final existing = await fetchAccounts();
    if (existing.isNotEmpty) return;

    final giroRow = await _client
        .from('accounts')
        .insert({
          'user_id': _userId,
          'name': 'Girokonto',
          'initial_balance_cents': 245000,
        })
        .select()
        .single();

    final cardRow = await _client
        .from('accounts')
        .insert({
          'user_id': _userId,
          'name': 'Kreditkarte',
          'initial_balance_cents': 0,
        })
        .select()
        .single();

    final accountIds = {
      'giro': giroRow['id'] as String,
      'card': cardRow['id'] as String,
    };

    final seedRows = demoTransactions.map((transaction) {
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

    await _client.from('transactions').insert(seedRows);
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
