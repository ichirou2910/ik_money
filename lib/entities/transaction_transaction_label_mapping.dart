import 'package:ik_app/entities/transaction.dart';
import 'package:ik_app/entities/transaction_label.dart';

class TransactionTransactionLabelMapping {
  int transactionId;
  int transactionLabelId;
  Transaction? transaction;
  TransactionLabel transactionLabel;

  TransactionTransactionLabelMapping({
    required this.transactionId,
    required this.transactionLabelId,
    this.transaction,
    required this.transactionLabel,
  });
}
