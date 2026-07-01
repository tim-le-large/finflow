import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import '../utils/money_parser.dart';

Future<void> showAddTransactionSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: _AddTransactionForm(),
    ),
  );
}

class _AddTransactionForm extends ConsumerStatefulWidget {
  const _AddTransactionForm();

  @override
  ConsumerState<_AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<_AddTransactionForm> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String? _accountId;
  String _categoryId = 'food';
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<CategoryOption> get _categoryOptions {
    final categories = ref.read(categoriesProvider);
    final filtered = categories.where((c) {
      if (_type == TransactionType.income) return c.id == 'income';
      return c.id != 'income';
    });
    return filtered.map((c) => CategoryOption(c.id, c.name)).toList();
  }

  Future<void> _submit() async {
    final cents = parseEuroInput(_amountController.text);
    if (cents <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte einen gültigen Betrag eingeben')),
      );
      return;
    }

    final accountId = _accountId;
    if (accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kein Konto verfügbar')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(financeProvider.notifier).addTransaction(
            Transaction(
              id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
              accountId: accountId,
              categoryId: _categoryId,
              amountCents: cents,
              note: _noteController.text.trim(),
              date: DateTime.now(),
              type: _type,
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speichern fehlgeschlagen: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeProvider).valueOrNull;
    final accounts = finance?.accounts ?? [];
    final categoryOptions = _categoryOptions;

    if (_accountId == null && accounts.isNotEmpty) {
      _accountId = accounts.first.id;
    }

    if (!categoryOptions.any((c) => c.id == _categoryId)) {
      _categoryId = categoryOptions.first.id;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Neue Buchung',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(
                value: TransactionType.expense,
                label: Text('Ausgabe'),
                icon: Icon(Icons.remove),
              ),
              ButtonSegment(
                value: TransactionType.income,
                label: Text('Einnahme'),
                icon: Icon(Icons.add),
              ),
            ],
            selected: {_type},
            onSelectionChanged: _isSaving
                ? null
                : (selection) {
                    setState(() {
                      _type = selection.first;
                      _categoryId =
                          _type == TransactionType.income ? 'income' : 'food';
                    });
                  },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            enabled: !_isSaving,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Betrag',
              hintText: '12,99',
              prefixText: '€ ',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('account-$_accountId'),
            initialValue: _accountId,
            decoration: const InputDecoration(labelText: 'Konto'),
            items: [
              for (final account in accounts)
                DropdownMenuItem(
                  value: account.id,
                  child: Text(account.name),
                ),
            ],
            onChanged: _isSaving
                ? null
                : (value) {
                    if (value != null) setState(() => _accountId = value);
                  },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('category-$_type-$_categoryId'),
            initialValue: _categoryId,
            decoration: const InputDecoration(labelText: 'Kategorie'),
            items: [
              for (final category in categoryOptions)
                DropdownMenuItem(
                  value: category.id,
                  child: Text(category.label),
                ),
            ],
            onChanged: _isSaving
                ? null
                : (value) {
                    if (value != null) setState(() => _categoryId = value);
                  },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            enabled: !_isSaving,
            decoration: const InputDecoration(
              labelText: 'Notiz',
              hintText: 'z. B. REWE, Miete, Gehalt',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _isSaving ? null : _submit,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(_isSaving ? 'Speichern…' : 'In Supabase speichern'),
          ),
        ],
      ),
    );
  }
}

class CategoryOption {
  const CategoryOption(this.id, this.label);

  final String id;
  final String label;
}
