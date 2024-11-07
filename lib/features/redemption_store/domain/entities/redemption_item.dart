// lib/features/redemption_store/domain/entities/redemption_item.dart

import 'package:equatable/equatable.dart';

class RedemptionItem extends Equatable {
  final String id;
  final String name;
  final int cost;

  RedemptionItem({
    required this.id,
    required this.name,
    required this.cost,
  });

  @override
  List<Object> get props => [id, name, cost];
}
