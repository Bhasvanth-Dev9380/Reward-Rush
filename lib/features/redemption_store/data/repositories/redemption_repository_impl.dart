// lib/features/redemption_store/data/repositories/redemption_repository_impl.dart

import '../../domain/entities/redemption_item.dart';
import '../../domain/repositories/redemption_repository.dart';
import '../models/redemption_item_model.dart';

class RedemptionRepositoryImpl implements RedemptionRepository {
  @override
  Future<List<RedemptionItem>> getRedemptionItems() async {
    // Mock data for redeemable items
    return [
      RedemptionItem(id: '1', name: 'Amazon Gift Card', cost: 300),
      RedemptionItem(id: '2', name: 'Starbucks Voucher', cost: 200),
      RedemptionItem(id: '3', name: '10% Off on Electronics', cost: 150),
      RedemptionItem(id: '4', name: 'Free Shipping Code', cost: 50),
      RedemptionItem(id: '5', name: 'Netflix Subscription (1 Month)', cost: 500),
      RedemptionItem(id: '6', name: 'Spotify Premium (3 Months)', cost: 600),
      RedemptionItem(id: '7', name: 'Uber Ride Credit', cost: 250),
      RedemptionItem(id: '8', name: 'Apple Gift Card', cost: 1000),
      RedemptionItem(id: '9', name: 'Gym Membership Discount', cost: 400),
      RedemptionItem(id: '10', name: '10% Off Fashion', cost: 100),
      RedemptionItem(id: '11', name: 'Netflix Subscription (2 Month)', cost: 1000),
      RedemptionItem(id: '12', name: 'Spotify Premium (6 Months)', cost: 1200),
    ];
  }
}
