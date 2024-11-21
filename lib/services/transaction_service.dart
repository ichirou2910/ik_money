import 'package:flutter/material.dart';

import '../entities/transaction.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

class TransactionService with ChangeNotifier {
  List<Transaction> transactions = [];
  TransactionRepository transactionRepository = TransactionRepository();

  Future<void> list() async {
    final value = await transactionRepository.list(TransactionFilter());
    transactions = value;
    notifyListeners();
  }

  Future<Transaction?> get(int id) async {
    final value = await transactionRepository.get(id);
    return value;
  }

  Future<void> create(Transaction transaction) async {
    final TransactionDAO transactionDAO = TransactionDAO(
      amount: transaction.amount,
      title: transaction.title,
      description: transaction.description,
      time: transaction.time.toString(),
      transactionStateId: transaction.transactionStateId,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );
    await transactionRepository.create(transactionDAO);
  }

  Future<void> update(Transaction transaction) async {
    final TransactionDAO transactionDAO = TransactionDAO(
      id: transaction.id,
      amount: transaction.amount,
      title: transaction.title,
      description: transaction.description,
      time: transaction.time.toString(),
      transactionStateId: transaction.transactionStateId,
      createdAt: transaction.createdAt.toString(),
      updatedAt: DateTime.now().toString(),
    );
    await transactionRepository.update(transactionDAO);
  }

  Future<void> delete(int id) async {
    await transactionRepository.delete(id);
  }
}
