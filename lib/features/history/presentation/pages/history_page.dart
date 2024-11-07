// lib/features/history/presentation/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_state.dart';
import '../widgets/transaction_item_widget.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isDescending = true; // Flag to toggle sorting order
  String _selectedFilter = 'All'; // Filter option: "All", "Credited", or "Debited"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black12.withOpacity(0.5),
        title: Text(
          "Transaction History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: Colors.white),
            color: Colors.grey[900],
            onSelected: (value) {
              setState(() {
                _isDescending = value == 'Descending';
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Ascending',
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.orangeAccent),
                    SizedBox(width: 8),
                    Text('Sort by Ascending', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Descending',
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.orangeAccent),
                    SizedBox(width: 8),
                    Text('Sort by Descending', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
          color: Colors.black12.withOpacity(0.5),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/8,),
            Wrap(
              spacing: 8.0,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Credited'),
                _buildFilterChip('Debited'),
              ],
            ),
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TransactionLoaded) {
                    // Filter and sort transactions based on the selected order and filter type
                    final filteredTransactions = state.transactions.where((transaction) {
                      if (_selectedFilter == 'All') return true;
                      if (_selectedFilter == 'Credited') return transaction.type == "credit";
                      if (_selectedFilter == 'Debited') return transaction.type == "debit";
                      return true;
                    }).toList();

                    final sortedTransactions = List.from(filteredTransactions)
                      ..sort((a, b) => _isDescending
                          ? b.date.compareTo(a.date)
                          : a.date.compareTo(b.date));

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: sortedTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = sortedTransactions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TransactionItemWidget(
                              transaction: transaction,
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is TransactionError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No transactions found.",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build filter chip with active state styling
  Widget _buildFilterChip(String label) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: _selectedFilter == label ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: _selectedFilter == label,
      selectedColor: Colors.orangeAccent,
      backgroundColor: Colors.grey.shade700,
      onSelected: (isSelected) {
        setState(() {
          if (isSelected) _selectedFilter = label;
        });
      },
    );
  }
}
