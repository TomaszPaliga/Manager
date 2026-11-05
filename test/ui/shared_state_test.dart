import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manager/domain/models/budget.dart';
import 'package:manager/domain/models/transaction.dart';
import 'package:manager/ui/budgets/budgets_screen.dart';
import 'package:manager/ui/budgets/budgets_view_model.dart';
import 'package:manager/ui/dashboard/dashboard_screen.dart';
import 'package:manager/ui/transactions/transactions_view_model.dart';
import 'package:provider/provider.dart';

import '../support/stub_repositories.dart';

void main() {
  // This is the shared state requirement from the lab
  testWidgets('a new transaction updates the dashboard balance', (
    tester,
  ) async {
    final vm = TransactionsViewModel(
      StubTransactionRepository(initial: [paycheck, sampleTransaction()]),
    )..load();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('\$95.50'), findsOneWidget);

    await vm.add(
      sampleTransaction(
        id: '',
        title: 'Bonus',
        amount: 10,
        type: TransactionType.income,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('\$105.50'), findsOneWidget);
    expect(find.text('Bonus'), findsOneWidget);
  });

  group('budgets screen', () {
    const budget = Budget(
      id: 'b',
      category: TransactionCategory.eatingOut,
      limit: 60,
    );

    Future<TransactionsViewModel> pumpBudgets(
      WidgetTester tester,
      StubBudgetRepository budgets,
    ) async {
      final transactions = TransactionsViewModel(
        StubTransactionRepository(initial: [sampleTransaction()]),
      )..load();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: transactions),
            ChangeNotifierProvider(
              create: (_) => BudgetsViewModel(budgets)..load(),
            ),
          ],
          child: const MaterialApp(home: BudgetsScreen()),
        ),
      );
      await tester.pumpAndSettle();
      return transactions;
    }

    testWidgets('moves when a new expense is added', (tester) async {
      final transactions = await pumpBudgets(
        tester,
        StubBudgetRepository(budgets: [budget]),
      );
      expect(find.text('\$4.50 / \$60.00'), findsOneWidget);

      await transactions.add(sampleTransaction(id: '', amount: 5.5));
      await tester.pumpAndSettle();

      expect(find.text('\$10.00 / \$60.00'), findsOneWidget);
    });

    testWidgets('shows the error state and recovers on retry', (tester) async {
      final budgets = StubBudgetRepository(
        budgets: [budget],
        failFetch: true,
      );
      await pumpBudgets(tester, budgets);

      expect(find.text('Could not load budgets.'), findsOneWidget);

      budgets.failFetch = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Eating out'), findsOneWidget);
    });

    testWidgets('shows the empty state', (tester) async {
      await pumpBudgets(tester, StubBudgetRepository());

      expect(find.text('No budgets yet.'), findsOneWidget);
    });
  });
}
