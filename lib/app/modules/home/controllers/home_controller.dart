import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/utils/apptoast.dart';
import 'package:pharma_app/app/data/database/database_helper.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_companies_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:pharma_app/app/repositories/companies_repository/companies_repository.dart';
import 'package:pharma_app/app/repositories/customer_repository/customer_repository.dart';
import 'package:pharma_app/app/repositories/location_repository/location_repository.dart';
import 'package:pharma_app/app/repositories/products_repository/products_repository.dart';
import 'package:pharma_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  // Database helper instance
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Loading states
  RxBool isLoadingData = false.obs;
  RxBool isSyncingData = false.obs;
  late List<CardModel> cardList;

  // Observable lists for data
  RxList<GetAllProductsModel> getAllProducts = <GetAllProductsModel>[].obs;
  RxList<GetAllProductsModel> filteredProducts = <GetAllProductsModel>[].obs;
  RxList<GetCompaniesModel> getCompaniesModel = <GetCompaniesModel>[].obs;
  RxList<GetCompaniesModel> filteredCompanies = <GetCompaniesModel>[].obs;
  RxList<GetSectorsModel> getAllSectors = <GetSectorsModel>[].obs;
  RxList<GetTownsModel> getAllTowns = <GetTownsModel>[].obs;
  RxList<GetCustomersModel> getAllCustomers = <GetCustomersModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    cardList = [
      CardModel(
        cardColor: const Color(0xffA2CDFF),
        cardIcon: "assets/icons/cloud_upload.png",
        cardName: "Sync Orders",
        onTap: () {
          Get.toNamed(Routes.SELECT_CUSTOMER);
        },
        textColor: const Color(0xff0872EB),
      ),
      CardModel(
        cardColor: const Color(0xffBEBAFD),
        cardIcon: "assets/icons/order_summary.png",
        cardName: "Order Summary",
        onTap: () {
          Get.toNamed(Routes.ORDERS_SUMMARY);
        },
        textColor: const Color(0xff350BBF),
      ),
      CardModel(
        cardColor: const Color(0xff90FDF0),
        cardIcon: "assets/icons/syncdata.png",
        cardName: "Sync Data",
        onTap: () async {
          await syncAllData();
        },
        textColor: const Color(0xff09877A),
      ),
      CardModel(
        cardColor: const Color(0xffFFA2A2),
        cardIcon: "assets/icons/recover.png",
        cardName: "Recover",
        onTap: () {},
        textColor: const Color(0xffED1D16),
      ),
    ];

    // Load local data initially
    loadLocalData();
  }

  // ================ SYNC ALL DATA FROM API AND STORE LOCALLY ================
  Future<void> syncAllData() async {
    if (isSyncingData.value) return;

    try {
      isSyncingData.value = true;
      AppToasts.showLoaderDialog('Syncing data from server...');

      await Future.wait([
        _fetchAndStoreProducts(),
        _fetchAndStoreCompanies(),
        _fetchAndStoreSectors(),
        _fetchAndStoreTowns(),
        _fetchAndStoreCustomers(),
      ]);

      await loadLocalData();

      // ✅ Close loader before showing success
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      AppToasts.showSuccessToast(Get.context!, 'Data synced successfully!');
      await _databaseHelper.printDatabaseStats();
    } catch (error) {
      // ✅ Close loader on error as well
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      AppToasts.showErrorToast(
        Get.context!,
        'Sync failed: ${error.toString()}',
      );
    } finally {
      isSyncingData.value = false;
    }
  }

  // ================ FETCH AND STORE PRODUCTS ================
  Future<void> _fetchAndStoreProducts() async {
    try {
      // Fetch from API
      final products = await ProductsRepository.getAllProducts();

      if (products.isNotEmpty) {
        // Clear existing products
        await _databaseHelper.clearProducts();

        // Insert new products
        await _databaseHelper.insertProducts(products);

        print('Stored ${products.length} products locally');
      }
    } catch (error) {
      print('Error fetching and storing products: $error');
      rethrow;
    }
  }

  // ================ FETCH AND STORE COMPANIES ================
  Future<void> _fetchAndStoreCompanies() async {
    try {
      // Fetch from API
      final companies = await CompaniesRepository.getAllCompanies();

      if (companies.isNotEmpty) {
        // Clear existing companies
        await _databaseHelper.clearCompanies();

        // Insert new companies
        await _databaseHelper.insertCompanies(companies);

        print('Stored ${companies.length} companies locally');
      }
    } catch (error) {
      print('Error fetching and storing companies: $error');
      rethrow;
    }
  }

  // ================ FETCH AND STORE SECTORS ================
  Future<void> _fetchAndStoreSectors() async {
    try {
      // Fetch from API
      final sectors = await LocationRepository.getAllSectors();

      if (sectors.isNotEmpty) {
        // Clear existing sectors
        await _databaseHelper.clearSectors();

        // Insert new sectors
        await _databaseHelper.insertSectors(sectors);

        print('Stored ${sectors.length} sectors locally');
      }
    } catch (error) {
      print('Error fetching and storing sectors: $error');
      rethrow;
    }
  }

  // ================ FETCH AND STORE TOWNS ================
  Future<void> _fetchAndStoreTowns() async {
    try {
      // Fetch from API
      final towns = await LocationRepository.getAllTowns();

      if (towns.isNotEmpty) {
        // Clear existing towns
        await _databaseHelper.clearTowns();

        // Insert new towns
        await _databaseHelper.insertTowns(towns);

        print('Stored ${towns.length} towns locally');
      }
    } catch (error) {
      print('Error fetching and storing towns: $error');
      rethrow;
    }
  }

  // ================ FETCH AND STORE CUSTOMERS ================
  Future<void> _fetchAndStoreCustomers() async {
    try {
      // Fetch from API
      final customers = await CustomerRepository.getAllCustomers();

      if (customers.isNotEmpty) {
        // Clear existing customers
        await _databaseHelper.clearCustomers();

        // Insert new customers
        await _databaseHelper.insertCustomers(customers);

        print('Stored ${customers.length} customers locally');
      }
    } catch (error) {
      print('Error fetching and storing customers: $error');
      rethrow;
    }
  }

  // ================ LOAD DATA FROM LOCAL DATABASE ================
  Future<void> loadLocalData() async {
    try {
      isLoadingData.value = true;

      // Load all data from local database concurrently
      final results = await Future.wait([
        _databaseHelper.getAllProducts(),
        _databaseHelper.getAllCompanies(),
        _databaseHelper.getAllSectors(),
        _databaseHelper.getAllTowns(),
        _databaseHelper.getAllCustomers(),
      ]);

      // Update observable lists
      getAllProducts.value = results[0] as List<GetAllProductsModel>;
      getCompaniesModel.value = results[1] as List<GetCompaniesModel>;

      getAllSectors.value = results[2] as List<GetSectorsModel>;
      getAllTowns.value = results[3] as List<GetTownsModel>;
      getAllCustomers.value = results[4] as List<GetCustomersModel>;
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load local data: ${error.toString()}',
      );
    } finally {
      isLoadingData.value = false;
    }
  }

  // ================ SEARCH AND FILTER METHODS ================
  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = List.from(getAllProducts);
    } else {
      filteredProducts.value = getAllProducts
          .where(
            (product) =>
                product.productName?.toLowerCase().contains(
                  query.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    }
  }

  void filterCompanies(String query) {
    if (query.isEmpty) {
      filteredCompanies.value = List.from(getCompaniesModel);
    } else {
      filteredCompanies.value = getCompaniesModel
          .where(
            (company) =>
                company.companyName?.toLowerCase().contains(
                  query.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    }
  }

  // ================ GET RELATED DATA METHODS ================
  Future<List<GetTownsModel>> getTownsBySector(int sectorId) async {
    try {
      return await _databaseHelper.getTownsBySectorId(sectorId);
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load towns: ${error.toString()}',
      );
      return [];
    }
  }

  Future<List<GetCustomersModel>> getCustomersByTown(int townId) async {
    try {
      return await _databaseHelper.getCustomersByTownId(townId);
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load customers: ${error.toString()}',
      );
      return [];
    }
  }

  // ================ UTILITY METHODS ================
  Future<void> clearAllLocalData() async {
    try {
      await _databaseHelper.clearAllTables();

      // Clear observable lists
      getAllProducts.clear();
      filteredProducts.clear();
      getCompaniesModel.clear();
      filteredCompanies.clear();
      getAllSectors.clear();
      getAllTowns.clear();
      getAllCustomers.clear();

      AppToasts.showSuccessToast(Get.context!, 'All local data cleared!');
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to clear data: ${error.toString()}',
      );
    }
  }

  Future<Map<String, int>> getDatabaseStats() async {
    return {
      'sectors': await _databaseHelper.getTableCount('sectors'),
      'towns': await _databaseHelper.getTableCount('towns'),
      'customers': await _databaseHelper.getTableCount('customers'),
      'companies': await _databaseHelper.getTableCount('companies'),
      'products': await _databaseHelper.getTableCount('products'),
    };
  }

  @override
  void onClose() {
    // Close database connection when controller is disposed
    _databaseHelper.closeDatabase();
    super.onClose();
  }
}

class CardModel {
  final Color cardColor;
  final String cardIcon;
  final String cardName;
  final VoidCallback onTap;
  final Color textColor;

  CardModel({
    required this.cardColor,
    required this.cardIcon,
    required this.cardName,
    required this.onTap,
    required this.textColor,
  });
}
