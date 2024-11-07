import 'package:equatable/equatable.dart';

abstract class CoinState extends Equatable {
  final int coins;
  final DateTime nextScratchTime;

  const CoinState({required this.coins, required this.nextScratchTime});

  @override
  List<Object> get props => [coins, nextScratchTime];
}

class CoinInitial extends CoinState {
  const CoinInitial({required int coins, required DateTime nextScratchTime})
      : super(coins: coins, nextScratchTime: nextScratchTime);
}

class CoinUpdated extends CoinState {
  const CoinUpdated({required int coins, required DateTime nextScratchTime})
      : super(coins: coins, nextScratchTime: nextScratchTime);
}

class TimerUpdated extends CoinState {
  const TimerUpdated({required int coins, required DateTime nextScratchTime})
      : super(coins: coins, nextScratchTime: nextScratchTime);
}
