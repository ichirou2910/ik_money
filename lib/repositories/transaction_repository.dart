import 'package:sqflite/sqflite.dart' as sql;

import '../entities/transaction.dart';
import '../entities/transaction_group.dart';
import '../entities/transaction_label.dart';
import '../entities/transaction_transaction_group_mapping.dart';
import '../entities/transaction_transaction_label_mapping.dart';
import '../models/transaction.dart';
import '../models/transaction_group.dart';
import '../models/transaction_label.dart';
import '../models/transaction_transaction_group_mapping.dart';
import '../models/transaction_transaction_label_mapping.dart';
import '../utils/consts.dart';
import 'data_context.dart';

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
              title: e.title,
              description: e.description,
              time: DateTime.parse(e.time),
              transactionStateId: e.transactionStateId,
              createdAt: DateTime.parse(e.createdAt),
              updatedAt: DateTime.parse(e.updatedAt),
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
      SELECT ttlm.*, tl.code, tl.description, tl.color
      FROM ${Consts.DB_TRANSACTION_TRANSACTION_LABEL_MAPPING} AS ttlm
      LEFT JOIN ${Consts.DB_TRANSACTION_LABEL} AS tl ON ttlm.transaction_label_id = tl.id
      WHERE ttlm.transaction_id = $id
    ''');
    List<TransactionTransactionLabelMappingDAO>
        transactionTransactionLabelMappingDAOs = labelQuery
            .map((Map<String, dynamic> e) =>
                TransactionTransactionLabelMappingDAO(
                  transactionId: e['transaction_id'],
                  transactionLabelId: e['transaction_label_id'],
                  transactionLabel: TransactionLabelDAO(
                    code: e['code'],
                    description: e['description'],
                    color: e['color'],
                  ),
                ))
            .toList();

    var groupQuery = await db.rawQuery('''
      SELECT ttgm.*, tg.name, tg.description
      FROM ${Consts.DB_TRANSACTION_TRANSACTION_GROUP_MAPPING} AS ttgm
      LEFT JOIN ${Consts.DB_TRANSACTION_GROUP} AS tg ON ttgm.transaction_group_id = tg.id
      WHERE ttgm.transaction_id = $id
    ''');
    List<TransactionTransactionGroupMappingDAO>
        transactionTransactionGroupMappingDAOs = groupQuery
            .map((Map<String, dynamic> e) =>
                TransactionTransactionGroupMappingDAO(
                  transactionId: e['transaction_id'],
                  transactionGroupId: e['transaction_group_id'],
                  transactionGroup: TransactionGroupDAO(
                    name: e['name'],
                    description: e['description'],
                  ),
                ))
            .toList();

    Transaction transaction = Transaction(
      id: transactionDAO.id,
      amount: transactionDAO.amount,
      title: transactionDAO.title,
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
                      code: e.transactionLabel.code,
                      description: e.transactionLabel.description,
                      color: e.transactionLabel.color,
                    ),
                  ))
              .toList(),
      transactionTransactionGroupMappings:
          transactionTransactionGroupMappingDAOs
              .map((e) => TransactionTransactionGroupMapping(
                    transactionId: e.transactionId,
                    transactionGroupId: e.transactionGroupId,
                    transactionGroup: TransactionGroup(
                      name: e.transactionGroup.name,
                      description: e.transactionGroup.description,
                    ),
                  ))
              .toList(),
    );

    return transaction;
  }

  Future<void> create(TransactionDAO transactionDAO) async {
    final db = await _dataContext.database;
    await db.insert(
      Consts.DB_TRANSACTION,
      transactionDAO.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<void> update(TransactionDAO transactionDAO) async {
    final db = await _dataContext.database;
    await db.update(
      Consts.DB_TRANSACTION,
      transactionDAO.toMap(),
      where: 'id = ?',
      whereArgs: [transactionDAO.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _dataContext.database;
    var map = {
      'deletedAt': DateTime.now().toString(),
    };
    await db.update(
      Consts.DB_TRANSACTION,
      map,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
