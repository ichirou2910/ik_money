class TransactionDAO {
  int id;
  int amount;
  String description;
  String time;
  int transactionStateId;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionDAO(
      {required this.id,
      required this.amount,
      required this.description,
      required this.time,
      required this.transactionStateId,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  TransactionDAO.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        amount = data['amount'],
        description = data['description'],
        time = data['time'],
        transactionStateId = data['transactionStateId'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];

  Map<String, dynamic> toMap() {
    var map = {
      'amount': amount,
      'description': description,
      'time': time,
      'transactionStateId': transactionStateId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt
    };
    if (id > 0) {
      map['id'] = id;
    }
    return map;
  }
}
