import 'package:flutter/foundation.dart';

import '../../data/repositories/budget_repository.dart';
import '../../domain/models/budget.dart';

// Same idea as TransactionsState
sealed class BudgetsState {
  const BudgetsState();
}

final class BudgetsLoading extends BudgetsState {
  const BudgetsLoading();
}

final class BudgetsLoaded extends BudgetsState {
  const BudgetsLoaded(this.budgets);

  final List<Budget> budgets;
}

final class BudgetsError extends BudgetsState {
  const BudgetsError(this.message);

  final String message;
}

// Only loads the limits, the spent amounts come from TransactionsViewModel
class BudgetsViewModel extends ChangeNotifier {
  BudgetsViewModel(this._repository);

  final BudgetRepository _repository;

  BudgetsState _state = const BudgetsLoading();
  bool _disposed = false;

  BudgetsState get state => _state;

  Future<void> load() async {
    _setState(const BudgetsLoading());
    try {
      _setState(BudgetsLoaded(await _repository.fetchBudgets()));
    } catch (_) {
      _setState(const BudgetsError('Could not load budgets.'));
    }
  }

  void _setState(BudgetsState state) {
    _state = state;
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
