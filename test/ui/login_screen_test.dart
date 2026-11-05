import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manager/ui/app.dart';
import 'package:manager/ui/auth/auth_view_model.dart';
import 'package:manager/ui/auth/login_screen.dart';
import 'package:manager/ui/budgets/budgets_view_model.dart';
import 'package:manager/ui/transactions/transactions_view_model.dart';
import 'package:provider/provider.dart';

import '../support/stub_repositories.dart';

Finder get loginButton => find.widgetWithText(FilledButton, 'Log in');

Future<void> enterCredentials(WidgetTester tester, String password) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Username'),
    'demo',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    password,
  );
}

void main() {
  Future<void> pumpLogin(WidgetTester tester, AuthViewModel vm) async {
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  testWidgets('requires a username and a password', (tester) async {
    await pumpLogin(tester, AuthViewModel(StubAuthRepository()));

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Enter your username'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });

  testWidgets('shows an error for wrong credentials', (tester) async {
    await pumpLogin(tester, AuthViewModel(StubAuthRepository()));
    await enterCredentials(tester, 'wrong');

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Wrong username or password.'), findsOneWidget);
  });

  // Whole app here, not just the login screen
  testWidgets('logging in opens the dashboard', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthViewModel(StubAuthRepository()),
          ),
          ChangeNotifierProvider(
            create: (_) => TransactionsViewModel(
              StubTransactionRepository(initial: [paycheck]),
            )..load(),
          ),
          ChangeNotifierProvider(
            create: (_) => BudgetsViewModel(StubBudgetRepository())..load(),
          ),
        ],
        child: const ManagerApp(),
      ),
    );
    await enterCredentials(tester, 'correct');

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Total Balance'), findsOneWidget);
  });
}
