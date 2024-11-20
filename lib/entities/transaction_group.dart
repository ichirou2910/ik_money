import '../entities/transaction_transaction_group_mapping.dart';
import '../utils/consts.dart';

class TransactionGroup {
  int id;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  List<TransactionTransactionGroupMapping> transactionTransactionGroupMappings;

  TransactionGroup({
    this.id = 0,
    this.name = "",
    this.description = "",
    createdAt,
    updatedAt,
    this.deletedAt,
    this.transactionTransactionGroupMappings = const [],
  })  : createdAt = createdAt ?? Consts.DATE_TIME_DEFAULT,
        updatedAt = updatedAt ?? Consts.DATE_TIME_DEFAULT;
}
