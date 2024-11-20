import '../entities/filters.dart';
import '../entities/transaction_transaction_group_mapping.dart';
import '../entities/transaction_transaction_label_mapping.dart';
import '../utils/consts.dart';

class Transaction {
  int id;
  int amount;
  String title;
  String description;
  DateTime time;
  int transactionStateId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  List<TransactionTransactionLabelMapping> transactionTransactionLabelMappings;
  List<TransactionTransactionGroupMapping> transactionTransactionGroupMappings;

  Transaction({
    this.id = 0,
    this.amount = 0,
    this.title = "",
    this.description = "",
    time,
    this.transactionStateId = 0,
    createdAt,
    updatedAt,
    this.deletedAt,
    this.transactionTransactionLabelMappings = const [],
    this.transactionTransactionGroupMappings = const [],
  })  : time = time ?? Consts.DATE_TIME_DEFAULT,
        createdAt = createdAt ?? Consts.DATE_TIME_DEFAULT,
        updatedAt = updatedAt ?? Consts.DATE_TIME_DEFAULT;
}

class TransactionFilter {
  IdFilter? id;
  DateFilter? time;
  IdFilter? transactionStateId;
}
