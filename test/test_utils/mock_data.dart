import 'package:../features/redemption_store/domain/entities/redemption_item.dart';

class MockData {
  static List<RedemptionItem> getMockRedemptionItems() {
    return [
      RedemptionItem(name: 'Gift Card', cost: 100),
      RedemptionItem(name: 'Discount Coupon', cost: 50),
    ];
  }
}
