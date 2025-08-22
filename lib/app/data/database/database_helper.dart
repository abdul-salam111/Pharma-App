// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_companies_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:pharma_app/app/data/models/post_models/create_order_for_local.dart';
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
    // Updated schema to match API data structure
    await db.execute('''
      CREATE TABLE companies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        CompanyId TEXT,
        CompanyName TEXT,
        ASMTitle TEXT,
        DistributionCode TEXT,
        CompanyRecordID INTEGER,
        TenantID INTEGER
      )
    ''');

    await db.execute('''
     CREATE TABLE sectors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ActualSectorId INTEGER,
        SectorName TEXT,
        SectorsRecordID INTEGER,
        TenantID INTEGER
     )
    ''');

    await db.execute('''
    CREATE TABLE towns(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ActualSectorId INTEGER,
      ActualTownId INTEGER,
      TownName TEXT,
      TownRecordID INTEGER,
      TenantID INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE customers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      CustomerId TEXT,
      ActualTownId INTEGER,
      companyName TEXT,
      CustomerName TEXT,
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
      CustomerRecordID INTEGER,
      TenantID INTEGER
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
      TradePrice REAL,
      SaleDiscRatio REAL,
      CurrentStock INTEGER,
      IsInActive INTEGER,
      ProductRecordID INTEGER,
      TenantID INTEGER
    )
  ''');
    await db.execute('''
    CREATE TABLE orders(
      orderId INTEGER PRIMARY KEY AUTOINCREMENT,
      customerId TEXT,
      customerName TEXT,
      orderDate TEXT,
      syncDate TEXT,
      synced TEXT DEFAULT 'No',
      grandTotalProducts INTEGER DEFAULT 0,
      grandTotalAmount REAL DEFAULT 0
    )
  ''');

    await db.execute('''
    CREATE TABLE order_companies(
      companyOrderId INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER,
      companyId TEXT,
      companyName TEXT,
      totalCompanyProducts INTEGER DEFAULT 0,
      totalCompanyAmount REAL DEFAULT 0,
      FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE order_products(
      orderProductId INTEGER PRIMARY KEY AUTOINCREMENT,
      companyOrderId INTEGER,
      productId TEXT,
      productName TEXT,
      quantity INTEGER,
      bonus INTEGER DEFAULT 0,
      discRatio REAL DEFAULT 0,
      price REAL,
      FOREIGN KEY (companyOrderId) REFERENCES order_companies(companyOrderId) ON DELETE CASCADE
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

  // Order operations
  Future<int> insertOrder(OrderItems order) async {
    
    try {
    
      var dbClient = await database;

      // Insert order
      int orderId = await dbClient!.insert('orders', order.toMap());

      // Insert companies and products
      for (var company in order.companies) {
        // Create company map without companyOrderId to let SQLite auto-increment
        final companyMap = {
          'orderId': orderId,
          'companyId': company.companyId,
          'companyName': company.companyName,
          'totalCompanyProducts': company.companyTotalItems,
          'totalCompanyAmount': company.companyTotalAmount,
        };

        int companyOrderId = await dbClient.insert(
          'order_companies',
          companyMap,
        );

        for (var product in company.products) {
          // Create product map without orderProductId to let SQLite auto-increment
          final productMap = {
            'companyOrderId': companyOrderId,
            'productId': product.productId,
            'productName': product.productName,
            'quantity': product.quantity,
            'bonus': product.bonus,
            'discRatio': product.discRatio,
            'price': product.price,
          };

          await dbClient.insert('order_products', productMap);
        }
      }

      return orderId;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting order: $e');
      }
      return -1;
    }
  }

  Future<List<OrderItems>> getAllOrders() async {
    try {
      var dbClient = await database;

      // Get all orders
      List<Map<String, dynamic>> orderMaps = await dbClient!.query('orders');
      List<OrderItems> orders = [];

      for (var orderMap in orderMaps) {
        OrderItems order = OrderItems.fromMap(orderMap);

        // Get companies for this order
        List<Map<String, dynamic>> companyMaps = await dbClient.query(
          'order_companies',
          where: 'orderId = ?',
          whereArgs: [order.orderId],
        );

        List<OrderCompanies> companies = [];
        for (var companyMap in companyMaps) {
          OrderCompanies company = OrderCompanies.fromMap(companyMap);

          // Get products for this company
          List<Map<String, dynamic>> productMaps = await dbClient.query(
            'order_products',
            where: 'companyOrderId = ?',
            whereArgs: [company.companyOrderId],
          );

          company = company.copyWith(
            products: productMaps
                .map((map) => OrderProducts.fromMap(map))
                .toList(),
          );

          companies.add(company);
        }

        // Use copyWith to add companies
        order = order.copyWith(companies: companies);

        orders.add(order);
      }

      return orders;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting orders: $e');
      }
      return [];
    }
  }

  Future<void> updateOrder(OrderItems order) async {
    try {
      var dbClient = await database;

      // Update order
      await dbClient!.update(
        'orders',
        order.toMap(),
        where: 'orderId = ?',
        whereArgs: [order.orderId],
      );

      // Delete existing companies and products
      await dbClient.delete(
        'order_companies',
        where: 'orderId = ?',
        whereArgs: [order.orderId],
      );

      // Insert updated companies and products
      for (var company in order.companies) {
        // create updated company with orderId set
        final updatedCompany = company.copyWith(orderId: order.orderId);

        int companyOrderId = await dbClient.insert(
          'order_companies',
          updatedCompany.toMap(),
        );

        for (var product in updatedCompany.products) {
          // create updated product with companyOrderId set
          final updatedProduct = product.copyWith(
            companyOrderId: companyOrderId,
          );

          await dbClient.insert('order_products', updatedProduct.toMap());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating order: $e');
      }
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      var dbClient = await database;
      await dbClient!.delete(
        'orders',
        where: 'orderId = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting order: $e');
      }
    }
  }

  // ==================== HELPER METHODS FOR DATA CONVERSION ====================

  Map<String, dynamic> _convertCompanyToDbFormat(GetCompaniesModel company) {
    return {
      'CompanyId': company.companyId,
      'CompanyName': company.companyName,
      'ASMTitle': company.asmTitle,
      'DistributionCode': company.distributionCode,
      'CompanyRecordID': company.id, // Map ID to CompanyRecordID
      'TenantID': company.tenantId,
    };
  }

  Map<String, dynamic> _convertSectorToDbFormat(GetSectorsModel sector) {
    return {
      'ActualSectorId': sector.actualSectorId,
      'SectorName': sector.sectorName,
      'SectorsRecordID': sector.id, // Map ID to SectorsRecordID
      'TenantID': sector.tenantId,
    };
  }

  Map<String, dynamic> _convertTownToDbFormat(GetTownsModel town) {
    return {
      'ActualSectorId': town.actualSectorId,
      'ActualTownId': town.actualTownId,
      'TownName': town.townName,
      'TownRecordID': town.id, // Map ID to TownRecordID
      'TenantID': town.tenantId,
    };
  }

  Map<String, dynamic> _convertCustomerToDbFormat(GetCustomersModel customer) {
    return {
      'CustomerId': customer.customerId,
      'ActualTownId': customer.actualTownId,
      'companyName': null, // This field doesn't exist in your model
      'CustomerName': customer.customerName,
      'Address': customer.address,
      'City': customer.city,
      'ContactPerson': customer.contactPerson,
      'Phone1': customer.phone1,
      'Phone2': customer.phone2,
      'Phone3': customer.phone3,
      'GSM': customer.gsm,
      'Email': customer.email,
      'NTN': customer.ntn,
      'STN': customer.stn,
      'CustomerType': customer.customerType,
      'CNIC': customer.cnic,
      'CustomerRecordID': customer.id, // Map ID to CustomerRecordID
      'TenantID': customer.tenantId,
    };
  }

  Map<String, dynamic> _convertProductToDbFormat(GetAllProductsModel product) {
    return {
      'CompanyId': product.companyId,
      'StrCompanyId': product.strCompanyId,
      'ProductId': product.productId,
      'GroupId': product.groupId,
      'ProductName': product.productName,
      'Packing': product.packing,
      'TradePrice': product.tradePrice,
      'SaleDiscRatio': product.saleDiscRatio,
      'CurrentStock': product.currentStock,
      'IsInActive': product.isInActive == true
          ? 1
          : 0, // Convert boolean to integer
      'ProductRecordID': product.id, // Map ID to ProductRecordID
      'TenantID': product.tenantId,
    };
  }

  // ==================== INSERT METHODS ====================

  // Insert multiple companies
  Future<List<int>> insertCompanies(List<GetCompaniesModel> companies) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var company in companies) {
          try {
            int result = await txn.insert(
              'companies',
              _convertCompanyToDbFormat(company),
            );
            results.add(result);
          } catch (e) {
            if (kDebugMode) {
              print('Error inserting individual company: $e');
              print('Company data: ${company.toJson()}');
            }
          }
        }
      });

      if (kDebugMode) {
        print(
          'Successfully inserted ${results.length} companies out of ${companies.length}',
        );
      }

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting companies: $e');
      }
      return [];
    }
  }

  // Insert multiple sectors
  Future<List<int>> insertSectors(List<GetSectorsModel> sectors) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var sector in sectors) {
          try {
            int result = await txn.insert(
              'sectors',
              _convertSectorToDbFormat(sector),
            );
            results.add(result);
          } catch (e) {
            if (kDebugMode) {
              print('Error inserting individual sector: $e');
              print('Sector data: ${sector.toJson()}');
            }
          }
        }
      });

      if (kDebugMode) {
        print(
          'Successfully inserted ${results.length} sectors out of ${sectors.length}',
        );
      }

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting sectors: $e');
      }
      return [];
    }
  }

  // Insert multiple towns
  Future<List<int>> insertTowns(List<GetTownsModel> towns) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var town in towns) {
          try {
            int result = await txn.insert(
              'towns',
              _convertTownToDbFormat(town),
            );
            results.add(result);
          } catch (e) {
            if (kDebugMode) {
              print('Error inserting individual town: $e');
              print('Town data: ${town.toJson()}');
            }
          }
        }
      });

      if (kDebugMode) {
        print(
          'Successfully inserted ${results.length} towns out of ${towns.length}',
        );
      }

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting towns: $e');
      }
      return [];
    }
  }

  // Insert multiple customers
  Future<List<int>> insertCustomers(List<GetCustomersModel> customers) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var customer in customers) {
          try {
            int result = await txn.insert(
              'customers',
              _convertCustomerToDbFormat(customer),
            );
            results.add(result);
          } catch (e) {
            if (kDebugMode) {
              print('Error inserting individual customer: $e');
              print('Customer data: ${customer.toJson()}');
            }
          }
        }
      });

      if (kDebugMode) {
        print(
          'Successfully inserted ${results.length} customers out of ${customers.length}',
        );
      }

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting customers: $e');
      }
      return [];
    }
  }

  // Insert multiple products
  Future<List<int>> insertProducts(List<GetAllProductsModel> products) async {
    try {
      var dbClient = await database;
      List<int> results = [];

      await dbClient!.transaction((txn) async {
        for (var product in products) {
          try {
            int result = await txn.insert(
              'products',
              _convertProductToDbFormat(product),
            );
            results.add(result);
          } catch (e) {
            if (kDebugMode) {
              print('Error inserting individual product: $e');
              print('Product data: ${product.toJson()}');
            }
          }
        }
      });

      if (kDebugMode) {
        print(
          'Successfully inserted ${results.length} products out of ${products.length}',
        );
      }

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting products: $e');
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

      return maps
          .map(
            (map) => GetSectorsModel.fromJson({
              'ActualSectorId': map['ActualSectorId'],
              'SectorName': map['SectorName'],
              'ID': map['SectorsRecordID'], // Map back to ID
              'TenantID': map['TenantID'],
            }),
          )
          .toList();
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

      return maps
          .map(
            (map) => GetTownsModel.fromJson({
              'ActualSectorId': map['ActualSectorId'],
              'ActualTownId': map['ActualTownId'],
              'TownName': map['TownName'],
              'ID': map['TownRecordID'], // Map back to ID
              'TenantID': map['TenantID'],
            }),
          )
          .toList();
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

      return maps
          .map(
            (map) => GetCustomersModel.fromJson({
              'CustomerId': map['CustomerId'],
              'ActualTownId': map['ActualTownId'],
              'CustomerName': map['CustomerName'],
              'Address': map['Address'],
              'City': map['City'],
              'ContactPerson': map['ContactPerson'],
              'Phone1': map['Phone1'],
              'Phone2': map['Phone2'],
              'Phone3': map['Phone3'],
              'GSM': map['GSM'],
              'Email': map['Email'],
              'NTN': map['NTN'],
              'STN': map['STN'],
              'CustomerType': map['CustomerType'],
              'CNIC': map['CNIC'],
              'ID': map['CustomerRecordID'], // Map back to ID
              'TenantID': map['TenantID'],
            }),
          )
          .toList();
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

      return maps
          .map(
            (map) => GetCompaniesModel.fromJson({
              'CompanyId': map['CompanyId'],
              'CompanyName': map['CompanyName'],
              'ASMTitle': map['ASMTitle'],
              'DistributionCode': map['DistributionCode'],
              'ID': map['CompanyRecordID'], // Map back to ID
              'TenantID': map['TenantID'],
            }),
          )
          .toList();
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

      return maps
          .map(
            (map) => GetAllProductsModel.fromJson({
              'CompanyId': map['CompanyId'],
              'StrCompanyId': map['StrCompanyId'],
              'ProductId': map['ProductId'],
              'GroupId': map['GroupId'],
              'ProductName': map['ProductName'],
              'Packing': map['Packing'],
              'TradePrice': map['TradePrice'],
              'SaleDiscRatio': map['SaleDiscRatio'],
              'CurrentStock': map['CurrentStock'],
              'IsInActive':
                  map['IsInActive'] == 1, // Convert integer back to boolean
              'ID': map['ProductRecordID'], // Map back to ID
              'TenantID': map['TenantID'],
            }),
          )
          .toList();
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

      return maps
          .map(
            (map) => GetTownsModel.fromJson({
              'ActualSectorId': map['ActualSectorId'],
              'ActualTownId': map['ActualTownId'],
              'TownName': map['TownName'],
              'ID': map['TownRecordID'], // Map back to ID
              'TenantID': map['TenantID'],
            }),
          )
          .toList();
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

      return maps
          .map(
            (map) => GetCustomersModel.fromJson({
              'CustomerId': map['CustomerId'],
              'ActualTownId': map['ActualTownId'],
              'CustomerName': map['CustomerName'],
              'Address': map['Address'],
              'City': map['City'],
              'ContactPerson': map['ContactPerson'],
              'Phone1': map['Phone1'],
              'Phone2': map['Phone2'],
              'Phone3': map['Phone3'],
              'GSM': map['GSM'],
              'Email': map['Email'],
              'NTN': map['NTN'],
              'STN': map['STN'],
              'CustomerType': map['CustomerType'],
              'CNIC': map['CNIC'],
              'ID': map['CustomerRecordID'], // Map back to ID
              'TenantID': map['TenantID'],
            }),
          )
          .toList();
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
  }

  // Method to recreate database (for testing purposes)
  Future<void> recreateDatabase() async {
    try {
      await closeDatabase();
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "pharmaApp.db");
      await io.File(path).delete();
      _db = await initializeDatabase();
      if (kDebugMode) {
        print('Database recreated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error recreating database: $e');
      }
    }
  }
}
