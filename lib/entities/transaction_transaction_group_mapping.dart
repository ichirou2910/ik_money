import '../entities/transaction.dart';
import '../entities/transaction_group.dart';

class TransactionTransactionGroupMapping {
  int transactionId;
  int transactionGroupId;
  Transaction transaction;
  TransactionGroup transactionGroup;

  TransactionTransactionGroupMapping({
    this.transactionId = 0,
    this.transactionGroupId = 0,
    transaction,
    transactionGroup,
  })  : transaction = transaction ?? Transaction(),
        transactionGroup = transactionGroup ?? TransactionGroup();
}
