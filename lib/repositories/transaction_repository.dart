import 'package:ik_app/entities/transaction.dart';
import 'package:ik_app/entities/transaction_group.dart';
import 'package:ik_app/entities/transaction_label.dart';
import 'package:ik_app/entities/transaction_transaction_group_mapping.dart';
import 'package:ik_app/entities/transaction_transaction_label_mapping.dart';
import 'package:ik_app/models/transaction.dart';
import 'package:ik_app/models/transaction_transaction_group_mapping.dart';
import 'package:ik_app/models/transaction_transaction_label_mapping.dart';
import 'package:ik_app/repositories/data_context.dart';
import 'package:ik_app/utils/consts.dart';

class TransactionRepository {
  final DataContext _dataContext = DataContext.instance;

  Future<List<Transaction>> list(TransactionFilter filter) async {
    final db = await _dataContext.database;

    var transactionResponse = await db.query(
      Consts.DB_TRANSACTION,
      where: 'deletedAt IS NULL',
    );

    List<TransactionDAO> transactionDAOs = transactionResponse.isNotEmpty
        ? transactionResponse.map((e) => TransactionDAO.fromMap(e)).toList()
        : [];

    List<Transaction> transactions = transactionDAOs
        .map((e) => Transaction(
              id: e.id,
              amount: e.amount,
              description: e.description,
              time: DateTime.parse(e.time),
              transactionStateId: e.transactionStateId,
              createdAt: DateTime.parse(e.createdAt),
              updatedAt: DateTime.parse(e.updatedAt),
              deletedAt: DateTime.tryParse(e.deletedAt ?? ""),
            ))
        .toList();

    // Sort descending
    transactions.sort((t1, t2) => t2.time.compareTo(t1.time));

    return transactions;
  }

  Future<Transaction?> get(int id) async {
    final db = await _dataContext.database;

    var transactionQuery = await db.query(
      Consts.DB_TRANSACTION,
      where: 'deletedAt IS NULL AND id = ?',
      whereArgs: [id],
      orderBy: 'id DESC',
    );
    if (transactionQuery.isEmpty) {
      return null;
    }

    TransactionDAO transactionDAO =
        transactionQuery.map((e) => TransactionDAO.fromMap(e)).toList().first;

    var labelQuery = await db.rawQuery('''
      SELECT ttlm.*, tl.code, tl.description, tl.color, tl.createdAt, tl.updatedAt
      FROM ${Consts.DB_TRANSACTION_TRANSACTION_LABEL_MAPPING} AS ttlm
      LEFT JOIN ${Consts.DB_TRANSACTION_LABEL} AS tl ON ttlm.transaction_label_id = tl.id
      WHERE ttlm.transaction_id = $id
    ''');
    List<TransactionTransactionLabelMappingDAO>
        transactionTransactionLabelMappingDAOs = labelQuery
            .map((e) => TransactionTransactionLabelMappingDAO.fromMap(e))
            .toList();

    var groupQuery = await db.rawQuery('''
      SELECT ttgm.*, tl.name, tl.description, tl.createdAt, tl.updatedAt
      FROM ${Consts.DB_TRANSACTION_TRANSACTION_GROUP_MAPPING} AS ttgm
      LEFT JOIN ${Consts.DB_TRANSACTION_GROUP} AS tl ON ttgm.transaction_group_id = tl.id
      WHERE ttgm.transaction_id = $id
    ''');
    List<TransactionTransactionGroupMappingDAO>
        transactionTransactionGroupMappingDAOs = groupQuery
            .map((e) => TransactionTransactionGroupMappingDAO.fromMap(e))
            .toList();

    Transaction transaction = Transaction(
      id: transactionDAO.id,
      amount: transactionDAO.amount,
      description: transactionDAO.description,
      time: DateTime.parse(transactionDAO.time),
      transactionStateId: transactionDAO.transactionStateId,
      createdAt: DateTime.parse(transactionDAO.createdAt),
      updatedAt: DateTime.parse(transactionDAO.updatedAt),
      deletedAt: DateTime.tryParse(transactionDAO.deletedAt ?? ""),
      transactionTransactionLabelMappings:
          transactionTransactionLabelMappingDAOs
              .map((e) => TransactionTransactionLabelMapping(
                    transactionId: e.transactionId,
                    transactionLabelId: e.transactionLabelId,
                    transactionLabel: TransactionLabel(
                      id: e.transactionLabel.id,
                      code: e.transactionLabel.code,
                      description: e.transactionLabel.description,
                      color: e.transactionLabel.color,
                      createdAt: e.transactionLabel.createdAt,
                      updatedAt: e.transactionLabel.updatedAt,
                    ),
                  ))
              .toList(),
      transactionTransactionGroupMappings:
          transactionTransactionGroupMappingDAOs
              .map((e) => TransactionTransactionGroupMapping(
                    transactionId: e.transactionId,
                    transactionGroupId: e.transactionGroupId,
                    transactionGroup: TransactionGroup(
                      id: e.transactionGroup.id,
                      name: e.transactionGroup.name,
                      description: e.transactionGroup.description,
                      createdAt: e.transactionGroup.createdAt,
                      updatedAt: e.transactionGroup.updatedAt,
                    ),
                  ))
              .toList(),
    );

    return transaction;
  }
}
