import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/empty_view.dart';
import '../core/widgets/error_view.dart';
import '../core/widgets/loading_view.dart';
import '../core/widgets/transaction_tile.dart';
import 'transaction_details_screen.dart';
import 'transaction_form_screen.dart';
import 'transactions_view_model.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: vm.state is TransactionsLoaded
          ? FloatingActionButton(
              tooltip: 'Add transaction',
              onPressed: () {
                Navigator.of(context).push(TransactionFormScreen.route());
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: switch (vm.state) {
        TransactionsLoading() => const LoadingView(),
        TransactionsError(:final message) => ErrorView(
          message: message,
          onRetry: vm.load,
        ),
        TransactionsLoaded(:final transactions) when transactions.isEmpty =>
          const EmptyView(message: 'No transactions yet. Tap + to add one.'),
        TransactionsLoaded(:final transactions) => RefreshIndicator(
          onRefresh: vm.load,
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionTile(
                transaction: transaction,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(TransactionDetailsScreen.route(transaction.id));
                },
              );
            },
          ),
        ),
      },
    );
  }
}
