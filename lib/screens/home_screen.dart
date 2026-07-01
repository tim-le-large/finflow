import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/finance_provider.dart';
import '../providers/selected_month_provider.dart';
import '../widgets/account_chip.dart';
import '../widgets/category_donut.dart';
import '../widgets/money_text.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeAsync = ref.watch(financeProvider);

    return financeAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('FinFlow')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Daten konnten nicht geladen werden:\n$error'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(financeProvider),
                  child: const Text('Erneut versuchen'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (finance) => _HomeDashboard(finance: finance),
    );
  }
}

class _HomeDashboard extends ConsumerWidget {
  const _HomeDashboard({required this.finance});

  final FinanceState finance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final month = ref.watch(selectedMonthProvider);
    final monthLabel = DateFormat('MMMM yyyy', 'de_DE').format(month);
    final userEmail = ref.watch(currentUserProvider)?.email;

    final expenses = finance.expensesTotalForMonth(month);
    final income = finance.incomeTotalForMonth(month);
    final previousMonth = DateTime(month.year, month.month - 1);
    final previousExpenses = finance.expensesTotalForMonth(previousMonth);
    final delta = previousExpenses == 0
        ? 0
        : (((expenses - previousExpenses) / previousExpenses) * 100).round();

    final monthTransactions = finance.transactionsForMonth(month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FinFlow'),
        actions: [
          IconButton(
            tooltip: 'Vorheriger Monat',
            onPressed: () {
              ref.read(selectedMonthProvider.notifier).state =
                  DateTime(month.year, month.month - 1);
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Center(
            child: Text(
              monthLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          IconButton(
            tooltip: 'Nächster Monat',
            onPressed: () {
              ref.read(selectedMonthProvider.notifier).state =
                  DateTime(month.year, month.month + 1);
            },
            icon: const Icon(Icons.chevron_right),
          ),
          PopupMenuButton<String>(
            tooltip: 'Konto',
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) async {
              if (value == 'logout') {
                await ref.read(supabaseClientProvider).auth.signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  userEmail ?? 'Angemeldet',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Abmelden'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(financeProvider),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            _BalanceCard(totalCents: finance.totalBalanceCents),
            const SizedBox(height: 16),
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: finance.accounts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final account = finance.accounts[index];
                  return AccountChip(
                    account: account,
                    balanceCents: finance.balanceForAccount(account.id),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _MonthSummaryCard(
              expensesCents: expenses,
              incomeCents: income,
              deltaPercent: delta,
            ),
            const SizedBox(height: 24),
            Text(
              'Ausgaben nach Kategorie',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            CategoryDonut(month: month, finance: finance),
            const SizedBox(height: 28),
            Text(
              'Buchungen',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (monthTransactions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('Keine Buchungen in diesem Monat')),
              )
            else
              ...monthTransactions.map((transaction) {
                final category =
                    finance.categoryById(transaction.categoryId, categories);
                final account = finance.accounts
                    .firstWhere((a) => a.id == transaction.accountId);
                return TransactionTile(
                  transaction: transaction,
                  category: category,
                  accountName: account.name,
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddTransactionSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Buchung'),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.totalCents});

  final int totalCents;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            scheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gesamtsaldo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.85),
                ),
          ),
          const SizedBox(height: 8),
          MoneyText(
            totalCents,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Alle Konten · synchronisiert',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }
}

class _MonthSummaryCard extends StatelessWidget {
  const _MonthSummaryCard({
    required this.expensesCents,
    required this.incomeCents,
    required this.deltaPercent,
  });

  final int expensesCents;
  final int incomeCents;
  final int deltaPercent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deltaColor =
        deltaPercent > 0 ? scheme.error : const Color(0xFF00BFA5);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Ausgaben',
              cents: expensesCents,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _SummaryItem(
              label: 'Einnahmen',
              cents: incomeCents,
              valueColor: const Color(0xFF00BFA5),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'vs. Vormonat',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  '${deltaPercent > 0 ? '+' : ''}$deltaPercent %',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: deltaColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.cents,
    this.valueColor,
  });

  final String label;
  final int cents;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        MoneyText(
          cents,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
