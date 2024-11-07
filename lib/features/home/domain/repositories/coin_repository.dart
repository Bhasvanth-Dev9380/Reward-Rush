// lib/features/home/domain/repositories/coin_repository.dart


import '../entities/coin_balance.dart';

abstract class CoinRepository {
  Future<CoinBalance> getCoinBalance();
  Future<void> updateCoinBalance(int newBalance);
  Future<void> addCoins(int amount);
}
