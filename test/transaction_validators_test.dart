import 'package:flutter_test/flutter_test.dart';
import 'package:manager/ui/transactions/transaction_validators.dart';

void main() {
  group('validateTitle()', () {
    test('rejects an empty or blank title', () {
      expect(validateTitle(''), isNotNull);
      expect(validateTitle('   '), isNotNull);
      expect(validateTitle(null), isNotNull);
    });

    test('rejects a title that is too long', () {
      expect(validateTitle('a' * (maxTitleLength + 1)), isNotNull);
    });

    test('accepts a normal title', () {
      expect(validateTitle('Groceries'), isNull);
    });
  });

  group('validateAmount()', () {
    test('rejects text, negatives, zero and too many decimals', () {
      for (final value in ['', 'abc', '-5', '0', '0.00', '1.234', '1e3']) {
        expect(validateAmount(value), isNotNull, reason: value);
      }
    });

    test('rejects an amount above the maximum', () {
      expect(validateAmount('1000000.01'), isNotNull);
    });

    test('accepts a dot or a comma as the decimal separator', () {
      expect(validateAmount('12.50'), isNull);
      expect(validateAmount('12,50'), isNull);
      expect(parseAmount('12,50'), 12.5);
    });
  });
}
