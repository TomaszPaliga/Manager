import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/budget.dart';
import '../core/category_icons.dart';
import '../core/formatters.dart';
import '../core/widgets/empty_view.dart';
import '../core/widgets/error_view.dart';
import '../core/widgets/loading_view.dart';
import '../transactions/transactions_view_model.dart';
import 'budgets_view_model.dart';

/// Limits come from [BudgetsViewModel], spending from the shared
/// [TransactionsViewModel], so a new expense moves the bars right away.
class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetsVm = context.watch<BudgetsViewModel>();
    final transactionsVm = context.watch<TransactionsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: switch ((budgetsVm.state, transactionsVm.state)) {
        (BudgetsError(:final message), _) => ErrorView(
          message: message,
          onRetry: budgetsVm.load,
        ),
        (_, TransactionsError(:final message)) => ErrorView(
          message: message,
          onRetry: transactionsVm.load,
        ),
        (BudgetsLoading(), _) => const LoadingView(),
        (_, TransactionsLoading()) => const LoadingView(),
        (BudgetsLoaded(:final budgets), TransactionsLoaded())
            when budgets.isEmpty =>
          const EmptyView(message: 'No budgets yet.'),
        (BudgetsLoaded(:final budgets), TransactionsLoaded()) =>
          RefreshIndicator(
            onRefresh: budgetsVm.load,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                return _BudgetCard(
                  budget: budget,
                  spent: transactionsVm.spentIn(budget.category),
                );
              },
            ),
          ),
      },
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.budget, required this.spent});

  final Budget budget;
  final double spent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isOver = spent > budget.limit;
    final progress = budget.limit > 0 ? min(spent / budget.limit, 1.0) : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(budget.category.icon),
                const SizedBox(width: 8),
                Expanded(child: Text(budget.category.label)),
                Text('${formatMoney(spent)} / ${formatMoney(budget.limit)}'),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              color: isOver ? colors.error : null,
            ),
            if (isOver) ...[
              const SizedBox(height: 8),
              Text(
                'Over by ${formatMoney(spent - budget.limit)}',
                style: TextStyle(color: colors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
