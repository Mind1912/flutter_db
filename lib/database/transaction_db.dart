import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/transactions.dart';

class TransactionDB {
  //DB Services
  String dbName;

  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    var appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertData(Transactions statement) async {
    //create db client obj
    var db = await openDatabase();

    //create store
    var store = intMapStoreFactory.store("expense");

    //json
    var keyID = store.add(db, {
      "id": statement.id,
      "title": statement.title,
      "amount": statement.amount,
      "date": statement.date
    });
    db.close();
    return keyID;
  }

  Future<List<Transactions>> loadAllData() async {
    //create db client obj
    var db = await openDatabase();

    //create store
    var store = intMapStoreFactory.store("expense");
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
    List<Transactions> transactionList = [];
    for (var record in snapshot) {
      int id = record.key;
      String title = record['title'].toString();
      double amount = double.parse(record['amount'].toString());
      String date = record['date'].toString();
      // print(record['title']);
      transactionList
          .add(Transactions(id: id, title: title, amount: amount, date: date));
    }
    db.close();
    return transactionList;
  }

  //my CRUD update code
  Future updateData(Transactions statement) async {
    //create db client obj
    var db = await openDatabase();

    //create store
    var store = intMapStoreFactory.store("expense");
    print("item id ${statement.id}");

    //filter with 'id'
    final finder = Finder(filter: Filter.byKey(statement.id));
    var updateResult =
        await store.update(db, statement.toMap(), finder: finder);
    print("$updateResult row(s) updated.");
    db.close();
  }

  //my CRUD update code
  Future deleteData(Transactions statement) async {
    //create db client obj
    var db = await openDatabase();

    //create store
    var store = intMapStoreFactory.store("expense");
    print("Statement id is ${statement.id}");

    //filter with 'id'
    final finder = Finder(filter: Filter.equals('id', statement.id));

    var deleteResult = await store.delete(db, finder: finder);
    print("$deleteResult row(s) deleted.");
    db.close();
  }

  Future<Transactions?> loadSingleRow(int rowId) async {
    //create db client obj
    var db = await openDatabase();

    //create store
    var store = intMapStoreFactory.store("expense");

    //Filter store by field 'id'
    var snapshot =
        await store.find(db, finder: Finder(filter: Filter.byKey(rowId)));
        

    Transactions? transaction;

    int id = int.parse(snapshot.first['id'].toString());
    String title = snapshot.first['title'].toString();
    double amount = double.parse(snapshot.first['amount'].toString());
    String date = snapshot.first['date'].toString();
    // print(record['title']);
    transaction =
        Transactions(id: id, title: title, amount: amount, date: date);

    db.close();
    return transaction;
  }
}
