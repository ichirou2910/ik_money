import 'package:flutter/material.dart';
import 'package:ik_app/entities/transaction.dart';
import 'package:ik_app/repositories/transaction_repository.dart';

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
}
