import '../entities/transaction.dart';
import '../entities/transaction_label.dart';

class TransactionTransactionLabelMapping {
  int transactionId;
  int transactionLabelId;
  Transaction transaction;
  TransactionLabel transactionLabel;

  TransactionTransactionLabelMapping({
    this.transactionId = 0,
    this.transactionLabelId = 0,
    transaction,
    transactionLabel,
  })  : transaction = transaction ?? Transaction(),
        transactionLabel = transactionLabel ?? TransactionLabel();
}
