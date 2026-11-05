import 'transaction.dart';

// Spending limit for one category
class Budget {
  const Budget({
    required this.id,
    required this.category,
    required this.limit,
  });

  final String id;
  final TransactionCategory category;
  final double limit;

  Budget copyWith({
    String? id,
    TransactionCategory? category,
    double? limit,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Budget &&
        other.id == id &&
        other.category == category &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(id, category, limit);
}
