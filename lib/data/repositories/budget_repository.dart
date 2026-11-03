import '../../domain/models/budget.dart';

/// Provides the user's spending limits.
abstract interface class BudgetRepository {
  Future<List<Budget>> fetchBudgets();
}
