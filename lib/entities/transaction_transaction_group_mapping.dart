import 'package:ik_app/entities/transaction.dart';
import 'package:ik_app/entities/transaction_group.dart';

class TransactionTransactionGroupMapping {
  int transactionId;
  int transactionGroupId;
  Transaction? transaction;
  TransactionGroup transactionGroup;

  TransactionTransactionGroupMapping({
    required this.transactionId,
    required this.transactionGroupId,
    this.transaction,
    required this.transactionGroup,
  });
}
