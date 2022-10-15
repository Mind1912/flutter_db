import 'package:flutter/foundation.dart';
import 'package:flutter_db/database/transaction_db.dart';
import 'package:flutter_db/models/transactions.dart';

class TransactionProvider with ChangeNotifier {
  List<Transactions> transactions = [];

  Transactions? transaction;

  List<Transactions> getTransaction() {
    return transactions;
  }

  void addTransaction(Transactions statement) async {
    var db = TransactionDB(dbName: "transations.db");
    //add data
    await db.insertData(statement);

    //load data
    transactions = await db.loadAllData();

    //notify consumer
    notifyListeners();
  }

  //my update db
  void updateTransaction(Transactions statement) async {
    var db = TransactionDB(dbName: "transations.db");

    //save data
    await db.updateData(statement);

    //load data
    transactions = await db.loadAllData();

    //notify consumer
    notifyListeners();
  }

  // my delete db
  void deleteTransaction(Transactions statement) async {
    var db = TransactionDB(dbName: "transations.db");
    //save data
    await db.deleteData(statement);

    //load data
    transactions = await db.loadAllData();

    //notify consumer
    notifyListeners();
  }

  void initAllData() async {
    var db = TransactionDB(dbName: "transations.db");
    //load data
    transactions = await db.loadAllData();

    //notify consumer
    notifyListeners();
  }
}
