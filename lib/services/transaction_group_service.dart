import 'package:flutter/material.dart';

import '../entities/transaction_group.dart';
import '../models/transaction_group.dart';
import '../repositories/transaction_group_repository.dart';

class TransactionGroupService with ChangeNotifier {
  List<TransactionGroup> transactionGroups = [];
  TransactionGroupRepository transactionGroupRepository =
      TransactionGroupRepository();

  Future<void> list() async {
    final value = await transactionGroupRepository.list();
    transactionGroups = value;
    notifyListeners();
  }

  Future<TransactionGroup?> get(int id) async {
    final value = await transactionGroupRepository.get(id);
    return value;
  }

  Future<void> create(TransactionGroup transaction) async {
    final TransactionGroupDAO transactionDAO = TransactionGroupDAO(
      id: 0,
      name: transaction.name,
      description: transaction.description,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );
    await transactionGroupRepository.create(transactionDAO);
  }

  Future<void> update(TransactionGroup transaction) async {
    final TransactionGroupDAO transactionDAO = TransactionGroupDAO(
      id: transaction.id,
      name: transaction.name,
      description: transaction.description,
      createdAt: transaction.createdAt.toString(),
      updatedAt: DateTime.now().toString(),
    );
    await transactionGroupRepository.update(transactionDAO);
  }

  Future<void> delete(int id) async {
    await transactionGroupRepository.delete(id);
  }
}
