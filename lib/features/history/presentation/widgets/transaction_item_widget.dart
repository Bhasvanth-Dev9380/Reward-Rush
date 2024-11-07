// lib/features/history/presentation/widgets/transaction_item_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';

class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;

  TransactionItemWidget({required this.transaction});

  String _formatDate(DateTime date) {
    return DateFormat('dd-mm-yyyy HH:mm:ss a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Icon for transaction type
            Icon(
              transaction.type == "credit" ? Icons.arrow_upward : Icons.arrow_downward,
              color: transaction.type == "credit" ? Colors.green : Colors.red,
              size: 30,
            ),
            SizedBox(width: 16),
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.type == "credit" ? "Credited" : "Debited",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: transaction.type == "credit" ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    _formatDate(transaction.date),
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            // Transaction amount and balance
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${transaction.amount} Coins",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                ),
                SizedBox(height: 6),
                Text(
                  "Balance: ${transaction.balanceAfter}",
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
