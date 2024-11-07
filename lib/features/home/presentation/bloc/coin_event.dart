// lib/features/home/presentation/bloc/coin_event.dart

import 'package:equatable/equatable.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialCoins extends CoinEvent {}

class ScratchCardEvent extends CoinEvent {
  final int reward;

  const ScratchCardEvent({required this.reward});

  @override
  List<Object> get props => [reward];
}

class UpdateCoinBalance extends CoinEvent {
  final int newBalance;

  const UpdateCoinBalance({required this.newBalance});

  @override
  List<Object> get props => [newBalance];
}
