import '../utils/consts.dart';

class TransactionLabel {
  int id;
  String code;
  String description;
  String color;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  TransactionLabel({
    this.id = 0,
    this.code = "",
    this.description = "",
    this.color = "",
    createdAt,
    updatedAt,
    this.deletedAt,
  })  : createdAt = createdAt ?? Consts.DATE_TIME_DEFAULT,
        updatedAt = updatedAt ?? Consts.DATE_TIME_DEFAULT;
}
