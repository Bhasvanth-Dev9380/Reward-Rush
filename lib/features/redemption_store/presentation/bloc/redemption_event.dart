// lib/features/redemption_store/presentation/bloc/redemption_event.dart

import '../../domain/entities/redemption_item.dart';

abstract class RedemptionEvent {}

class LoadRedemptionItems extends RedemptionEvent {}

class RedeemItem extends RedemptionEvent {
  final RedemptionItem item;

  RedeemItem(this.item);
}
