import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manager/ui/transactions/transactions_screen.dart';
import 'package:manager/ui/transactions/transactions_view_model.dart';
import 'package:provider/provider.dart';

import '../support/stub_repositories.dart';

Future<void> pumpScreen(
  WidgetTester tester,
  StubTransactionRepository repository,
) async {
  final vm = TransactionsViewModel(repository)..load();
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: vm,
      child: const MaterialApp(home: TransactionsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a spinner while loading', (tester) async {
    final vm = TransactionsViewModel(StubTransactionRepository());
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: const MaterialApp(home: TransactionsScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the transactions when loaded', (tester) async {
    await pumpScreen(
      tester,
      StubTransactionRepository(initial: [paycheck, sampleTransaction()]),
    );

    expect(find.text('Paycheck'), findsOneWidget);
    expect(find.text('-\$4.50'), findsOneWidget);
  });

  testWidgets('shows the empty state', (tester) async {
    await pumpScreen(tester, StubTransactionRepository());

    expect(find.text('No transactions yet. Tap + to add one.'), findsOneWidget);
  });

  testWidgets('shows the error state and recovers on retry', (tester) async {
    final repository = StubTransactionRepository(
      initial: [paycheck],
      failFetch: true,
    );
    await pumpScreen(tester, repository);

    expect(find.text('Could not load transactions.'), findsOneWidget);

    repository.failFetch = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Paycheck'), findsOneWidget);
  });
}
