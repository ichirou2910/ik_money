class TransactionLabelDAO {
  int id;
  String code;
  String description;
  String color;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionLabelDAO(
      {required this.id,
      required this.code,
      required this.description,
      required this.color,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  TransactionLabelDAO.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        code = data['code'],
        description = data['description'],
        color = data['color'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];

  TransactionLabelDAO.fromMappingMap(Map<String, dynamic> data)
      : id = 0,
        code = data['code'],
        description = data['description'],
        color = data['color'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];
}
