// lib/features/home/domain/usecases/get_coin_balance.dart


import '../entities/coin_balance.dart';
import '../repositories/coin_repository.dart';

class GetCoinBalance {
  final CoinRepository repository;

  GetCoinBalance(this.repository);

  Future<CoinBalance> call() async {
    return await repository.getCoinBalance();
  }
}
