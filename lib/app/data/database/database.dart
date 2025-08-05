import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class AnmolMarketingDatabase {
  static Database? _db;

  Future<Database?> get database async {
    if (_db != null) return _db;
    _db = await initializeDatabase();
    return _db;
  }

  Future<Database> initializeDatabase() async {
    try {
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "anmol_marketing_database.db");
      var db = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      return db;
    } catch (e) {
      print("Database Error: $e");
      rethrow; // Important to rethrow the error
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE companies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        CompanyId INTEGER NOT NULL,
        CompanyName TEXT NOT NULL,
        CompanyLogo TEXT NOT NULL
      )
    ''');
    await db.execute('''
     CREATE TABLE catalog(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    CompanyId INTEGER NOT NULL,
    CompanyName TEXT NOT NULL,
    CompanyLogo TEXT NOT NULL
     )
    ''');
    // New tables for orders
    await db.execute('''
    CREATE TABLE orders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId TEXT NOT NULL,
      orderDate TEXT NOT NULL,
      grandTotal REAL NOT NULL,
      totalProducts INTEGER NOT NULL
   
    )
  ''');

    await db.execute('''
    CREATE TABLE order_companies(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId TEXT NOT NULL,
      companyId INTEGER NOT NULL,
      companyName TEXT NOT NULL,
      companyLogo TEXT NOT NULL,
      companyTotal REAL NOT NULL,
      totalProducts INTEGER NOT NULL,
      FOREIGN KEY(orderId) REFERENCES orders(orderId)
    )
  ''');

    await db.execute('''
    CREATE TABLE order_products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId TEXT NOT NULL,
      companyId INTEGER NOT NULL,
      productId INTEGER NOT NULL,
      productName TEXT NOT NULL,
      productLogo TEXT NOT NULL,
      pack TEXT NOT NULL,
      productStock TEXT NOT NULL,
      tradePrice REAL NOT NULL,
      salePrice REAL NOT NULL,
      quantity INTEGER NOT NULL,
      totalPrice REAL NOT NULL,
      FOREIGN KEY(orderId) REFERENCES orders(orderId),
      FOREIGN KEY(companyId) REFERENCES order_companies(companyId)
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Example migration:
      // await db.execute('ALTER TABLE companies ADD COLUMN new_column TEXT');
      print("Database upgraded from $oldVersion to $newVersion");
    }
  }
}
