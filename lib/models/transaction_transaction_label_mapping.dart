import 'package:ik_app/models/transaction_label.dart';

class TransactionTransactionLabelMappingDAO {
  int transactionId;
  int transactionLabelId;
  TransactionLabelDAO transactionLabel;

  TransactionTransactionLabelMappingDAO(
      {required this.transactionId,
      required this.transactionLabelId,
      required this.transactionLabel});

  TransactionTransactionLabelMappingDAO.fromMap(Map<String, dynamic> data)
      : transactionId = data['transaction_id'],
        transactionLabelId = data['transaction_label_id'],
        transactionLabel = TransactionLabelDAO.fromMappingMap(data);
}
