import 'package:flutter_test/flutter_test.dart';
import 'package:manager/domain/models/transaction.dart';
import 'package:manager/ui/transactions/transactions_view_model.dart';

import 'support/stub_repositories.dart';

void main() {
  // Failure paths use failFetch or failSave on the stub
  group('load()', () {
    test('ends in the loaded state, newest first', () async {
      final vm = TransactionsViewModel(
        StubTransactionRepository(initial: [paycheck, sampleTransaction()]),
      );

      await vm.load();

      expect(vm.state, isA<TransactionsLoaded>());
      expect(vm.transactions.map((t) => t.id), ['coffee', 'paycheck']);
    });

    test('ends in the error state when the repository fails', () async {
      final vm = TransactionsViewModel(
        StubTransactionRepository(failFetch: true),
      );

      await vm.load();

      expect(vm.state, isA<TransactionsError>());
      expect(vm.transactions, isEmpty);
    });

    test('succeeds on retry after a failure', () async {
      final repository = StubTransactionRepository(
        initial: [paycheck],
        failFetch: true,
      );
      final vm = TransactionsViewModel(repository);
      await vm.load();

      repository.failFetch = false;
      await vm.load();

      expect(vm.state, isA<TransactionsLoaded>());
    });
  });

  group('derived values', () {
    test('balance, income and expenses come from the transactions', () async {
      final vm = TransactionsViewModel(
        StubTransactionRepository(initial: [paycheck, sampleTransaction()]),
      );

      await vm.load();

      expect(vm.balance, closeTo(95.5, 0.001));
      expect(vm.totalIncome, closeTo(100, 0.001));
      expect(vm.totalExpenses, closeTo(4.5, 0.001));
    });

    test('spentIn() counts only expenses of that category', () async {
      final vm = TransactionsViewModel(
        StubTransactionRepository(
          initial: [
            sampleTransaction(id: 'a', amount: 10),
            sampleTransaction(id: 'b', amount: 5),
            sampleTransaction(
              id: 'c',
              amount: 7,
              category: TransactionCategory.bills,
            ),
            sampleTransaction(
              id: 'd',
              amount: 50,
              type: TransactionType.income,
            ),
          ],
        ),
      );

      await vm.load();

      expect(vm.spentIn(TransactionCategory.eatingOut), closeTo(15, 0.001));
    });
  });

  group('add()', () {
    test('adds the saved transaction and changes the balance', () async {
      final vm = TransactionsViewModel(
        StubTransactionRepository(initial: [paycheck]),
      );
      await vm.load();
      var notified = 0;
      vm.addListener(() => notified++);

      final saved = await vm.add(sampleTransaction(id: ''));

      expect(saved, isTrue);
      expect(vm.transactions, hasLength(2));
      expect(vm.balance, closeTo(95.5, 0.001));
      expect(notified, greaterThan(0));
    });

    test('keeps the list unchanged when saving fails', () async {
      final repository = StubTransactionRepository(initial: [paycheck]);
      final vm = TransactionsViewModel(repository);
      await vm.load();
      repository.failSave = true;

      final saved = await vm.add(sampleTransaction(id: ''));

      expect(saved, isFalse);
      expect(vm.transactions, [paycheck]);
    });
  });

  test('update() replaces the transaction with the same id', () async {
    final vm = TransactionsViewModel(
      StubTransactionRepository(initial: [paycheck]),
    );
    await vm.load();

    final saved = await vm.update(paycheck.copyWith(amount: 250));

    expect(saved, isTrue);
    expect(vm.transactionById('paycheck')!.amount, 250);
  });

  group('delete()', () {
    test('removes the transaction', () async {
      final vm = TransactionsViewModel(
        StubTransactionRepository(initial: [paycheck]),
      );
      await vm.load();

      final deleted = await vm.delete('paycheck');

      expect(deleted, isTrue);
      expect(vm.transactionById('paycheck'), isNull);
    });

    test('rolls back when deleting fails', () async {
      final repository = StubTransactionRepository(initial: [paycheck]);
      final vm = TransactionsViewModel(repository);
      await vm.load();
      repository.failSave = true;

      final deleted = await vm.delete('paycheck');

      expect(deleted, isFalse);
      expect(vm.transactionById('paycheck'), paycheck);
    });
  });

  // Happens when a screen closes during a request
  test('a late result after dispose() does not throw', () async {
    final vm = TransactionsViewModel(
      StubTransactionRepository(initial: [paycheck]),
    );

    final loading = vm.load();
    vm.dispose();

    await expectLater(loading, completes);
  });
}
