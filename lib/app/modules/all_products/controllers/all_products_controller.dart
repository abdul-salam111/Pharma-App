import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/utils/apptoast.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_companies_model.dart';

class AllProductsController extends GetxController {
  // ================ Text Controllers & Focus Nodes ================
  final TextEditingController searchController = TextEditingController();
  final TextEditingController companySearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final FocusNode companySearchFocusNode = FocusNode();

  // ================ Observable Variables ================
  var isLoading = false.obs;
  var isCompaniesLoading = false.obs;

  // Products
  RxList<GetAllProductsModel> getAllProducts = <GetAllProductsModel>[].obs;
  RxList<GetAllProductsModel> filteredProducts = <GetAllProductsModel>[].obs;

  // Companies
  RxList<GetCompaniesModel> getCompaniesModel = <GetCompaniesModel>[].obs;
  RxList<GetCompaniesModel> filteredCompanies = <GetCompaniesModel>[].obs;
  RxString selectedCompany = "All Companies".obs;
  RxString selectedCompanyId = "".obs;

  // Totals
  RxDouble totalAmount = 0.0.obs;
  RxDouble companyTotal = 0.0.obs;
  RxInt totalItems = 0.obs;
  RxInt companyTotalItems = 0.obs;

  // ================ Lifecycle Methods ================
  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _setupListeners();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  // ================ Initialization Methods ================
  void _initializeData() {
    fetchProducts();
    fetchCompanies();
  }

  void _setupListeners() {
    searchController.addListener(filterProducts);
    companySearchController.addListener(filterCompanies);
  }

  void _disposeControllers() {
    searchController.removeListener(filterProducts);
    companySearchController.removeListener(filterCompanies);
    searchController.dispose();
    companySearchController.dispose();
    searchFocusNode.dispose();
    companySearchFocusNode.dispose();
  }

  // ================ Products Methods ================
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

  void filterProducts() {
    final query = searchController.text.toLowerCase();
    List<GetAllProductsModel> productsToFilter;

    // First filter by company if selected
    if (selectedCompanyId.value.isEmpty ||
        selectedCompany.value == "All Companies") {
      productsToFilter = List.from(getAllProducts);
    } else {
      productsToFilter = getAllProducts.where((product) {
        // Try multiple matching approaches since company ID format might vary
        String productCompanyId = product.companyId.toString();
        String selectedId = selectedCompanyId.value.toString();

        // Direct comparison
        bool directMatch = productCompanyId == selectedId;

        // In case the product uses the company's ID field instead of CompanyId
        bool idMatch = product.companyId.toString() == selectedId;

        return directMatch || idMatch;
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

  // ================ Companies Methods ================
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

    // Apply filtering after company selection
    filterProducts();

    // Calculate totals for the selected company
    calculateTotals();
  }

  void clearCompanySearch() {
    companySearchController.clear();
    filteredCompanies.value = List.from(getCompaniesModel);
  }

  // ================ Utility Methods ================
  void calculateTotals() {
    // Calculate totals based on filtered products
    double totalAmt = 0.0;
    double companyAmt = 0.0;
    totalAmount.value = totalAmt;
    companyTotal.value = companyAmt;
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
