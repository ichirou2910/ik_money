import '../models/transaction.dart';
import '../models/transaction_label.dart';

class TransactionTransactionLabelMappingDAO {
  int transactionId;
  int transactionLabelId;
  TransactionDAO transaction;
  TransactionLabelDAO transactionLabel;

  TransactionTransactionLabelMappingDAO({
    this.transactionId = 0,
    this.transactionLabelId = 0,
    transaction,
    transactionLabel,
  })  : transaction = transaction ?? TransactionDAO(),
        transactionLabel = transactionLabel ?? TransactionLabelDAO();

  TransactionTransactionLabelMappingDAO.fromMap(Map<String, dynamic> data)
      : transactionId = data['transaction_id'],
        transactionLabelId = data['transaction_label_id'],
        transactionLabel = TransactionLabelDAO(),
        transaction = TransactionDAO();
}
