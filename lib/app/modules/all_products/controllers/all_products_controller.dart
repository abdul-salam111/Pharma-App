import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/utils/apptoast.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/repositories/products_repository/products_repository.dart';

class AllProductsController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    searchController.addListener(filterProducts);
  }

  @override
  void onClose() {
    searchController.removeListener(filterProducts);
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  var isLoading = false.obs;

  RxList<GetAllProductsModel> getAllProducts = <GetAllProductsModel>[].obs;
  RxList<GetAllProductsModel> filteredProducts = <GetAllProductsModel>[].obs;

  void fetchProducts() async {
    try {
      isLoading.value = true;
      getAllProducts.value = await ProductsRepository.getAllProducts();
      filteredProducts.value = List.from(getAllProducts);
      isLoading.value = false;
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
    if (query.isEmpty) {
      filteredProducts.value = List.from(getAllProducts);
    } else {
      filteredProducts.value = getAllProducts.where((product) {
        return product.productName?.toLowerCase().contains(query) == true;
      }).toList();
    }
  }

  RxDouble totalAmount = 0.0.obs;
  RxDouble companyTotal = 0.0.obs;
  RxInt totalItems = 0.obs;
  RxInt companyTotalItems = 0.obs;
}
