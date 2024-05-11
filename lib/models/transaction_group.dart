class TransactionGroupDAO {
  int id;
  String name;
  String description;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionGroupDAO(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  TransactionGroupDAO.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        description = data['description'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];

  TransactionGroupDAO.fromMappingMap(Map<String, dynamic> data)
      : id = 0,
        name = data['name'],
        description = data['description'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];
}
