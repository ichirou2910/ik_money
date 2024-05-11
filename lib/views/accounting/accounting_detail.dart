import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:ik_app/entities/transaction.dart';
import 'package:ik_app/entities/transaction_state.dart';
import 'package:ik_app/entities/transaction_transaction_group_mapping.dart';
import 'package:ik_app/entities/transaction_transaction_label_mapping.dart';
import 'package:ik_app/services/transaction_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountingDetailView extends StatefulWidget {
  final int transactionId;

  AccountingDetailView({super.key, required String transactionId})
      : transactionId = int.parse(transactionId),
        super();

  @override
  State<AccountingDetailView> createState() => _AccountingDetailViewState();
}

class _AccountingDetailViewState extends State<AccountingDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transaction details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FutureBuilder(
          future: Provider.of<TransactionService>(context, listen: false)
              .get(widget.transactionId),
          builder: (ctx, snap) => snap.connectionState ==
                  ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : snap.hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard(snap.data as Transaction),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _buildLabels(
                            snap.data?.transactionTransactionLabelMappings
                                as List<TransactionTransactionLabelMapping>),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _buildGroups(
                            snap.data?.transactionTransactionGroupMappings
                                as List<TransactionTransactionGroupMapping>),
                      ],
                    )
                  : const Center(child: Text('Empty')),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Transaction data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0)
                      .format(data.amount),
                  style: TextStyle(
                    fontSize: 17,
                    color: (data.amount) > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            // Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(data.time),
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            // Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'State',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  TransactionStateEnum.transactionStates
                      .firstWhere((e) => e.id == data.transactionStateId)
                      .name,
                  style: TextStyle(
                    fontSize: 17,
                    color: data.transactionStateId ==
                            TransactionStateEnum.pending.id
                        ? Colors.grey
                        : Colors.green,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: DottedLine(
                dashColor: Theme.of(context).dividerColor,
              ),
            ),
            // Description
            Row(
              children: [
                Text(
                  data.description,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabels(List<TransactionTransactionLabelMapping> mappings) {
    return mappings.isNotEmpty
        ? SizedBox(
            height: 25.0,
            child: ListView.builder(
              primary: false,
              scrollDirection: Axis.horizontal,
              itemCount: mappings.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                              mappings[index]
                                  .transactionLabel
                                  .color
                                  .substring(1, 7),
                              radix: 16) +
                          0xFF000000),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            mappings[index].transactionLabel.code,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : const SizedBox(height: 0);
  }

  Widget _buildGroups(List<TransactionTransactionGroupMapping> mappings) {
    return mappings.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text("Transaction Groups"),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: mappings.length,
                  itemBuilder: (ctx, idx) {
                    return InkWell(
                      onTap: () {
                        // TODO: navigate to group
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          mappings[idx].transactionGroup.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17),
                        ),
                        subtitle: Text(
                            mappings[idx].transactionGroup.description,
                            style: const TextStyle(fontSize: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : Container();
  }
}
