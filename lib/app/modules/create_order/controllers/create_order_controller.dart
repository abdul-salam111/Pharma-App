// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/data/database/database_helper.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_companies_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:pharma_app/app/data/models/post_models/create_order_for_local.dart';
import 'package:pharma_app/app/modules/all_products/controllers/all_products_controller.dart';

class CreateOrderController extends GetxController {
  ///////// selected customer details //////////
  final Rx<GetSectorsModel?> selectedSector = Rx<GetSectorsModel?>(null);
  final Rx<GetTownsModel?> selectedTown = Rx<GetTownsModel?>(null);
  final Rx<GetCustomersModel?> selectedCustomer = Rx<GetCustomersModel?>(null);

  // ================ UI Controllers ================
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // ================ Received Data Variables ================
  RxList<OrderProducts> selectedProducts = <OrderProducts>[].obs;
  RxList<GetAllProductsModel> getAllProducts = <GetAllProductsModel>[].obs;
  RxList<GetCompaniesModel> getCompaniesModel = <GetCompaniesModel>[].obs;

  // ================ Order Management Variables ================
  RxDouble totalAmount = 0.0.obs;
  RxInt totalItems = 0.obs;
  RxBool isLoading = false.obs;

  // ================ Grouped Data by Company ================
  RxMap<String, List<OrderProducts>> groupedProductsByCompany =
      <String, List<OrderProducts>>{}.obs;
  RxList<GetCompaniesModel> companiesWithOrders = <GetCompaniesModel>[].obs;
  RxMap<String, double> companyTotals = <String, double>{}.obs;
  RxMap<String, int> companyItemCounts = <String, int>{}.obs;
  RxList<GetCompaniesModel> filteredCompanies = <GetCompaniesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _receiveAndProcessData();
    _setupListeners();
  }

  void _setupListeners() {
    searchController.addListener(filterCompanies);
  }

  // ================ Data Reception & Processing ================
  void _receiveAndProcessData() {
    try {
      // Get data from arguments
      final arguments = Get.arguments as Map<String, dynamic>?;

      if (arguments != null) {
        if (arguments['selectedCustomer'] != null) {
          selectedCustomer.value =
              arguments['selectedCustomer'] as GetCustomersModel?;
        }
        if (arguments['selectedTown'] != null) {
          selectedTown.value = arguments['selectedTown'] as GetTownsModel?;
        }
        if (arguments['selectedSector'] != null) {
          selectedSector.value =
              arguments['selectedSector'] as GetSectorsModel?;
        }
        // Receive selected products
        if (arguments['selectedProducts'] != null) {
          selectedProducts.value = List<OrderProducts>.from(
            arguments['selectedProducts'],
          );
        }

        // Receive all products
        if (arguments['getAllProducts'] != null) {
          getAllProducts.value = List<GetAllProductsModel>.from(
            arguments['getAllProducts'],
          );
        }

        // Receive companies
        if (arguments['getCompaniesModel'] != null) {
          getCompaniesModel.value = List<GetCompaniesModel>.from(
            arguments['getCompaniesModel'],
          );
        }
      }

      // Process the received data
      _processOrderData();
    } catch (e) {
      print('Error receiving data: $e');
      // Handle error - maybe show toast or navigate back
    }
  }

  void _processOrderData() {
    _calculateTotals();
    _groupProductsByCompany();
    _getCompaniesWithOrders();
    _calculateCompanyTotals();
    filteredCompanies.value = List.from(companiesWithOrders);
  }

  // ================ Data Processing Methods ================
  void _calculateTotals() {
    totalAmount.value = selectedProducts.fold(
      0.0,
      (sum, product) => sum + (product.quantity * product.price),
    );

    // Count distinct products instead of summing quantities
    totalItems.value = selectedProducts
        .length; // Changed from summing quantities to counting products
  }

  void _groupProductsByCompany() {
    final Map<String, List<OrderProducts>> grouped = {};

    for (var product in selectedProducts) {
      final companyId = product.companyOrderId.toString();

      if (!grouped.containsKey(companyId)) {
        grouped[companyId] = [];
      }
      grouped[companyId]!.add(product);
    }

    groupedProductsByCompany.value = grouped;
  }

  void _getCompaniesWithOrders() {
    final List<GetCompaniesModel> companies = [];

    for (var companyId in groupedProductsByCompany.keys) {
      final company = getCompaniesModel.firstWhere(
        (c) => c.id.toString() == companyId,
        orElse: () => GetCompaniesModel(
          id: int.tryParse(companyId),
          companyName: 'Unknown Company',
        ),
      );
      companies.add(company);
    }

    companiesWithOrders.value = companies;
  }

  void _calculateCompanyTotals() {
    final Map<String, double> totals = {};
    final Map<String, int> itemCounts = {};

    for (var entry in groupedProductsByCompany.entries) {
      final companyId = entry.key;
      final products = entry.value;

      totals[companyId] = products.fold(
        0.0,
        (sum, product) => sum + (product.quantity * product.price),
      );

      // Count distinct products instead of summing quantities
      itemCounts[companyId] = products
          .length; // Changed from summing quantities to counting products
    }

    companyTotals.value = totals;
    companyItemCounts.value = itemCounts;
  }

  // ================ Helper Methods ================
  String getCompanyName(String companyId) {
    final company = getCompaniesModel.firstWhere(
      (c) => c.id.toString() == companyId,
      orElse: () => GetCompaniesModel(companyName: 'Unknown Company'),
    );
    return company.companyName ?? 'Unknown Company';
  }

  double getCompanyTotal(String companyId) {
    return companyTotals[companyId] ?? 0.0;
  }

  int getCompanyItemCount(String companyId) {
    return companyItemCounts[companyId] ?? 0;
  }

  List<OrderProducts> getCompanyProducts(String companyId) {
    return groupedProductsByCompany[companyId] ?? [];
  }

  // ================ Search & Filter Methods ================
  void filterCompanies() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredCompanies.value = List.from(companiesWithOrders);
    } else {
      filteredCompanies.value = companiesWithOrders.where((company) {
        return company.companyName?.toLowerCase().contains(query) == true;
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    filteredCompanies.value = List.from(companiesWithOrders);
  }

  // ================ Navigation Methods ================
  void goToAllProducts([String? companyId]) {
    // Get the AllProductsController instance
    final allProductsController = Get.find<AllProductsController>();

    // Set the selected company ID and name
    if (companyId != null && companyId.isNotEmpty) {
      // Find the company name from the company ID
      final company = getCompaniesModel.firstWhere(
        (c) => c.id.toString() == companyId,
        orElse: () => GetCompaniesModel(companyName: 'Unknown Company'),
      );

      allProductsController.selectedCompanyId.value = companyId;
      allProductsController.selectedCompany.value =
          company.companyName ?? 'Unknown Company';
    } else {
      allProductsController.selectedCompanyId.value = "";
      allProductsController.selectedCompany.value = "All Companies";
    }

    // Apply the filter immediately
    allProductsController.filterProducts();
    allProductsController.calculateTotals();

    // Navigate back to all products screen
    Get.back();
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  // Update your saveOrder method in the CreateOrderController
  RxBool isSaving = false.obs;
  // Update your saveOrder method in the CreateOrderController
  Future<void> saveOrder() async {
    try {
      isSaving.value = true;
      // Create the order object
      final order = OrderItems(
        customerId: selectedCustomer.value!.customerId!,
        customerName: selectedCustomer.value!.customerName!,
        companies: _prepareCompaniesForOrder(),
        orderDate: DateTime.now(),
        totalAmount: totalAmount.value,
        totalItems: totalItems.value,
      );

      // Save to local database
      final orderId = await _databaseHelper.insertOrder(order);

      if (orderId > 0) {
        // Successfully saved
        print('Order saved successfully with ID: $orderId');

        // Show success message
        Get.snackbar(
          'Success',
          'Order saved locally',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isSaving.value = false;
        // You can navigate back or clear the order as needed
        Get.back();
      } else {
        isSaving.value = false;
        // Failed to save
        print('Failed to save order');
        Get.snackbar(
          'Error',
          'Failed to save order',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isSaving.value = false;
      print('Error saving order: $e');
      Get.snackbar(
        'Error',
        'Failed to save order: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getAllOrders() async {
    try {
      isLoading.value = true;
      final orders = await _databaseHelper.getAllOrders();

      if (orders.isNotEmpty) {
        print('=== ALL ORDERS (${orders.length}) ===');

        for (int i = 0; i < orders.length; i++) {
          final order = orders[i];
          print('\nORDER #${i + 1}:');
          print('Order ID: ${order.orderId}');
          print('Customer ID: ${order.customerId}');
          print('Customer Name: ${order.customerName}');
          print('Order Date: ${order.orderDate}');
          print('Sync Date: ${order.syncDate}');
          print('Synced Status: ${order.syncedStatus}');
          print('Total Amount: ${order.totalAmount}');
          print('Total Items: ${order.totalItems}');

          // Print companies and products
          if (order.companies.isNotEmpty) {
            print('Companies (${order.companies.length}):');

            for (int j = 0; j < order.companies.length; j++) {
              final company = order.companies[j];
              print('  Company #${j + 1}:');
              print('    Company Order ID: ${company.companyOrderId}');
              print('    Order ID: ${company.orderId}');
              print('    Company ID: ${company.companyId}');
              print('    Company Name: ${company.companyName}');
              print('    Company Total Amount: ${company.companyTotalAmount}');
              print('    Company Total Items: ${company.companyTotalItems}');

              // Print products
              if (company.products.isNotEmpty) {
                print('    Products (${company.products.length}):');

                for (int k = 0; k < company.products.length; k++) {
                  final product = company.products[k];
                  print('      Product #${k + 1}:');
                  print('        Product Order ID: ${product.orderProductId}');
                  print('        Company Order ID: ${product.companyOrderId}');
                  print('        Product ID: ${product.productId}');
                  print('        Product Name: ${product.productName}');
                  print('        Quantity: ${product.quantity}');
                  print('        Bonus: ${product.bonus}');
                  print('        Discount Ratio: ${product.discRatio}');
                  print('        Price: ${product.price}');
                  print('        Total: ${product.quantity * product.price}');
                }
              } else {
                print('    No products found for this company');
              }
            }
          } else {
            print('No companies found for this order');
          }

          print('─' * 50);
        }

        print('\nTotal orders found: ${orders.length}');
      } else {
        print('No orders found in database');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to prepare companies for the order
  List<OrderCompanies> _prepareCompaniesForOrder() {
    final List<OrderCompanies> companies = [];

    for (var entry in groupedProductsByCompany.entries) {
      final companyId = entry.key;
      final products = entry.value;
      final company = getCompaniesModel.firstWhere(
        (c) => c.id.toString() == companyId,
        orElse: () => GetCompaniesModel(companyName: 'Unknown Company'),
      );

      final companyTotal = products.fold(
        0.0,
        (sum, product) => sum + (product.quantity * product.price),
      );

      // Convert OrderProducts to the format expected by OrderCompanies
      final orderProducts = products
          .map(
            (product) => OrderProducts(
              productId: product.productId,
              productName: product.productName,
              quantity: product.quantity,
              bonus: product.bonus,
              discRatio: product.discRatio,
              price: product.price,
            ),
          )
          .toList();

      companies.add(
        OrderCompanies(
          companyOrderId: 0, // Will be set by database auto-increment
          orderId: 0, // Will be set when the order is inserted
          companyId: companyId,
          companyName: company.companyName ?? 'Unknown Company',

          products: orderProducts,
          companyTotalAmount: companyTotal,
          companyTotalItems: products.length,
        ),
      );
    }

    return companies;
  }

  void addMoreProducts() {
    // Navigate back to all products screen
    Get.back();
  }

  void closeOrder() {
    // Navigate back or show confirmation dialog
    Get.back();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
