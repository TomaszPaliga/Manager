import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_view_model.dart';
import '../core/formatters.dart';
import '../core/widgets/empty_view.dart';
import '../core/widgets/error_view.dart';
import '../core/widgets/loading_view.dart';
import '../core/widgets/transaction_tile.dart';
import '../transactions/transaction_details_screen.dart';
import '../transactions/transactions_view_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthViewModel>().logout(),
          ),
        ],
      ),
      body: switch (vm.state) {
        TransactionsLoading() => const LoadingView(),
        TransactionsError(:final message) => ErrorView(
          message: message,
          onRetry: vm.load,
        ),
        TransactionsLoaded(:final transactions) when transactions.isEmpty =>
          const EmptyView(message: 'No transactions yet.'),
        TransactionsLoaded() => RefreshIndicator(
          onRefresh: vm.load,
          child: _DashboardContent(vm: vm),
        ),
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.vm});

  final TransactionsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Total Balance',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          formatMoney(vm.balance),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Income',
                amount: vm.totalIncome,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Expenses',
                amount: vm.totalExpenses,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final transaction in vm.recent())
          TransactionTile(
            transaction: transaction,
            onTap: () {
              Navigator.of(
                context,
              ).push(TransactionDetailsScreen.route(transaction.id));
            },
          ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label),
            const SizedBox(height: 4),
            Text(
              formatMoney(amount),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
