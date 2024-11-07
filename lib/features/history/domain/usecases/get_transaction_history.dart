// lib/features/history/domain/usecases/get_transaction_history.dart

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionHistory {
  final TransactionRepository repository;

  GetTransactionHistory(this.repository);

  Future<List<Transaction>> call() async {
    return await repository.getTransactionHistory();
  }
}
