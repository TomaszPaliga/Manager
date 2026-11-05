import '../../domain/models/transaction.dart';

abstract interface class TransactionRepository {
  Future<List<Transaction>> fetchTransactions();

  // Returns the saved transaction because the repository sets the id
  Future<Transaction> addTransaction(Transaction transaction);

  Future<Transaction> updateTransaction(Transaction transaction);

  Future<void> deleteTransaction(String id);
}
