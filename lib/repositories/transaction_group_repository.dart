import 'package:sqflite/sqflite.dart' as sql;

import '../entities/transaction.dart';
import '../entities/transaction_group.dart';
import '../entities/transaction_transaction_group_mapping.dart';
import '../models/transaction_group.dart';
import '../models/transaction_transaction_group_mapping.dart';
import '../repositories/data_context.dart';
import '../utils/consts.dart';

class TransactionGroupRepository {
  final DataContext _dataContext = DataContext.instance;

  Future<List<TransactionGroup>> list() async {
    final db = await _dataContext.database;

    var transactionGroupResponse = await db.query(
      Consts.DB_TRANSACTION_GROUP,
      where: 'deletedAt IS NULL',
      orderBy: 'id DESC',
    );

    List<TransactionGroupDAO> transactionGroupDAOs =
        transactionGroupResponse.isNotEmpty
            ? transactionGroupResponse
                .map((e) => TransactionGroupDAO.fromMap(e))
                .toList()
            : [];

    List<TransactionGroup> transactionGroups = transactionGroupDAOs
        .map((e) => TransactionGroup(
              id: e.id,
              name: e.name,
              description: e.description,
              createdAt: DateTime.parse(e.createdAt),
              updatedAt: DateTime.parse(e.updatedAt),
            ))
        .toList();

    return transactionGroups;
  }

  Future<TransactionGroup?> get(int id) async {
    final db = await _dataContext.database;

    var transactionGroupQuery = await db.query(
      Consts.DB_TRANSACTION_GROUP,
      where: 'deletedAt IS NULL AND id = ?',
      whereArgs: [id],
      orderBy: 'id DESC',
    );
    if (transactionGroupQuery.isEmpty) {
      return null;
    }

    TransactionGroupDAO transactionGroupDAO = transactionGroupQuery
        .map((e) => TransactionGroupDAO.fromMap(e))
        .toList()
        .first;

    var groupQuery = await db.rawQuery('''
      SELECT ttgm.*, t.name, t.description, t.createdAt, t.updatedAt
      FROM ${Consts.DB_TRANSACTION_TRANSACTION_GROUP_MAPPING} AS ttgm
      LEFT JOIN ${Consts.DB_TRANSACTION} AS t ON ttgm.transaction_group_id = t.id
      WHERE ttgm.transaction_group_id = $id
    ''');
    List<TransactionTransactionGroupMappingDAO>
        transactionTransactionGroupMappingDAOs = groupQuery
            .map((e) => TransactionTransactionGroupMappingDAO.fromMap(e))
            .toList();

    TransactionGroup transaction = TransactionGroup(
      id: transactionGroupDAO.id,
      name: transactionGroupDAO.name,
      description: transactionGroupDAO.description,
      createdAt: DateTime.parse(transactionGroupDAO.createdAt),
      updatedAt: DateTime.parse(transactionGroupDAO.updatedAt),
      transactionTransactionGroupMappings:
          transactionTransactionGroupMappingDAOs
              .map((e) => TransactionTransactionGroupMapping(
                    transactionId: e.transactionId,
                    transactionGroupId: e.transactionGroupId,
                    transaction: Transaction(
                      amount: e.transaction.amount,
                      time: DateTime.parse(e.transaction.time),
                      title: e.transaction.title,
                      transactionStateId: e.transaction.transactionStateId,
                    ),
                  ))
              .toList(),
    );

    return transaction;
  }

  Future<void> create(TransactionGroupDAO transactionGroupDAO) async {
    final db = await _dataContext.database;
    await db.insert(
      Consts.DB_TRANSACTION,
      transactionGroupDAO.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<void> update(TransactionGroupDAO transactionGroupDAO) async {
    final db = await _dataContext.database;
    await db.update(
      Consts.DB_TRANSACTION,
      transactionGroupDAO.toMap(),
      where: 'id = ?',
      whereArgs: [transactionGroupDAO.id],
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
