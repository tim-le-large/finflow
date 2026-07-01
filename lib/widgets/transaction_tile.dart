import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import 'money_text.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.category,
    required this.accountName,
  });

  final Transaction transaction;
  final Category? category;
  final String accountName;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amount = isIncome ? transaction.amountCents : -transaction.amountCents;
    final dateLabel = DateFormat('dd.MM.', 'de_DE').format(transaction.date);
    final color = category?.color ?? Theme.of(context).colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(
          category?.icon ?? Icons.receipt_long,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        transaction.note.isNotEmpty
            ? transaction.note
            : category?.name ?? 'Buchung',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('$dateLabel · $accountName · ${category?.name ?? '—'}'),
      trailing: MoneyText(
        amount,
        showSign: true,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isIncome ? const Color(0xFF00BFA5) : null,
            ),
      ),
    );
  }
}
