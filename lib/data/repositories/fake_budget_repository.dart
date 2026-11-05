import 'dart:math';

import '../../domain/models/budget.dart';
import '../../domain/models/transaction.dart';
import 'budget_repository.dart';
import 'fake_network.dart';

// Fake version of BudgetRepository, the view model only sees the interface
// Pass initialBudgets: const [] to check the empty state
class FakeBudgetRepository implements BudgetRepository {
  FakeBudgetRepository({
    Duration delay = const Duration(milliseconds: 800),
    double failureRate = 0.0,
    Random? random,
    List<Budget>? initialBudgets,
  }) : _network = FakeNetwork(
         delay: delay,
         failureRate: failureRate,
         random: random,
       ),
       // Copy, so we never touch the list that was passed in
       _budgets = List.of(initialBudgets ?? _seedBudgets);

  // Starting data, eating out is over the limit on purpose
  static const _seedBudgets = [
    Budget(id: 'b-1', category: TransactionCategory.groceries, limit: 300),
    Budget(id: 'b-2', category: TransactionCategory.eatingOut, limit: 60),
    Budget(id: 'b-3', category: TransactionCategory.transport, limit: 100),
    Budget(id: 'b-4', category: TransactionCategory.shopping, limit: 200),
    Budget(id: 'b-5', category: TransactionCategory.bills, limit: 150),
    Budget(id: 'b-6', category: TransactionCategory.entertainment, limit: 80),
  ];

  final FakeNetwork _network;
  final List<Budget> _budgets;

  @override
  Future<List<Budget>> fetchBudgets() async {
    // Can throw, the view model catches it and shows the error screen
    await _network.simulateRequest();
    // Read only copy so nobody changes our list from outside
    return List.unmodifiable(_budgets);
  }
}
