import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/utils/apptoast.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_companies_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:pharma_app/app/data/models/post_models/create_order_for_local.dart';

class AllProductsController extends GetxController {
  ///////// selected customer details //////////
  final Rx<GetSectorsModel?> selectedSector = Rx<GetSectorsModel?>(null);
  final Rx<GetTownsModel?> selectedTown = Rx<GetTownsModel?>(null);
  final Rx<GetCustomersModel?> selectedCustomer = Rx<GetCustomersModel?>(null);

  // ================ Existing variables ================
  final TextEditingController searchController = TextEditingController();
  final TextEditingController companySearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final FocusNode companySearchFocusNode = FocusNode();

  var isLoading = false.obs;
  var isCompaniesLoading = false.obs;
  RxList<GetAllProductsModel> getAllProducts = <GetAllProductsModel>[].obs;
  RxList<GetAllProductsModel> filteredProducts = <GetAllProductsModel>[].obs;
  RxList<GetCompaniesModel> getCompaniesModel = <GetCompaniesModel>[].obs;
  RxList<GetCompaniesModel> filteredCompanies = <GetCompaniesModel>[].obs;
  RxString selectedCompany = "All Companies".obs;
  RxString selectedCompanyId = "".obs;

  // ================ Order Selection Variables ================
  RxList<OrderProducts> selectedProducts = <OrderProducts>[].obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble companyTotal = 0.0.obs;
  RxInt totalItems = 0.obs;
  RxInt companyTotalItems = 0.obs;

  // ================ Product Selection Methods ================
  void addProductToOrder(OrderProducts product) {
    // Check if product already exists
    final existingIndex = selectedProducts.indexWhere(
      (p) => p.productId == product.productId,
    );

    if (existingIndex != -1) {
      // Update existing product
      selectedProducts[existingIndex] = product;
    } else {
      // Add new product
      selectedProducts.add(product);
    }
    calculateTotals();
  }

  void removeProductFromOrder(String productId) {
    selectedProducts.removeWhere((p) => p.productId == productId);
    calculateTotals();
  }

  void updateProductInOrder(OrderProducts updatedProduct) {
    final index = selectedProducts.indexWhere(
      (p) => p.productId == updatedProduct.productId,
    );

    if (index != -1) {
      selectedProducts[index] = updatedProduct;
      calculateTotals();
    }
  }

  void clearOrder() {
    selectedProducts.clear();
    calculateTotals();
  }

  // ================ Calculation Methods ================
  void calculateTotals() {
    // Calculate grand totals (all products)
    totalAmount.value = selectedProducts.fold(
      0.0,
      (sum, product) => sum + (product.quantity * product.price),
    );

    // COUNT DISTINCT PRODUCTS (not sum quantities)
    totalItems.value = selectedProducts.length;

    // Calculate company-specific totals based on selected company filter
    if (selectedCompanyId.value.isNotEmpty) {
      final companyProducts = selectedProducts.where((product) {
        final productCompanyId = _getProductCompanyId(product.productId);
        return productCompanyId == selectedCompanyId.value;
      }).toList();

      companyTotal.value = companyProducts.fold(
        0.0,
        (sum, product) => sum + (product.quantity * product.price),
      );

      // COUNT DISTINCT PRODUCTS FROM THIS COMPANY (not sum quantities)
      companyTotalItems.value = companyProducts.length;
    } else {
      companyTotal.value = 0.0;
      companyTotalItems.value = 0;
    }
  }

  String _getProductCompanyId(String productId) {
    // Find the product in getAllProducts to get its company ID
    final product = getAllProducts.firstWhere(
      (p) => p.productId == productId,
      orElse: () => GetAllProductsModel(),
    );
    return product.companyId?.toString() ?? '';
  }

  // Check if product is in order
  bool isProductInOrder(String productId) {
    return selectedProducts.any((p) => p.productId == productId);
  }

  // Get product from order
  OrderProducts? getProductFromOrder(String productId) {
    try {
      return selectedProducts.firstWhere((p) => p.productId == productId);
    } catch (e) {
      return null;
    }
  }

