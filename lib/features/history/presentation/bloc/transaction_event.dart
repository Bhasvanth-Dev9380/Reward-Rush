// lib/features/history/presentation/bloc/transaction_event.dart

import '../../domain/entities/transaction.dart';

abstract class TransactionEvent {}

class LoadTransactionHistory extends TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final Transaction transaction;

  AddTransactionEvent(this.transaction);
}
