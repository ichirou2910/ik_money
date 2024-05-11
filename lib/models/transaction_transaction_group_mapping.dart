import 'package:ik_app/models/transaction_group.dart';

class TransactionTransactionGroupMappingDAO {
  int transactionId;
  int transactionGroupId;
  TransactionGroupDAO transactionGroup;

  TransactionTransactionGroupMappingDAO({
    required this.transactionId,
    required this.transactionGroupId,
    required this.transactionGroup,
  });

  TransactionTransactionGroupMappingDAO.fromMap(Map<String, dynamic> data)
      : transactionId = data['transaction_id'],
        transactionGroupId = data['transaction_group_id'],
        transactionGroup = TransactionGroupDAO.fromMappingMap(data);
}
