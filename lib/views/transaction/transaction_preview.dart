import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../entities/transaction.dart';
import '../../entities/transaction_state.dart';
import '../../entities/transaction_transaction_group_mapping.dart';
import '../../entities/transaction_transaction_label_mapping.dart';
import '../../services/transaction_service.dart';

class TransactionPreviewView extends StatefulWidget {
  final int transactionId;

  TransactionPreviewView({super.key, required String transactionId})
      : transactionId = int.parse(transactionId),
        super();

  @override
  State<TransactionPreviewView> createState() => _TransactionPreviewViewState();
}

class _TransactionPreviewViewState extends State<TransactionPreviewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transaction details"),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/transaction-edit/${widget.transactionId}");
            },
            icon: const Icon(Icons.edit),
          )
        ],
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
                        _buildInfoCard(snap.data!),
                        _buildDescription(snap.data!.description),
                        _buildLabels(
                            snap.data?.transactionTransactionLabelMappings
                                as List<TransactionTransactionLabelMapping>),
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
            // Title
            Row(
              children: [
                Text(
                  data.title,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: DottedLine(
                dashColor: Theme.of(context).dividerColor,
              ),
            ),
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
                    color: TransactionStateEnum.transactionStates
                        .firstWhere(
                            (element) => element.id == data.transactionStateId)
                        .color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Description with any monetary value highlighted
  Widget _buildDescription(String description) {
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    final moneyRegex = RegExp(
      r'(?:\b(?:USD|EUR|GBP|JPY|VND|dollars?|euros?|pounds?|yen|dong)\b|\p{Sc})\s?\d+(?:,\d{3})*(?:\.\d{1,2})?',
      unicode: true,
    );

    final matches = moneyRegex.allMatches(description);
    int currentMatchIndex = 0;

    List<TextSpan> spans = [];
    for (Match match in matches) {
      // Add text before the match
      if (currentMatchIndex < match.start) {
        spans.add(
          TextSpan(
            text: description.substring(currentMatchIndex, match.start),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: description.substring(match.start, match.end),
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
      );

      currentMatchIndex = match.end;
    }

    // Add text after the last match
    if (currentMatchIndex < description.length) {
      spans.add(
        TextSpan(
          text: description.substring(currentMatchIndex),
          style: const TextStyle(fontSize: 17),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: RichText(
        text: TextSpan(
          children: spans,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildLabels(List<TransactionTransactionLabelMapping> mappings) {
    if (mappings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Wrap(
        spacing: 8.0,
        children: mappings.map((e) {
          return Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
            label: Text(
              e.transactionLabel.code,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(
                int.parse(e.transactionLabel.color.substring(1, 7), radix: 16) +
                    0xFF000000),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGroups(List<TransactionTransactionGroupMapping> mappings) {
    if (mappings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
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
                  subtitle: Text(mappings[idx].transactionGroup.description,
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
    );
  }
}
