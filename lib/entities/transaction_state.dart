class TransactionStateEnum {
  final int id;
  final String name;

  TransactionStateEnum({
    required this.id,
    required this.name,
  });

  static TransactionStateEnum pending =
      TransactionStateEnum(id: 0, name: "Pending");
  static TransactionStateEnum completed =
      TransactionStateEnum(id: 1, name: "Completed");
  static List<TransactionStateEnum> transactionStates = [pending, completed];
}
