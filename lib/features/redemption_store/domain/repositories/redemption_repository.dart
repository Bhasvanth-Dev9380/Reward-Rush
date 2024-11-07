// lib/features/redemption_store/domain/repositories/redemption_repository.dart

import '../entities/redemption_item.dart';

abstract class RedemptionRepository {
  Future<List<RedemptionItem>> getRedemptionItems();
}
