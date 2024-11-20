import 'package:flutter/material.dart';

class TransactionStateEnum {
  final int id;
  final String name;
  final Color color;

  TransactionStateEnum({
    this.id = 0,
    this.name = "",
    this.color = const Color.fromRGBO(0, 0, 0, 1),
  });

  static TransactionStateEnum pending =
      TransactionStateEnum(id: 0, name: "Pending", color: Colors.grey);
  static TransactionStateEnum completed =
      TransactionStateEnum(id: 1, name: "Completed", color: Colors.green);
  static List<TransactionStateEnum> transactionStates = [pending, completed];
}
