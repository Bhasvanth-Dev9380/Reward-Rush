import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/redemption_bloc.dart';
import '../bloc/redemption_event.dart';
import '../../domain/entities/redemption_item.dart';

class RedemptionItemWidget extends StatelessWidget {
  final RedemptionItem item;

  RedemptionItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220, // Increased height to ensure everything is visible
      child: Card(
        margin: EdgeInsets.all(8),
        color: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Cost: ${item.cost} coins',
                style: TextStyle(color: Colors.orangeAccent, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  context.read<RedemptionBloc>().add(RedeemItem(item));
                },
                child: Text('Redeem', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
