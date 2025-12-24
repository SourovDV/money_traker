import 'package:money_traker/data/models/data_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _dbName = "expense_traker.db";
  static const String tableTransaction = "transactions";

  //database instance;
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  //now we have to create database path

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(path, version: _version, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableTransaction (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  money INTEGER,
  category TEXT,
  note TEXT,
  date TEXT
)
''');
  }

  //insert means data save
  static Future<int> insertTransaction(TransactionModel model) async {
    final db = await database;
    return await db.insert(tableTransaction, model.toMap());
  }

  //data read
  static Future<List<TransactionModel>> getAllTransaction() async {
    final db = await database;
    final result = await db.query(tableTransaction, orderBy: "id DESC");
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  //deleteTransaction
  static Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(tableTransaction, where: "id=?", whereArgs: [id]);
  }
//update transaction
  static Future<int> updateTransaction(TransactionModel model) async {
    final db = await database;
    return db.update(
      tableTransaction,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
