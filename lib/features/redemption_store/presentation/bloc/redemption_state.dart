// lib/features/redemption_store/presentation/bloc/redemption_state.dart

import '../../domain/entities/redemption_item.dart';

abstract class RedemptionState {}

class RedemptionInitial extends RedemptionState {}

class RedemptionLoading extends RedemptionState {}

class RedemptionLoaded extends RedemptionState {
  final List<RedemptionItem> items;

  RedemptionLoaded(this.items);
}

class RedemptionSuccess extends RedemptionState {
  final int newBalance;

  RedemptionSuccess(this.newBalance);
}

class RedemptionFailure extends RedemptionState {
  final String message;

  RedemptionFailure(this.message);
}
