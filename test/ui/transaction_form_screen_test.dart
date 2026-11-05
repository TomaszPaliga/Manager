import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manager/ui/transactions/transaction_form_screen.dart';
import 'package:manager/ui/transactions/transactions_view_model.dart';
import 'package:provider/provider.dart';

import '../support/stub_repositories.dart';

// Opens the form from another screen so pop() has somewhere to go back to
Future<void> openForm(WidgetTester tester, TransactionsViewModel vm) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: vm,
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push(TransactionFormScreen.route());
              },
              child: const Text('Open form'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open form'));
  await tester.pumpAndSettle();
}

Future<void> tapSave(WidgetTester tester) async {
  // Save can be off screen on the small test window
  await tester.ensureVisible(find.text('Save'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

Future<void> fillIn(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Title'),
    'Lunch',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Amount'),
    '12,50',
  );
}

void main() {
  late StubTransactionRepository repository;
  late TransactionsViewModel vm;

  setUp(() async {
    repository = StubTransactionRepository();
    vm = TransactionsViewModel(repository);
    await vm.load();
  });

  testWidgets('shows validation errors and saves nothing', (tester) async {
    await openForm(tester, vm);

    await tapSave(tester);

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Enter an amount'), findsOneWidget);
    expect(vm.transactions, isEmpty);
  });

  testWidgets('saves a valid form and closes', (tester) async {
    await openForm(tester, vm);
    await fillIn(tester);

    await tapSave(tester);

    expect(vm.transactions.single.title, 'Lunch');
    expect(vm.transactions.single.amount, 12.5);
    expect(find.text('Open form'), findsOneWidget);
  });

  testWidgets('stays open and reports a failed save', (tester) async {
    repository.failSave = true;
    await openForm(tester, vm);
    await fillIn(tester);

    await tapSave(tester);

    expect(find.text('Could not save. Try again.'), findsOneWidget);
    expect(find.text('New transaction'), findsOneWidget);
    expect(vm.transactions, isEmpty);
  });
}
