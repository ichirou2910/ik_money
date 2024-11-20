import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../entities/transaction_group.dart';
import '../../services/transaction_group_service.dart';

class TransactionGroupMasterView extends StatefulWidget {
  const TransactionGroupMasterView({super.key});

  @override
  State<TransactionGroupMasterView> createState() =>
      _TransactionGroupMasterViewState();
}

class _TransactionGroupMasterViewState
    extends State<TransactionGroupMasterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transaction Groups"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // await _showNotification(context);
              Provider.of<TransactionGroupService>(context, listen: false)
                  .list();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView(
          children: [
            FutureBuilder(
              future:
                  Provider.of<TransactionGroupService>(context, listen: false)
                      .list(),
              builder: (ctx, snap) => snap.connectionState ==
                      ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<TransactionGroupService>(
                      builder: (ctx, provider, ch) => provider
                              .transactionGroups.isEmpty
                          ? const Center(
                              child: Text(
                                'Empty',
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provider.transactionGroups.length,
                              itemBuilder: (ctx, i) => GestureDetector(
                                onTap: () => context.push(
                                    "/transaction-group/${provider.transactionGroups[i].id}"),
                                child:
                                    _buildCard(provider.transactionGroups[i]),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/transaction-group-edit/0"),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(TransactionGroup transactionGroup) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transactionGroup.name,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(transactionGroup.createdAt),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  transactionGroup.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
