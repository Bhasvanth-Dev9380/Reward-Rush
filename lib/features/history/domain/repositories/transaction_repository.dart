// lib/features/history/domain/repositories/transaction_repository.dart

import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactionHistory();
  Future<void> addTransaction(Transaction transaction);
}
