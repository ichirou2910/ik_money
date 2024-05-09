import 'package:ik_app/models/transaction.dart';
import 'package:ik_app/repositories/data_context.dart';

class TransactionRepository {
  final DataContext _dataContext = DataContext.instance;
  final String DB_TRANSACTION = "transaction";

  Future<List<Transaction>> list(TransactionFilter filter) async {
    final db = await _dataContext.database;
    var response = await db.query(DB_TRANSACTION,
        where: 'deletedAt IS NULL', orderBy: 'id DESC');
    List<Transaction> transactions = response.isNotEmpty
        ? response.map((e) => Transaction.fromMap(e)).toList()
        : [];

    return transactions;
  }
}
