
import '../../domain/entities/coin_balance.dart';

class CoinBalanceModel {
  final int balance;

  CoinBalanceModel({required this.balance});

  factory CoinBalanceModel.fromJson(Map<String, dynamic> json) {
    return CoinBalanceModel(balance: json['balance'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance};
  }

  // Helper method to convert from model to entity
  CoinBalance toEntity() {
    return CoinBalance(balance: balance);
  }
}
