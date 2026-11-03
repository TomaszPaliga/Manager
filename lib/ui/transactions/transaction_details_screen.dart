import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/transaction.dart';
import '../core/category_icons.dart';
import '../core/formatters.dart';
import '../core/widgets/empty_view.dart';
import '../core/widgets/error_view.dart';
import '../core/widgets/loading_view.dart';
import 'transaction_form_screen.dart';
import 'transactions_view_model.dart';

/// Receives only the id and reads the transaction from the shared view model,
/// so an edit made in the form shows up here at once.
class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key, required this.transactionId});

  final String transactionId;

  static Route<void> route(String transactionId) {
    return MaterialPageRoute<void>(
      builder: (_) => TransactionDetailsScreen(transactionId: transactionId),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final vm = context.read<TransactionsViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    navigator.pop();
    final deleted = await vm.delete(transactionId);
    if (!deleted) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not delete the transaction.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionsViewModel>();
    final transaction = vm.transactionById(transactionId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        actions: [
          if (transaction != null) ...[
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  TransactionFormScreen.route(transactionId: transactionId),
                );
              },
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ],
      ),
      body: switch (vm.state) {
        TransactionsLoading() => const LoadingView(),
        TransactionsError(:final message) => ErrorView(
          message: message,
          onRetry: vm.load,
        ),
        TransactionsLoaded() =>
          transaction == null
              ? const EmptyView(message: 'This transaction no longer exists.')
              : _TransactionDetails(transaction: transaction),
      },
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  const _TransactionDetails({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final note = transaction.note;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          formatSignedMoney(transaction.signedAmount),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          transaction.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: Icon(transaction.category.icon),
          title: const Text('Category'),
          subtitle: Text(transaction.category.label),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date'),
          subtitle: Text(formatDate(transaction.date)),
        ),
        ListTile(
          leading: const Icon(Icons.swap_vert),
          title: const Text('Type'),
          subtitle: Text(isIncome ? 'Income' : 'Expense'),
        ),
        if (note != null)
          ListTile(
            leading: const Icon(Icons.notes),
            title: const Text('Note'),
            subtitle: Text(note),
          ),
      ],
    );
  }
}
