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
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  var isLoading = false.obs;

  RxList<GetAllProductsModel> getAllProducts = <GetAllProductsModel>[].obs;
  RxList<GetAllProductsModel> filterdProducts = <GetAllProductsModel>[].obs;

  void fetchProducts() async {
    try {
      isLoading.value = true;
      getAllProducts.value = await ProductsRepository.getAllProducts();
      isLoading.value = false;
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load towns: ${error.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  RxDouble totalAmount = 0.0.obs;
  RxDouble companyTotal = 0.0.obs;
  RxInt totalItems = 0.obs;
  RxInt companyTotalItems = 0.obs;
}
