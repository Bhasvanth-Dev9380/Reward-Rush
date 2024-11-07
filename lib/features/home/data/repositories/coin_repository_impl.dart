// lib/features/home/data/repositories/coin_repository_impl.dart

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/coin_balance.dart';
import '../../domain/repositories/coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  static const String _balanceKey = 'coin_balance';

  @override
  Future<CoinBalance> getCoinBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final balance = prefs.getInt(_balanceKey) ?? 1000; // Default balance of 1000 if not set
    return CoinBalance(balance: balance);
  }

  @override
  Future<void> updateCoinBalance(int newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, newBalance); // Persist the new balance
  }

  @override
  Future<void> addCoins(int amount) async {
    final currentBalance = (await getCoinBalance()).balance;
    final newBalance = currentBalance + amount;
    await updateCoinBalance(newBalance);
  }
}
