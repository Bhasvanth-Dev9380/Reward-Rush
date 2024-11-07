// lib/features/history/data/models/transaction_model.dart

import 'dart:convert';

import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required String id,
    required String type,
    required int amount,
    required int balanceAfter,
    required DateTime date,
  }) : super(
    id: id,
    type: type,
    amount: amount,
    balanceAfter: balanceAfter,
    date: date,
  );

  // Factory constructor to create a TransactionModel from JSON
  factory TransactionModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(jsonDecode(jsonString));
    return TransactionModel(
      id: json['id'],
      type: json['type'],
      amount: json['amount'],
      balanceAfter: json['balanceAfter'],
      date: DateTime.parse(json['date']),
    );
  }

  // Convert TransactionModel to JSON
  String toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'type': type,
      'amount': amount,
      'balanceAfter': balanceAfter,
      'date': date.toIso8601String(),
    };
    return jsonEncode(data);
  }

  // Method to convert a Transaction entity to a TransactionModel
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      type: transaction.type,
      amount: transaction.amount,
      balanceAfter: transaction.balanceAfter,
      date: transaction.date,
    );
  }
}
