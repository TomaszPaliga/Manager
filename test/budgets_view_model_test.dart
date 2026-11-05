import 'package:flutter_test/flutter_test.dart';
import 'package:manager/domain/models/budget.dart';
import 'package:manager/domain/models/transaction.dart';
import 'package:manager/ui/budgets/budgets_view_model.dart';

import 'support/stub_repositories.dart';

void main() {
  // Only the limits, spending is covered in the transactions tests
  test('load() ends in the loaded state', () async {
    const budget = Budget(
      id: 'b',
      category: TransactionCategory.groceries,
      limit: 100,
    );
    final vm = BudgetsViewModel(StubBudgetRepository(budgets: [budget]));

    await vm.load();

    final state = vm.state;
    expect(state, isA<BudgetsLoaded>());
    expect((state as BudgetsLoaded).budgets, [budget]);
  });

  test('load() ends in the error state when the repository fails', () async {
    final vm = BudgetsViewModel(StubBudgetRepository(failFetch: true));

    await vm.load();

    expect(vm.state, isA<BudgetsError>());
  });
}
