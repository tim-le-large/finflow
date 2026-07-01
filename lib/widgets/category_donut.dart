import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/categories.dart';
import '../providers/finance_provider.dart';
import 'money_text.dart';

class CategoryDonut extends StatelessWidget {
  const CategoryDonut({
    super.key,
    required this.month,
    required this.finance,
  });

  final DateTime month;
  final FinanceState finance;

  @override
  Widget build(BuildContext context) {
    final byCategory = finance.expensesByCategoryForMonth(month);
    final total = byCategory.values.fold(0, (a, b) => a + b);

    if (total == 0) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Noch keine Ausgaben in diesem Monat')),
      );
    }

    final sections = byCategory.entries.map((entry) {
      final cat = finance.categoryById(entry.key, categories);
      return PieChartSectionData(
        value: entry.value / 100,
        color: cat?.color ?? Colors.grey,
        radius: 58,
        title: '',
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 52,
                  sectionsSpace: 2,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ausgaben',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  MoneyText(
                    total,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (final entry in byCategory.entries)
              _LegendChip(
                color: finance.categoryById(entry.key, categories)?.color ??
                    Colors.grey,
                label: finance.categoryById(entry.key, categories)?.name ??
                    entry.key,
                amountCents: entry.value,
              ),
          ],
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.color,
    required this.label,
    required this.amountCents,
  });

  final Color color;
  final String label;
  final int amountCents;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 6),
          MoneyText(
            amountCents,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
