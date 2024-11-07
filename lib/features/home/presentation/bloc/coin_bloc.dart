// lib/features/home/presentation/bloc/coin_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/scratch_card_helper.dart';
import '../../domain/repositories/coin_repository.dart';
import 'coin_event.dart';
import 'coin_state.dart';
import '../../../history/domain/entities/transaction.dart';
import '../../../history/data/repositories/transaction_repository_impl.dart';
import '../../../history/presentation/bloc/transaction_bloc.dart';
import '../../../history/presentation/bloc/transaction_event.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final CoinRepository repository;
  final TransactionRepositoryImpl transactionRepository = TransactionRepositoryImpl();
  final TransactionBloc transactionBloc; // Reference to TransactionBloc to refresh history
  Timer? _timer;

  CoinBloc({
    required this.repository,
    required this.transactionBloc,
  }) : super(CoinInitial(coins: 1000, nextScratchTime: _calculateNextScratchTime())) {
    on<LoadInitialCoins>(_onLoadInitialCoins);
    on<ScratchCardEvent>(_onScratchCardEvent);
    on<UpdateCoinBalance>(_onUpdateCoinBalance); // Add handler for UpdateCoinBalance

    _initializeScratchCardTimer();
  }

  static DateTime _calculateNextScratchTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour + 1);
  }

  Future<void> _onLoadInitialCoins(LoadInitialCoins event, Emitter<CoinState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final coinBalance = await repository.getCoinBalance();

    // Retrieve next scratch time from SharedPreferences if available
    final nextScratchTimeMillis = prefs.getInt('next_scratch_time');
    final nextScratchTime = nextScratchTimeMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(nextScratchTimeMillis)
        : _calculateNextScratchTime();

    emit(CoinInitial(coins: coinBalance.balance, nextScratchTime: nextScratchTime));
  }

  Future<void> _onScratchCardEvent(ScratchCardEvent event, Emitter<CoinState> emit) async {
    final currentState = state;
    if (currentState is CoinInitial || currentState is CoinUpdated) {
      final newCoins = currentState.coins + event.reward;
      await repository.updateCoinBalance(newCoins);

      // Create a transaction for this scratch
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: "credit",
        amount: event.reward,
        balanceAfter: newCoins,
        date: DateTime.now(),
      );

      // Add the transaction to SharedPreferences and update TransactionBloc
      await transactionRepository.addTransaction(transaction);
      transactionBloc.add(LoadTransactionHistory()); // Notify TransactionBloc to refresh

      await ScratchCardHelper.setScratchAvailable(false);
      await ScratchCardHelper.saveLastScratchTime(DateTime.now());

      // Store next scratch time in SharedPreferences
      final nextScratchTime = _calculateNextScratchTime();
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('next_scratch_time', nextScratchTime.millisecondsSinceEpoch);

      emit(CoinUpdated(coins: newCoins, nextScratchTime: nextScratchTime)); // Use named arguments
      _initializeScratchCardTimer();
    }
  }

  // New handler for UpdateCoinBalance event
  Future<void> _onUpdateCoinBalance(UpdateCoinBalance event, Emitter<CoinState> emit) async {
    final newBalance = event.newBalance;
    await repository.updateCoinBalance(newBalance);
    emit(CoinUpdated(coins: newBalance, nextScratchTime: state.nextScratchTime)); // Use named arguments
  }

  void _initializeScratchCardTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final nextScratchTimeMillis = prefs.getInt('next_scratch_time');
    final DateTime nextScratchTime = nextScratchTimeMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(nextScratchTimeMillis)
        : _calculateNextScratchTime();

    final delay = nextScratchTime.difference(DateTime.now()).inSeconds;

    _timer?.cancel();
    _timer = Timer(Duration(seconds: delay), () async {
      await ScratchCardHelper.setScratchAvailable(true);
      // Only mark scratch card available without reloading coins
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
