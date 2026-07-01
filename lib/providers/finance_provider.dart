import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/categories.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/auth_provider.dart';
import '../repositories/finance_repository.dart';

final categoriesProvider = Provider<List<Category>>((ref) => categories);

class FinanceState {
  const FinanceState({
    required this.accounts,
    required this.transactions,
  });

  final List<Account> accounts;
  final List<Transaction> transactions;

  int balanceForAccount(String accountId) {
    final account = accounts.firstWhere((a) => a.id == accountId);
    var balance = account.initialBalanceCents;
    for (final t in transactions.where((t) => t.accountId == accountId)) {
      balance += t.type == TransactionType.income ? t.amountCents : -t.amountCents;
    }
    return balance;
  }

  int get totalBalanceCents =>
      accounts.fold(0, (sum, a) => sum + balanceForAccount(a.id));

  Map<String, int> expensesByCategoryForMonth(DateTime month) {
    final map = <String, int>{};
    for (final t in transactions) {
      if (t.type != TransactionType.expense) continue;
      if (t.date.year != month.year || t.date.month != month.month) continue;
      map[t.categoryId] = (map[t.categoryId] ?? 0) + t.amountCents;
    }
    return map;
  }

  int expensesTotalForMonth(DateTime month) {
    return expensesByCategoryForMonth(month).values.fold(0, (a, b) => a + b);
  }

  int incomeTotalForMonth(DateTime month) {
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.income &&
              t.date.year == month.year &&
              t.date.month == month.month,
        )
        .fold(0, (sum, t) => sum + t.amountCents);
  }

  List<Transaction> transactionsForMonth(DateTime month) {
    return transactions
        .where(
          (t) => t.date.year == month.year && t.date.month == month.month,
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Category? categoryById(String id, List<Category> categories) {
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }
}

class FinanceNotifier extends AsyncNotifier<FinanceState> {
  @override
  Future<FinanceState> build() async {
    final session = ref.watch(currentSessionProvider);
    if (session == null) {
      throw const FinanceAuthException('Nicht angemeldet');
    }

    ref.listen(currentSessionProvider, (previous, next) {
      if (previous?.user.id != next?.user.id) {
        ref.invalidateSelf();
      }
    });

    final repository = ref.read(financeRepositoryProvider);
    await repository.seedDemoDataIfEmpty();

    final accounts = await repository.fetchAccounts();
    final transactions = await repository.fetchTransactions();

    return FinanceState(accounts: accounts, transactions: transactions);
  }

  Future<void> addTransaction(Transaction transaction) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final optimistic = FinanceState(
      accounts: current.accounts,
      transactions: [transaction, ...current.transactions],
    );
    state = AsyncData(optimistic);

    try {
      final repository = ref.read(financeRepositoryProvider);
      final saved = await repository.insertTransaction(transaction);
      final withoutTemp = optimistic.transactions
          .where((t) => t.id != transaction.id)
          .toList();
      state = AsyncData(
        FinanceState(
          accounts: current.accounts,
          transactions: [saved, ...withoutTemp],
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncData(current);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

class FinanceAuthException implements Exception {
  const FinanceAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

final financeProvider =
    AsyncNotifierProvider<FinanceNotifier, FinanceState>(FinanceNotifier.new);
