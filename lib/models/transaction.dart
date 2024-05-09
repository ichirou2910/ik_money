import 'package:ik_app/entities/filters.dart';

class Transaction {
  int id;
  int amount;
  String description;
  String time;
  bool isPending;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  Transaction(
      {required this.id,
      required this.amount,
      required this.description,
      required this.time,
      required this.isPending,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  Transaction.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        amount = data['amount'],
        description = data['description'],
        time = data['time'],
        isPending = data['isPending'] == 1 ? true : false,
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'time': time,
      'isPending': isPending,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt
    };
  }
}

class TransactionFilter {
  IdFilter? id;
  DateFilter? time;
  bool isPending = false;
}
