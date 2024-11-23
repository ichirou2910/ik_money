import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entities/transaction.dart';
import '../../entities/transaction_state.dart';
import '../../utils/helper.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
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
                  Helper.formatCurrency(transaction.amount),
                  style: TextStyle(
                    fontSize: 16,
                    color: transaction.transactionStateId ==
                            TransactionStateEnum.pending.id
                        ? Colors.grey
                        : transaction.amount > 0
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(transaction.time),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  transaction.title,
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
