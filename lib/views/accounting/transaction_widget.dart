import 'package:flutter/material.dart';
import 'package:ik_app/models/transaction.dart';

class TransactionWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionWidget({super.key, required this.transaction});

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
          horizontal: 0,
        ),
        child: ListTile(
          title: Text(
            transaction.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
