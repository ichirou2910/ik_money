import '../models/transaction.dart';
import '../models/transaction_group.dart';

class TransactionTransactionGroupMappingDAO {
  int transactionId;
  int transactionGroupId;
  TransactionDAO transaction;
  TransactionGroupDAO transactionGroup;

  TransactionTransactionGroupMappingDAO({
    this.transactionId = 0,
    this.transactionGroupId = 0,
    transaction,
    transactionGroup,
  })  : transaction = transaction ?? TransactionDAO(),
        transactionGroup = transactionGroup ?? TransactionGroupDAO();

  TransactionTransactionGroupMappingDAO.fromMap(Map<String, dynamic> data)
      : transactionId = data['transaction_id'],
        transactionGroupId = data['transaction_group_id'],
        transactionGroup = TransactionGroupDAO(),
        transaction = TransactionDAO();
}
