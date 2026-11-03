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

/// Composition root: the only file that knows the concrete repositories.
void main() {
  runApp(
    MultiProvider(
      providers: [
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
