import 'dart:math';

import '../../domain/models/transaction.dart';
import 'fake_network.dart';
import 'transaction_repository.dart';

// Keeps everything in memory, so changes are gone after a restart
// Pass initialTransactions: const [] to check the empty screens
class FakeTransactionRepository implements TransactionRepository {
  FakeTransactionRepository({
    Duration delay = const Duration(milliseconds: 800),
    double failureRate = 0.0,
    Random? random,
    List<Transaction>? initialTransactions,
  }) : _network = FakeNetwork(
         delay: delay,
         failureRate: failureRate,
         random: random,
       ),
       _transactions = List.of(initialTransactions ?? _seedTransactions());

  final FakeNetwork _network;
  final List<Transaction> _transactions;
  int _nextId = 1;

  @override
  Future<List<Transaction>> fetchTransactions() async {
    await _network.simulateRequest();
    // Read only copy so nobody changes our list from outside
    return List.unmodifiable(_transactions);
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    await _network.simulateRequest();
    // A real server would generate the id
    final saved = transaction.copyWith(id: 'new-${_nextId++}');
    _transactions.add(saved);
    return saved;
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    await _network.simulateRequest();
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index == -1) {
      throw StateError('Unknown transaction: ${transaction.id}');
    }
    _transactions[index] = transaction;
    return transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _network.simulateRequest();
    _transactions.removeWhere((t) => t.id == id);
  }

  // Same data as the old home screen, the opening balance is there so the
  // total still comes out to $5,240.50
  static List<Transaction> _seedTransactions() {
    return [
      Transaction(
        id: 'tx-1',
        title: 'Opening balance',
        amount: 3703.29,
        type: TransactionType.income,
        category: TransactionCategory.other,
        date: DateTime(2026, 10, 1),
      ),
      Transaction(
        id: 'tx-2',
        title: 'Paycheck',
        amount: 2000.00,
        type: TransactionType.income,
        category: TransactionCategory.salary,
        date: DateTime(2026, 10, 2),
      ),
      Transaction(
        id: 'tx-3',
        title: 'Electric Bill',
        amount: 85.00,
        type: TransactionType.expense,
        category: TransactionCategory.bills,
        date: DateTime(2026, 10, 4),
      ),
      Transaction(
        id: 'tx-4',
        title: 'Gym Membership',
        amount: 50.00,
        type: TransactionType.expense,
        category: TransactionCategory.health,
        date: DateTime(2026, 10, 6),
      ),
      Transaction(
        id: 'tx-5',
        title: 'Streaming Service',
        amount: 15.99,
        type: TransactionType.expense,
        category: TransactionCategory.subscriptions,
        date: DateTime(2026, 10, 8),
      ),
      Transaction(
        id: 'tx-6',
        title: 'Clothing',
        amount: 120.00,
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
        date: DateTime(2026, 10, 12),
      ),
      Transaction(
        id: 'tx-7',
        title: 'Pet Food',
        amount: 40.00,
        type: TransactionType.expense,
        category: TransactionCategory.pets,
        date: DateTime(2026, 10, 15),
      ),
      Transaction(
        id: 'tx-8',
        title: 'Venmo Transfer',
        amount: 25.00,
        type: TransactionType.income,
        category: TransactionCategory.other,
        date: DateTime(2026, 10, 18),
      ),
      Transaction(
        id: 'tx-9',
        title: 'Movie Tickets',
        amount: 30.00,
        type: TransactionType.expense,
        category: TransactionCategory.entertainment,
        date: DateTime(2026, 10, 21),
      ),
      Transaction(
        id: 'tx-10',
        title: 'Restaurant',
        amount: 62.30,
        type: TransactionType.expense,
        category: TransactionCategory.eatingOut,
        date: DateTime(2026, 10, 24),
      ),
      Transaction(
        id: 'tx-11',
        title: 'Gas',
        amount: 35.00,
        type: TransactionType.expense,
        category: TransactionCategory.transport,
        date: DateTime(2026, 10, 27),
      ),
      Transaction(
        id: 'tx-12',
        title: 'Coffee',
        amount: 4.50,
        type: TransactionType.expense,
        category: TransactionCategory.eatingOut,
        date: DateTime(2026, 10, 29),
      ),
      Transaction(
        id: 'tx-13',
        title: 'Groceries',
        amount: 45.00,
        type: TransactionType.expense,
        category: TransactionCategory.groceries,
        date: DateTime(2026, 10, 30),
      ),
    ];
  }
}