  // Prepare order for next screen
  OrderItems prepareOrder(GetCustomersModel customer) {
    // Group products by company
    final Map<String, List<OrderProducts>> groupedProducts = {};

    for (var product in selectedProducts) {
      final companyId = _getProductCompanyId(product.productId);
      if (!groupedProducts.containsKey(companyId)) {
        groupedProducts[companyId] = [];
      }
      groupedProducts[companyId]!.add(product);
    }

    // Create OrderCompanies list
    final List<OrderCompanies> companies = groupedProducts.entries.map((entry) {
      final companyProducts = entry.value;
      final company = getCompaniesModel.firstWhere(
        (c) => c.id?.toString() == entry.key || c.companyId == entry.key,
        orElse: () => GetCompaniesModel(),
      );

      final totalAmount = companyProducts.fold(
        0.0,
        (sum, product) => sum + (product.quantity * product.price),
      );

      // COUNT DISTINCT PRODUCTS (not sum quantities)
      final totalItems = companyProducts.length;

      return OrderCompanies(
        orderId: 0,
        companyId: entry.key,
        companyName: company.companyName ?? 'Unknown Company',

        products: companyProducts,
        companyTotalAmount: totalAmount,
        companyTotalItems: totalItems, // This now counts distinct products
      );
    }).toList();

    // Create OrderItems
    return OrderItems(
      customerId: customer.customerId!,
      customerName: customer.customerName!,
      companies: companies,
      orderDate: DateTime.now(),
      totalAmount: totalAmount.value,
      totalItems: selectedProducts.length, // Count distinct products
    );
  }

  // ================ Existing methods ================
  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _setupListeners();
  }

  void _initializeData() {
    selectedCustomer.value = Get.arguments[0];
    selectedTown.value = Get.arguments[1];
    selectedSector.value = Get.arguments[2];
    fetchProducts();
    fetchCompanies();
  }

  void _setupListeners() {
    searchController.addListener(filterProducts);
    companySearchController.addListener(filterCompanies);
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      getAllProducts.value = Get.arguments[3];
      filteredProducts.value = List.from(getAllProducts);
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load products: ${error.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCompanies() async {
    try {
      isCompaniesLoading.value = true;
      getCompaniesModel.value = Get.arguments[4];
      filteredCompanies.value = List.from(getCompaniesModel);
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load companies: ${error.toString()}',
      );
    } finally {
      isCompaniesLoading.value = false;
    }
  }

  void filterProducts() {
    final query = searchController.text.toLowerCase();
    List<GetAllProductsModel> productsToFilter;

    // First filter by company if selected
    if (selectedCompanyId.value.isEmpty ||
        selectedCompany.value == "All Companies") {
      productsToFilter = List.from(getAllProducts);
    } else {
      productsToFilter = getAllProducts.where((product) {
        String productCompanyId = product.companyId.toString();
        String selectedId = selectedCompanyId.value.toString();
        return productCompanyId == selectedId;
      }).toList();
    }

    // Then filter by search query
    if (query.isEmpty) {
      filteredProducts.value = productsToFilter;
    } else {
      filteredProducts.value = productsToFilter.where((product) {
        return product.productName?.toLowerCase().contains(query) == true;
      }).toList();
    }
  }

  void filterCompanies() {
    final query = companySearchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredCompanies.value = List.from(getCompaniesModel);
    } else {
      filteredCompanies.value = getCompaniesModel.where((company) {
        return company.companyName?.toLowerCase().contains(query) == true;
      }).toList();
    }
  }

  void selectCompany(String companyName, [String? companyId]) {
    selectedCompany.value = companyName;
    selectedCompanyId.value = companyId ?? "";
    companySearchController.clear();
    Get.back();
    filterProducts();
    calculateTotals(); // Recalculate totals when company changes
  }

  void clearCompanySearch() {
    companySearchController.clear();
    filteredCompanies.value = List.from(getCompaniesModel);
  }

  void refreshData() {
    fetchProducts();
    fetchCompanies();
  }

  // Get products count for a specific company
  int getProductsCountForCompany(String companyId) {
    if (companyId.isEmpty) return getAllProducts.length;
    return getAllProducts.where((product) {
      return product.companyId.toString() == companyId;
    }).length;
  }
}
