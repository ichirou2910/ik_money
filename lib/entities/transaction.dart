import 'package:ik_app/entities/filters.dart';
import 'package:ik_app/entities/transaction_transaction_group_mapping.dart';
import 'package:ik_app/entities/transaction_transaction_label_mapping.dart';

class Transaction {
  int id;
  int amount;
  String description;
  DateTime time;
  int transactionStateId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  List<TransactionTransactionLabelMapping> transactionTransactionLabelMappings;
  List<TransactionTransactionGroupMapping> transactionTransactionGroupMappings;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.time,
    required this.transactionStateId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.transactionTransactionLabelMappings = const [],
    this.transactionTransactionGroupMappings = const [],
  });
}

class TransactionFilter {
  IdFilter? id;
  DateFilter? time;
  IdFilter? transactionStateId;
}
