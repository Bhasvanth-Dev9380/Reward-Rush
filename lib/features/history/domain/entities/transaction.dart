// lib/features/history/domain/entities/transaction.dart

import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String type; // "credit" or "debit"
  final int amount;
  final int balanceAfter;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.date,
  });

  @override
  List<Object> get props => [id, type, amount, balanceAfter, date];
}
