import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/transaction_model.dart';
import 'package:ackaf/src/data/services/api_routes/transactions_api.dart';
import 'package:ackaf/src/interface/common/loading.dart';

class MyTransactionsPage extends StatefulWidget {
  const MyTransactionsPage({Key? key}) : super(key: key);

  @override
  _MyTransactionsPageState createState() => _MyTransactionsPageState();
}

class _MyTransactionsPageState extends State<MyTransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this); // Corrected to match the number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncTransactions = ref.watch(fetchTransactionsProvider(token));
        return Scaffold(
            appBar: AppBar(
              title: const Text('My Transactions'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Approved'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Rejected'),
                ],
              ),
            ),
            body: asyncTransactions.when(
              loading: () => Center(child: LoadingAnimation()),
              error: (error, stackTrace) {
                // Handle error state
                return Center(
                  child: Text('Error loading promotions: $error'),
                );
              },
              data: (transactions) {
                print(transactions);
                final active = transactions
                    .where((transaction) => transaction.status == 'active')
                    .toList();
                final pending = transactions
                    .where((transaction) => transaction.status == 'pending')
                    .toList();
                final rejected = transactions
                    .where((transaction) => transaction.status == 'rejected')
                    .toList();
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _transactionList('All', transactions),
                    _transactionList('Approved', active),
                    _transactionList('Pending', pending),
                    _transactionList('Rejected', rejected),
                  ],
                );
              },
            ));
      },
    );
  }

  Widget _transactionList(String status, List<Transaction> transaction) {
    return ListView.builder(
      itemCount: transaction
          .length, // Number of transactions, you can adjust as needed
      itemBuilder: (context, index) {
        String formattedDate = '';
        if (transaction[index].date != null)
          formattedDate = DateFormat('d\'th\' MMMM y, h:mm a')
              .format(transaction[index].date!);

        // Output: 12th July 2025, 12:20 pm
        return Card(
          child: ListTile(
            title: Text('Transaction ID: ${transaction[index].id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${transaction[index].category}'),
                if (transaction[index].date != null)
                  Text('Date & time: $formattedDate'),
                Text('Amount paid: ₹2000'),
                Text('Status: ${transaction[index].status}'),
                if (status == 'Rejected')
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reason for rejection: Lorem ipsum dolor sit amet'),
                      Text(
                          'Description: Lorem ipsum dolor sit amet consectetur...'),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: null, // Implement re-upload logic
                        child: Text('RE-UPLOAD'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
