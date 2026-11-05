import '../../domain/models/budget.dart';

// Read only for now, budgets are not editable in the app yet
abstract interface class BudgetRepository {
  Future<List<Budget>> fetchBudgets();
}
