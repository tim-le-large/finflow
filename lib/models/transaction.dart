enum TransactionType { expense, income }

class Transaction {
  const Transaction({
    required this.id,
    required this.accountId,
    required this.categoryId,
    required this.amountCents,
    required this.note,
    required this.date,
    required this.type,
  });

  final String id;
  final String accountId;
  final String categoryId;
  final int amountCents; 
  final String note;
  final DateTime date;
  final TransactionType type;
}