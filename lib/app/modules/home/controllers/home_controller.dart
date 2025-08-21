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
import 'package:pharma_app/app/services/storage.dart';

/// Controller to manage HomeScreen state and data synchronization.
class HomeController extends GetxController {
  // ================= DATABASE =================
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // ================= STATES =================
  RxBool isLoadingData = false.obs;
  RxBool isSyncingData = false.obs;
  late List<CardModel> cardList;

  // ================= OBSERVABLE DATA =================
  RxList<GetAllProductsModel> getAllProducts = <GetAllProductsModel>[].obs;
  RxList<GetAllProductsModel> filteredProducts = <GetAllProductsModel>[].obs;

  RxList<GetCompaniesModel> getCompaniesModel = <GetCompaniesModel>[].obs;
  RxList<GetCompaniesModel> filteredCompanies = <GetCompaniesModel>[].obs;

  RxList<GetSectorsModel> getAllSectors = <GetSectorsModel>[].obs;
  RxList<GetTownsModel> getAllTowns = <GetTownsModel>[].obs;
  RxList<GetCustomersModel> getAllCustomers = <GetCustomersModel>[].obs;

  // ================= LIFECYCLE =================
  @override
  void onInit() async {
    super.onInit();
    _setupCards();
    if (await storage.readValues(StorageKeys.isDatasynced) == null) {
      syncAllData();
    }
    loadLocalData();
  }

  @override
  void onClose() {
    _databaseHelper.closeDatabase(); // close DB on dispose
    super.onClose();
  }

  // ================= UI CARDS =================
  void _setupCards() {
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
  }

  // ================= SYNC METHODS =================
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

      if (Get.isDialogOpen ?? false) Get.back();
      storage.setValues(StorageKeys.isDatasynced, 'true');
    } catch (error) {
      if (Get.isDialogOpen ?? false) Get.back();
      AppToasts.showErrorToast(Get.context!, 'Sync failed: $error');
    } finally {
      isSyncingData.value = false;
    }
  }

  Future<void> _fetchAndStoreProducts() async {
    try {
      final products = await ProductsRepository.getAllProducts();
      if (products.isNotEmpty) {
        await _databaseHelper.clearProducts();
        await _databaseHelper.insertProducts(products);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchAndStoreCompanies() async {
    try {
      final companies = await CompaniesRepository.getAllCompanies();
      if (companies.isNotEmpty) {
        await _databaseHelper.clearCompanies();
        await _databaseHelper.insertCompanies(companies);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchAndStoreSectors() async {
    try {
      final sectors = await LocationRepository.getAllSectors();
      if (sectors.isNotEmpty) {
        await _databaseHelper.clearSectors();
        await _databaseHelper.insertSectors(sectors);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchAndStoreTowns() async {
    try {
      final towns = await LocationRepository.getAllTowns();
      if (towns.isNotEmpty) {
        await _databaseHelper.clearTowns();
        await _databaseHelper.insertTowns(towns);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchAndStoreCustomers() async {
    try {
      final customers = await CustomerRepository.getAllCustomers();
      if (customers.isNotEmpty) {
        await _databaseHelper.clearCustomers();
        await _databaseHelper.insertCustomers(customers);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ================= LOCAL DATA =================
  Future<void> loadLocalData() async {
    try {
      isLoadingData.value = true;

      final results = await Future.wait([
        _databaseHelper.getAllProducts(),
        _databaseHelper.getAllCompanies(),
        _databaseHelper.getAllSectors(),
        _databaseHelper.getAllTowns(),
        _databaseHelper.getAllCustomers(),
      ]);

      getAllProducts.value = results[0] as List<GetAllProductsModel>;
      getCompaniesModel.value = results[1] as List<GetCompaniesModel>;
      getAllSectors.value = results[2] as List<GetSectorsModel>;
      getAllTowns.value = results[3] as List<GetTownsModel>;
      getAllCustomers.value = results[4] as List<GetCustomersModel>;
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load local data: $error',
      );
    } finally {
      isLoadingData.value = false;
    }
  }
}

/// UI Card model for HomeScreen features.
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
