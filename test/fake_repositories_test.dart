import 'package:flutter_test/flutter_test.dart';
import 'package:manager/data/repositories/fake_auth_repository.dart';
import 'package:manager/data/repositories/fake_budget_repository.dart';
import 'package:manager/data/repositories/fake_network.dart';
import 'package:manager/data/repositories/fake_transaction_repository.dart';
import 'package:manager/domain/exceptions.dart';

import 'support/stub_repositories.dart';

void main() {
  test('failureRate 1.0 always fails', () async {
    final repository = FakeTransactionRepository(
      delay: Duration.zero,
      failureRate: 1.0,
    );

    await expectLater(
      repository.fetchTransactions(),
      throwsA(isA<FakeNetworkException>()),
    );
  });

  test('the seed data keeps the balance from Lab 1', () async {
    final repository = FakeTransactionRepository(delay: Duration.zero);

    final transactions = await repository.fetchTransactions();
    final balance = transactions.fold<double>(
      0,
      (sum, t) => sum + t.signedAmount,
    );

    expect(balance, closeTo(5240.50, 0.001));
  });

  test('a saved transaction gets an id and is returned by fetch', () async {
    final repository = FakeTransactionRepository(
      delay: Duration.zero,
      initialTransactions: const [],
    );

    final saved = await repository.addTransaction(sampleTransaction(id: ''));
    final transactions = await repository.fetchTransactions();

    expect(saved.id, isNotEmpty);
    expect(transactions, [saved]);
  });

  test('budgets can start empty', () async {
    final repository = FakeBudgetRepository(
      delay: Duration.zero,
      initialBudgets: const [],
    );

    expect(await repository.fetchBudgets(), isEmpty);
  });

  test('login rejects a wrong password', () async {
    final repository = FakeAuthRepository(delay: Duration.zero);

    await expectLater(
      repository.login(FakeAuthRepository.demoUsername, 'wrong'),
      throwsA(isA<InvalidCredentialsException>()),
    );
  });
}
