import 'package:flutter/material.dart';
import 'package:ik_app/models/transaction.dart';
import 'package:ik_app/repositories/transaction_repository.dart';

class TransactionService with ChangeNotifier {
  List<Transaction> transactions = [];
  TransactionRepository transactionRepository = TransactionRepository();

  Future<void> list() async {
    final value = await transactionRepository.list(TransactionFilter());
    transactions = value;
    notifyListeners();
  }
}
