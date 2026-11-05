import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/budget_repository.dart';
import 'data/repositories/fake_auth_repository.dart';
import 'data/repositories/fake_budget_repository.dart';
import 'data/repositories/fake_transaction_repository.dart';
import 'data/repositories/transaction_repository.dart';
import 'ui/app.dart';
import 'ui/auth/auth_view_model.dart';
import 'ui/budgets/budgets_view_model.dart';
import 'ui/transactions/transactions_view_model.dart';

// The only file that knows about the fake repositories
// For Lab 3 we just swap them here for the real ones
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Repositories go first, the view models below read them
        Provider<AuthRepository>(
          create: (_) => FakeAuthRepository(failureRate: 0.1),
        ),
        Provider<TransactionRepository>(
          create: (_) => FakeTransactionRepository(failureRate: 0.2),
        ),
        Provider<BudgetRepository>(
          create: (_) => FakeBudgetRepository(failureRate: 0.2),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),
        // load() starts here when the view model is created, never in build
        ChangeNotifierProvider(
          create: (context) =>
              TransactionsViewModel(context.read<TransactionRepository>())
                ..load(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              BudgetsViewModel(context.read<BudgetRepository>())..load(),
        ),
      ],
      child: const ManagerApp(),
    ),
  );
}
