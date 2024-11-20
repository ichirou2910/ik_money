class TransactionGroupDAO {
  int id;
  String name;
  String description;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionGroupDAO({
    this.id = 0,
    this.name = "",
    this.description = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  TransactionGroupDAO.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        description = data['description'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt
    };
  }
}
