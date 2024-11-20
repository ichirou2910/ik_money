import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/transaction_service.dart';
import '../../views/transaction/transaction_card.dart';

class TransactionMasterView extends StatefulWidget {
  const TransactionMasterView({super.key});

  @override
  State<TransactionMasterView> createState() => _TransactionMasterViewState();
}

class _TransactionMasterViewState extends State<TransactionMasterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transactions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // await _showNotification(context);
              Provider.of<TransactionService>(context, listen: false).list();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView(
          children: [
            FutureBuilder(
              future: Provider.of<TransactionService>(context, listen: false)
                  .list(),
              builder: (ctx, snap) => snap.connectionState ==
                      ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<TransactionService>(
                      builder: (ctx, provider, ch) =>
                          provider.transactions.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Empty',
                                  ),
                                )
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: provider.transactions.length,
                                  itemBuilder: (ctx, i) => GestureDetector(
                                    onTap: () => context.push(
                                        "/transaction/${provider.transactions[i].id}"),
                                    child: TransactionCard(
                                      transaction: provider.transactions[i],
                                    ),
                                  ),
                                ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/transaction-edit/0"),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
