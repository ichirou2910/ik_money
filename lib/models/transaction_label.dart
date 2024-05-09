class TransactionLabel {
  int id;
  String code;
  String description;
  String color;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionLabel(
      {required this.id,
      required this.code,
      required this.description,
      required this.color,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
}
