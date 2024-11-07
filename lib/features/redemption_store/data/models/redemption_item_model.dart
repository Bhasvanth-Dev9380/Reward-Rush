// lib/features/redemption_store/data/models/redemption_item_model.dart

import '../../domain/entities/redemption_item.dart';

class RedemptionItemModel extends RedemptionItem {
  RedemptionItemModel({
    required String id,
    required String name,
    required int cost,
  }) : super(id: id, name: name, cost: cost);

  // Convert JSON to RedemptionItemModel
  factory RedemptionItemModel.fromJson(Map<String, dynamic> json) {
    return RedemptionItemModel(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
    );
  }

  // Convert RedemptionItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
    };
  }
}
