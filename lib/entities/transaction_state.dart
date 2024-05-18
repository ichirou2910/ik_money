import 'package:flutter/material.dart';

class TransactionStateEnum {
  final int id;
  final String name;
  final Color color;

  TransactionStateEnum({
    required this.id,
    required this.name,
    required this.color,
  });

  static TransactionStateEnum pending =
      TransactionStateEnum(id: 0, name: "Pending", color: Colors.grey);
  static TransactionStateEnum completed =
      TransactionStateEnum(id: 1, name: "Completed", color: Colors.green);
  static List<TransactionStateEnum> transactionStates = [pending, completed];
}
