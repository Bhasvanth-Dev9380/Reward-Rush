// lib/features/history/presentation/bloc/transaction_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transaction_history.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionHistory getTransactionHistory;
  final TransactionRepository transactionRepository;

  TransactionBloc({
    required this.getTransactionHistory,
    required this.transactionRepository,
  }) : super(TransactionInitial()) {
    on<LoadTransactionHistory>(_onLoadTransactionHistory);
    on<AddTransactionEvent>(_onAddTransactionEvent); // Add handling for AddTransactionEvent
  }

  Future<void> _onLoadTransactionHistory(LoadTransactionHistory event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final transactions = await getTransactionHistory();
      emit(TransactionLoaded(transactions));
    } catch (_) {
      emit(TransactionError("Failed to load transaction history."));
    }
  }

  Future<void> _onAddTransactionEvent(AddTransactionEvent event, Emitter<TransactionState> emit) async {
    try {
      await transactionRepository.addTransaction(event.transaction);
      add(LoadTransactionHistory()); // Reload the history to include the new transaction
    } catch (_) {
      emit(TransactionError("Failed to add transaction."));
    }
  }
}
