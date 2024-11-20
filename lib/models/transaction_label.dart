class TransactionLabelDAO {
  int id;
  String code;
  String description;
  String color;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionLabelDAO({
    this.id = 0,
    this.code = "",
    this.description = "",
    this.color = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  TransactionLabelDAO.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        code = data['code'],
        description = data['description'],
        color = data['color'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        deletedAt = data['deletedAt'];
}
