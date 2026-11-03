import 'package:manager/data/repositories/auth_repository.dart';
import 'package:manager/data/repositories/budget_repository.dart';
import 'package:manager/data/repositories/transaction_repository.dart';
import 'package:manager/domain/exceptions.dart';
import 'package:manager/domain/models/app_user.dart';
import 'package:manager/domain/models/budget.dart';
import 'package:manager/domain/models/transaction.dart';

Transaction sampleTransaction({
  String id = 'coffee',
  String title = 'Coffee',
  double amount = 4.5,
  TransactionType type = TransactionType.expense,
  TransactionCategory category = TransactionCategory.eatingOut,
  DateTime? date,
}) {
  return Transaction(
    id: id,
    title: title,
    amount: amount,
    type: type,
    category: category,
    date: date ?? DateTime(2026, 10, 20),
  );
}

final paycheck = sampleTransaction(
  id: 'paycheck',
  title: 'Paycheck',
  amount: 100,
  type: TransactionType.income,
  category: TransactionCategory.salary,
  date: DateTime(2026, 10, 10),
);

/// Answers immediately, so tests need no real delays. Set [failFetch] or
/// [failSave] to walk the failure paths.
class StubTransactionRepository implements TransactionRepository {
  StubTransactionRepository({
    List<Transaction> initial = const [],
    this.failFetch = false,
    this.failSave = false,
  }) : _transactions = List.of(initial);

  final List<Transaction> _transactions;
  bool failFetch;
  bool failSave;
  int _nextId = 1;

  @override
  Future<List<Transaction>> fetchTransactions() async {
    if (failFetch) {
      throw Exception('fetch failed');
    }
    return List.of(_transactions);
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    _throwIfSaveFails();
    final saved = transaction.copyWith(id: 'saved-${_nextId++}');
    _transactions.add(saved);
    return saved;
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    _throwIfSaveFails();
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    _transactions[index] = transaction;
    return transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _throwIfSaveFails();
    _transactions.removeWhere((t) => t.id == id);
  }

  void _throwIfSaveFails() {
    if (failSave) {
      throw Exception('save failed');
    }
  }
}

class StubBudgetRepository implements BudgetRepository {
  StubBudgetRepository({this.budgets = const [], this.failFetch = false});

  final List<Budget> budgets;
  bool failFetch;

  @override
  Future<List<Budget>> fetchBudgets() async {
    if (failFetch) {
      throw Exception('fetch failed');
    }
    return budgets;
  }
}

class StubAuthRepository implements AuthRepository {
  StubAuthRepository({this.failNetwork = false});

  static const user = AppUser(
    id: 'user-1',
    username: 'demo',
    displayName: 'Demo User',
  );

  bool failNetwork;
  int logoutCalls = 0;

  @override
  Future<AppUser> login(String username, String password) async {
    if (failNetwork) {
      throw Exception('network failed');
    }
    if (password != 'correct') {
      throw const InvalidCredentialsException();
    }
    return user;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
  }
}
