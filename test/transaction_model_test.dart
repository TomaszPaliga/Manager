import 'package:flutter_test/flutter_test.dart';
import 'package:manager/domain/models/transaction.dart';

import 'support/stub_repositories.dart';

void main() {
  test('copyWith() changes one field and keeps the original intact', () {
    final original = sampleTransaction(amount: 10);

    final changed = original.copyWith(amount: 20);

    expect(changed.amount, 20);
    expect(changed.title, original.title);
    expect(original.amount, 10);
  });

  // The other tests rely on this when comparing lists
  test('transactions with the same fields are equal', () {
    expect(sampleTransaction(), sampleTransaction());
    expect(sampleTransaction().hashCode, sampleTransaction().hashCode);
    expect(sampleTransaction(), isNot(sampleTransaction(amount: 99)));
  });

  test('signedAmount is negative only for expenses', () {
    expect(sampleTransaction(amount: 5).signedAmount, -5);
    expect(
      sampleTransaction(amount: 5, type: TransactionType.income).signedAmount,
      5,
    );
  });
}
