class TransactionGroup {
  int id;
  String name;
  String description;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  TransactionGroup(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
}
