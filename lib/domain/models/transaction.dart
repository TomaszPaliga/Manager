enum TransactionType { income, expense }

// The labels are what we show in the UI
enum TransactionCategory {
  salary('Salary'),
  groceries('Groceries'),
  eatingOut('Eating out'),
  transport('Transport'),
  subscriptions('Subscriptions'),
  health('Health'),
  shopping('Shopping'),
  bills('Bills'),
  pets('Pets'),
  entertainment('Entertainment'),
  other('Other');

  const TransactionCategory(this.label);

  final String label;
}

// amount is always positive, type says if it's income or an expense
class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? note;

  // Negative for expenses, handy for adding up the balance
  double get signedAmount =>
      type == TransactionType.income ? amount : -amount;

  // Models are immutable, so a change means making a copy
  // Can't set note back to null with this, the form builds a new object instead
  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  // Needed so tests can compare transactions by value
  @override
  bool operator ==(Object other) {
    return other is Transaction &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.type == type &&
        other.category == category &&
        other.date == date &&
        other.note == note;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, amount, type, category, date, note);
}
