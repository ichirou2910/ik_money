class TransactionDAO {
  int id;
  int amount;
  String title;
  String description;
  String time;
  int transactionStateId;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionDAO({
    this.id = 0,
    this.amount = 0,
    this.title = "",
    this.description = "",
    this.time = "",
    this.transactionStateId = 0,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  TransactionDAO.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        amount = data['amount'],
        title = data['title'],
        description = data['description'],
        time = data['time'],
        transactionStateId = data['transactionStateId'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];

  Map<String, dynamic> toMap() {
    var map = {
      'amount': amount,
      'title': title,
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
