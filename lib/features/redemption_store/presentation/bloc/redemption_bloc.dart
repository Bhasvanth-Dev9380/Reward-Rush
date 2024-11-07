import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/presentation/bloc/coin_event.dart';
import '../../domain/entities/redemption_item.dart';
import '../../domain/repositories/redemption_repository.dart';
import 'redemption_event.dart';
import 'redemption_state.dart';
import '../../../home/presentation/bloc/coin_bloc.dart';
import '../../../history/presentation/bloc/transaction_bloc.dart';
import '../../../history/presentation/bloc/transaction_event.dart';
import '../../../history/domain/entities/transaction.dart';

class RedemptionBloc extends Bloc<RedemptionEvent, RedemptionState> {
  final RedemptionRepository repository;
  final CoinBloc coinBloc;
  final TransactionBloc transactionBloc;

  RedemptionBloc({
    required this.repository,
    required this.coinBloc,
    required this.transactionBloc,
  }) : super(RedemptionInitial()) {
    on<LoadRedemptionItems>(_onLoadRedemptionItems);
    on<RedeemItem>(_onRedeemItem);
  }

  Future<void> _onLoadRedemptionItems(
      LoadRedemptionItems event, Emitter<RedemptionState> emit) async {
    emit(RedemptionLoading());
    final items = await repository.getRedemptionItems();
    emit(RedemptionLoaded(items));
  }

  Future<void> _onRedeemItem(
      RedeemItem event, Emitter<RedemptionState> emit) async {
    final item = event.item;
    final currentBalance = await coinBloc.repository.getCoinBalance();

    if (currentBalance.balance >= item.cost) {
      final newBalance = currentBalance.balance - item.cost;
      await coinBloc.repository.updateCoinBalance(newBalance);

      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: "debit",
        amount: item.cost,
        balanceAfter: newBalance,
        date: DateTime.now(),
      );

      transactionBloc.add(AddTransactionEvent(transaction));

      emit(RedemptionSuccess(newBalance));
      coinBloc.add(UpdateCoinBalance(newBalance: newBalance)); // Update the coin balance without reloading

    } else {
      emit(RedemptionFailure('Insufficient balance to redeem ${item.name}.'));
    }
  }
}
