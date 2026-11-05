import 'package:flutter/foundation.dart';

import '../../data/repositories/transaction_repository.dart';
import '../../domain/models/transaction.dart';

// Always exactly one of these, the screens switch on it
sealed class TransactionsState {
  const TransactionsState();
}

final class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

final class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded(this.transactions);

  final List<Transaction> transactions;
}

final class TransactionsError extends TransactionsState {
  const TransactionsError(this.message);

  final String message;
}

// One instance for the whole app. Dashboard, list, details, form and budgets
// all read from it, that's why a change on one screen shows up on the others
class TransactionsViewModel extends ChangeNotifier {
  TransactionsViewModel(this._repository);

  final TransactionRepository _repository;

  TransactionsState _state = const TransactionsLoading();
  bool _disposed = false;

  TransactionsState get state => _state;

  // Newest first, empty until the data has loaded
  List<Transaction> get transactions {
    final current = _state;
    return current is TransactionsLoaded
        ? current.transactions
        : const <Transaction>[];
  }

  double get balance =>
      transactions.fold<double>(0, (sum, t) => sum + t.signedAmount);

  double get totalIncome => _sumOf(TransactionType.income);

  double get totalExpenses => _sumOf(TransactionType.expense);

  List<Transaction> recent({int count = 5}) =>
      transactions.take(count).toList();

  Transaction? transactionById(String id) {
    for (final transaction in transactions) {
      if (transaction.id == id) {
        return transaction;
      }
    }
    return null;
  }

  // For the budgets screen, only counts expenses
  double spentIn(TransactionCategory category) {
    return transactions
        .where(
          (t) => t.type == TransactionType.expense && t.category == category,
        )
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  Future<void> load() async {
    _setState(const TransactionsLoading());
    try {
      final fetched = await _repository.fetchTransactions();
      _setState(TransactionsLoaded(_newestFirst(fetched)));
    } catch (_) {
      _setState(const TransactionsError('Could not load transactions.'));
    }
  }

  // add and update return false if saving failed, the form shows a SnackBar
  Future<bool> add(Transaction transaction) async {
    try {
      final saved = await _repository.addTransaction(transaction);
      _changeList((list) => [...list, saved]);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> update(Transaction transaction) async {
    try {
      final saved = await _repository.updateTransaction(transaction);
      _changeList((list) {
        return [
          for (final item in list)
            if (item.id == saved.id) saved else item,
        ];
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  // Removes it right away so the UI feels instant, puts it back if the
  // request fails
  Future<bool> delete(String id) async {
    final removed = transactionById(id);
    if (removed == null) {
      return false;
    }
    _changeList((list) => list.where((t) => t.id != id).toList());
    try {
      await _repository.deleteTransaction(id);
      return true;
    } catch (_) {
      _changeList((list) => [...list, removed]);
      return false;
    }
  }

  double _sumOf(TransactionType type) {
    return transactions
        .where((t) => t.type == type)
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  // Always a new list, never change the old one in place
  void _changeList(List<Transaction> Function(List<Transaction>) change) {
    final current = _state;
    if (current is TransactionsLoaded) {
      final changed = change(current.transactions);
      _setState(TransactionsLoaded(_newestFirst(changed)));
    }
  }

  List<Transaction> _newestFirst(List<Transaction> transactions) {
    final sorted = [...transactions]
      ..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  void _setState(TransactionsState state) {
    _state = state;
    // The screen can be gone by the time a request finishes
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
