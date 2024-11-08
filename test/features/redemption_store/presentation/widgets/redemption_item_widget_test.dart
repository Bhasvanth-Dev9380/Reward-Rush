import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:../features/redemption_store/presentation/widgets/redemption_item_widget.dart';
import 'package:../features/redemption_store/domain/entities/redemption_item.dart';

void main() {
  testWidgets('RedemptionItemWidget displays item name, cost, and redeem button', (WidgetTester tester) async {
    final item = RedemptionItem(name: 'Gift Card', cost: 100);

    await tester.pumpWidget(MaterialApp(
      home: RedemptionItemWidget(item: item),
    ));

    expect(find.text('Gift Card'), findsOneWidget);
    expect(find.text('Cost: 100 coins'), findsOneWidget);
    expect(find.text('Redeem'), findsOneWidget);
  });
}
