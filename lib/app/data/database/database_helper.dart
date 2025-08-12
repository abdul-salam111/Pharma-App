// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_companies_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get database async {
    if (_db != null) return _db;
    _db = await initializeDatabase();
    return _db;
  }

  Future<Database> initializeDatabase() async {
    try {
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "pharmaApp.db");
      var db = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      return db;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE companies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        CompanyId TEXT NOT NULL,
        CompanyName TEXT NOT NULL,
        ASMTitle TEXT,
        DistributionCode TEXT,
        CompanyRecordID TEXT NOT NULL,
        TenantID TEXT NOT NULL 
      )
    ''');

    await db.execute('''
     CREATE TABLE sectors(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ActualSectorId INTEGER NOT NULL,
    SectorName TEXT NOT NULL,
    SectorsRecordID INTEGER NOT NULL,
    TenantID INTEGER NOT NULL
     )
    ''');

    await db.execute('''
    CREATE TABLE towns(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ActualSectorId INTEGER NOT NULL,
      ActualTownId INTEGER NOT NULL,
      TownName TEXT NOT NULL,
      TownRecordID INTEGER NOT NULL,
      TenantID INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE customers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      CustomerId TEXT,
      ActualTownId INTEGER,
      companyName TEXT,
      CustomerName TEXT NOT NULL,
      Address TEXT,
      City TEXT,
      ContactPerson TEXT,
      Phone1 TEXT,
      Phone2 TEXT,
      Phone3 TEXT,
      GSM TEXT,
      Email TEXT,
      NTN TEXT,
      STN TEXT,
      CustomerType TEXT,
      CNIC TEXT,
      CustomerRecordID TEXT,
      TenantID TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      CompanyId INTEGER,
      StrCompanyId TEXT,
      ProductId TEXT,
      GroupId INTEGER,
      ProductName TEXT,
      Packing TEXT,
      TradePrice TEXT,
      SaleDiscRatio TEXT,
      CurrentStock INTEGER,
      IsInActive TEXT,
      ProductRecordID INTEGER,
      TenantID INTEGER
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (kDebugMode) {
        print("Database upgraded from $oldVersion to $newVersion");
      }
    }
  }

  // ==================== INSERT METHODS ====================

  // Insert multiple companies
  Future<List<int>> insertCompanies(List<GetCompaniesModel> companies) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var company in companies) {
          int result = await txn.insert('companies', company.toJson());
          results.add(result);
        }
      });

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting companies: $e');
      }
      return [];
    }
  }

  // Insert Company
  Future<int> insertCompany(Map<String, dynamic> company) async {
    try {
      var dbClient = await database;
      return await dbClient!.insert('companies', company);
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting company: $e');
      }
      return -1;
    }
  }

  // Insert multiple sectors
  Future<List<int>> insertSectors(List<GetSectorsModel> sectors) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var sector in sectors) {
          int result = await txn.insert('sectors', sector.toJson());
          results.add(result);
        }
      });

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting sectors: $e');
      }
      return [];
    }
  }

  // Insert Sector
  Future<int> insertSector(Map<String, dynamic> sector) async {
    try {
      var dbClient = await database;
      return await dbClient!.insert('sectors', sector);
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting sector: $e');
      }
      return -1;
    }
  }

  // Insert multiple towns
  Future<List<int>> insertTowns(List<GetTownsModel> towns) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var town in towns) {
          int result = await txn.insert('towns', town.toJson());
          results.add(result);
        }
      });

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting towns: $e');
      }
      return [];
    }
  }

  // Insert Town
  Future<int> insertTown(Map<String, dynamic> town) async {
    try {
      var dbClient = await database;
      return await dbClient!.insert('towns', town);
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting town: $e');
      }
      return -1;
    }
  }

  // Insert multiple customers
  Future<List<int>> insertCustomers(List<GetCustomersModel> customers) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var customer in customers) {
          int result = await txn.insert('customers', customer.toJson());
          results.add(result);
        }
      });

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting customers: $e');
      }
      return [];
    }
  }

  // Insert Customer
  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    try {
      var dbClient = await database;
      return await dbClient!.insert('customers', customer);
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting customer: $e');
      }
      return -1;
    }
  }

  // Insert multiple products
  Future<List<int>> insertProducts(List<GetAllProductsModel> products) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var product in products) {
          int result = await txn.insert('products', product.toJson());
          results.add(result);
        }
      });

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting products: $e');
      }
      return [];
    }
  }

  // Insert Product
  Future<int> insertProduct(Map<String, dynamic> product) async {
    try {
      var dbClient = await database;
      return await dbClient!.insert('products', product);
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting product: $e');
      }
      return -1;
    }
  }

  // ==================== READ METHODS ====================

  // Get all sectors from local database
  Future<List<GetSectorsModel>> getAllSectors() async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps = await dbClient!.query('sectors');
      
      return maps.map((map) => GetSectorsModel.fromJson(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting sectors from database: $e');
      }
      return [];
    }
  }

  // Get all towns from local database
  Future<List<GetTownsModel>> getAllTowns() async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps = await dbClient!.query('towns');
      
      return maps.map((map) => GetTownsModel.fromJson(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting towns from database: $e');
      }
      return [];
    }
  }

  // Get all customers from local database
  Future<List<GetCustomersModel>> getAllCustomers() async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps = await dbClient!.query('customers');
      
      return maps.map((map) => GetCustomersModel.fromJson(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting customers from database: $e');
      }
      return [];
    }
  }

  // Get all companies from local database
  Future<List<GetCompaniesModel>> getAllCompanies() async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps = await dbClient!.query('companies');
      
      return maps.map((map) => GetCompaniesModel.fromJson(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting companies from database: $e');
      }
      return [];
    }
  }

  // Get all products from local database
  Future<List<GetAllProductsModel>> getAllProducts() async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps = await dbClient!.query('products');
      
      return maps.map((map) => GetAllProductsModel.fromJson(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting products from database: $e');
      }
      return [];
    }
  }

  // Get towns by sector ID
  Future<List<GetTownsModel>> getTownsBySectorId(int sectorId) async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps = await dbClient!.query(
        'towns',
        where: 'ActualSectorId = ?',
        whereArgs: [sectorId],
      );
      
      return maps.map((map) => GetTownsModel.fromJson(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting towns by sector ID: $e');
      }
      return [];
    }
  }

  // Get customers by town ID
  Future<List<GetCustomersModel>> getCustomersByTownId(int townId) async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps = await dbClient!.query(
        'customers',
        where: 'ActualTownId = ?',
        whereArgs: [townId],
      );
      
      return maps.map((map) => GetCustomersModel.fromJson(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting customers by town ID: $e');
      }
      return [];
    }
  }

  // ==================== CLEAR/DELETE METHODS ====================

  // Clear all tables
  Future<void> clearAllTables() async {
    try {
      var dbClient = await database;
      await dbClient!.transaction((txn) async {
        await txn.delete('companies');
        await txn.delete('sectors');
        await txn.delete('towns');
        await txn.delete('customers');
        await txn.delete('products');
      });
      
      if (kDebugMode) {
        print('All tables cleared successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing tables: $e');
      }
      rethrow;
    }
  }

  // Clear specific table
  Future<void> clearTable(String tableName) async {
    try {
      var dbClient = await database;
      await dbClient!.delete(tableName);
      
      if (kDebugMode) {
        print('Table $tableName cleared successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing table $tableName: $e');
      }
      rethrow;
    }
  }

  // Clear sectors table
  Future<void> clearSectors() async {
    await clearTable('sectors');
  }

  // Clear towns table
  Future<void> clearTowns() async {
    await clearTable('towns');
  }

  // Clear customers table
  Future<void> clearCustomers() async {
    await clearTable('customers');
  }

  // Clear companies table
  Future<void> clearCompanies() async {
    await clearTable('companies');
  }

  // Clear products table
  Future<void> clearProducts() async {
    await clearTable('products');
  }

  // ==================== UTILITY METHODS ====================

  // Get table row count
  Future<int> getTableCount(String tableName) async {
    try {
      var dbClient = await database;
      var result = await dbClient!.rawQuery('SELECT COUNT(*) FROM $tableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting count for table $tableName: $e');
      }
      return 0;
    }
  }

  // Check if database has data
  Future<bool> hasData() async {
    try {
      final sectorCount = await getTableCount('sectors');
      final townCount = await getTableCount('towns');
      final customerCount = await getTableCount('customers');
      
      return sectorCount > 0 && townCount > 0 && customerCount > 0;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if database has data: $e');
      }
      return false;
    }
  }

  // Print database stats
  Future<void> printDatabaseStats() async {
    if (kDebugMode) {
      final sectorCount = await getTableCount('sectors');
      final townCount = await getTableCount('towns');
      final customerCount = await getTableCount('customers');
      final companyCount = await getTableCount('companies');
      final productCount = await getTableCount('products');
      
      print('=== Database Stats ===');
      print('Sectors: $sectorCount');
      print('Towns: $townCount');
      print('Customers: $customerCount');
      print('Companies: $companyCount');
      print('Products: $productCount');
      print('======================');
    }
  }

  // Utility method to close database
  Future<void> closeDatabase() async {
    try {
      var dbClient = await database;
      await dbClient!.close();
      _db = null;
      if (kDebugMode) {
        print('Database connection closed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error closing database: $e');
      }
    }
  }}