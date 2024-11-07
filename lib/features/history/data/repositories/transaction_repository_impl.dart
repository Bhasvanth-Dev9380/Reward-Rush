// lib/features/history/data/repositories/transaction_repository_impl.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  static const String _transactionsKey = 'transactions';

  @override
  Future<List<Transaction>> getTransactionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJsonList = prefs.getStringList(_transactionsKey) ?? [];
    return transactionsJsonList.map((jsonString) => TransactionModel.fromJson(jsonString)).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactionHistory();

    // Convert the transaction entity to TransactionModel for serialization
    final transactionModel = TransactionModel.fromEntity(transaction);
    transactions.add(transactionModel);

    // Convert the list of transactions to JSON strings for storage
    final transactionJsonList = transactions.map((t) => (t as TransactionModel).toJson()).toList();
    await prefs.setStringList(_transactionsKey, transactionJsonList);
  }
}
