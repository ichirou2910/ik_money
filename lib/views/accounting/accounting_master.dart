import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ik_app/services/transaction_service.dart';
import 'package:ik_app/views/accounting/transaction_card.dart';
import 'package:provider/provider.dart';

class AccountingMasterView extends StatelessWidget {
  const AccountingMasterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transactions"),
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
                                        "/accounting/transaction/${provider.transactions[i].id}"),
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
    );
  }
}
