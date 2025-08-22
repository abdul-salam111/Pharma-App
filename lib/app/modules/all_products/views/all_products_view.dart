// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/core/utils/apptoast.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/post_models/create_order_for_local.dart';
import 'package:pharma_app/app/modules/widgets/custom_button.dart';
import 'package:pharma_app/app/modules/widgets/custom_textfield.dart';
import 'package:pharma_app/app/modules/widgets/loading_indicator.dart';
import 'package:pharma_app/app/routes/app_pages.dart';
import '../../widgets/custom_searchfield.dart';
import '../controllers/all_products_controller.dart';

class AllProductsView extends GetView<AllProductsController> {
  const AllProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
          height: context.screenHeight * 0.12,
          width: double.infinity,
          color: AppColors.appPrimaryColor,
          child: Row(
            mainAxisAlignment: mainAxisSpaceBetween,
            crossAxisAlignment: crossAxisCenter,
            children: [
              Column(
                crossAxisAlignment: crossAxisStart,
                mainAxisAlignment: mainAxisCenter,
                children: [
                  Text(""),
                  Text(
                    "Amount",
                    style: context.bodySmallStyle!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Items",
                    style: context.bodySmallStyle!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  heightBox(3),
                ],
              ),
              Obx(
                () => controller.selectedCompanyId.isNotEmpty
                    ? Column(
                        crossAxisAlignment: crossAxisStart,
                        mainAxisAlignment: mainAxisCenter,

                        children: [
                          Text(
                            "Company",
                            style: context.bodySmallStyle!.copyWith(
                              color: Colors.white,
                            ),
                          ),

                          Obx(
                            () => Text(
                              "${controller.companyTotal.value}",
                              style: context.bodySmallStyle!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              "${controller.companyTotalItems.value}",
                              style: context.bodySmallStyle!.copyWith(
                                color: Colors.white,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ),
              Column(
                crossAxisAlignment: crossAxisStart,
                mainAxisAlignment: mainAxisCenter,
                children: [
                  heightBox(3),
                  Text(
                    "Order",
                    style: context.bodySmallStyle!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.totalAmount.value}",
                      style: context.bodySmallStyle!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.totalItems.value}",
                      style: context.bodySmallStyle!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 80,
                child: CustomButton(
                  backgroundColor: AppColors.appLightThemeBackground,
                  text: "Finalize",
                  fontsize: 14,
                  onPressed: () {
                    if (controller.selectedProducts.isEmpty) {
                      AppToasts.showErrorToast(
                        context,
                        'Please add products to order',
                      );
                      return;
                    }

                    Get.toNamed(
                      Routes.CREATE_ORDER,
                      arguments: {
                        'selectedCustomer': controller.selectedCustomer.value,
                        'selectedSector': controller.selectedSector.value,
                        'selectedTown': controller.selectedTown.value,

                        'selectedProducts': controller.selectedProducts
                            .toList(),
                        'getAllProducts': controller.getAllProducts.toList(),
                        'getCompaniesModel': controller.getCompaniesModel
                            .toList(),
                      },
                    );
                  },
                  textColor: AppColors.blackTextColor,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showCompanySelectionBottomSheet(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    controller.selectedCompany.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: screenPadding,
          child: Column(
            children: [
              heightBox(10),
              CustomSearchField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                hintText: "Search medicines...",
                onChanged: (query) {
                  controller.filterProducts();
                },
              ),
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: LoadingIndicator())
                    : Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: controller.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = controller.filteredProducts[index];
                            final selectedProduct = controller
                                .getProductFromOrder(product.productId ?? "");
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${product.productName} ${product.packing}",
                                          style: context.bodySmallStyle!
                                              .copyWith(
                                                color: AppColors.blackTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        heightBox(5),
                                        Row(
                                          children: [
                                            Text(
                                              "T.P: ${product.tradePrice}",
                                              style: context.displayLargeStyle!
                                                  .copyWith(
                                                    color:
                                                        AppColors.greyTextColor,
                                                  ),
                                            ),
                                            widthBox(5),
                                            Text(
                                              "( CS: ${product.currentStock} )",
                                              style: context.displayLargeStyle!
                                                  .copyWith(
                                                    color:
                                                        AppColors.greyTextColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "P: ",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        TextSpan(
                                          text: selectedProduct != null
                                              ? "${selectedProduct.price}"
                                              : "${product.tradePrice}",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.blackTextColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widthBox(10),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Q: ",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        TextSpan(
                                          text:
                                              selectedProduct?.quantity
                                                  .toString() ??
                                              "",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.blackTextColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widthBox(10),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "B: ",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        TextSpan(
                                          text: selectedProduct?.bonus != 0
                                              ? selectedProduct?.bonus
                                                    .toString()
                                              : "",
                                              
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.blackTextColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widthBox(10),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "D: ",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        TextSpan(
                                      
                                              text: selectedProduct?.discRatio != 0.0
                                              ? selectedProduct?.discRatio
                                                    .toString()
                                              : "",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.blackTextColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.unfold_more,
                                        size: 15,
                                      ),
                                      onPressed: () async {
                                        controller.searchFocusNode.unfocus();
                                        await Get.bottomSheet(
                                          ProductBottomSheet(product: product),
                                          isScrollControlled: true,
                                        );
                                        controller.searchFocusNode.unfocus();
                                      },
                                      color: AppColors.appPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.greyColor.withOpacity(0.3),
                            height: 2,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompanySelectionBottomSheet(BuildContext context) {
    controller.searchFocusNode.unfocus();
    Get.bottomSheet(
      CompanySelectionBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    controller.searchFocusNode.unfocus();
  }
}

class CompanySelectionBottomSheet extends GetView<AllProductsController> {
  const CompanySelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Company",
                  style: context.bodyLargeStyle!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackTextColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomSearchField(
              controller: controller.companySearchController,
              focusNode: controller.companySearchFocusNode,
              hintText: "Search companies...",
              onChanged: (query) {
                controller.filterCompanies();
              },
            ),
          ),

          // All Companies option
          ListTile(
            title: Text("All Companies", style: context.bodyMediumStyle),
            subtitle: Obx(
              () => Text(
                "${controller.getAllProducts.length} products",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            onTap: () {
              controller.selectCompany("All Companies", "");
            },
          ),

          const Divider(height: 1),

          // Companies list
          Expanded(
            child: Obx(
              () => controller.isCompaniesLoading.value
                  ? const Center(child: LoadingIndicator())
                  : controller.filteredCompanies.isEmpty
                  ? const Center(
                      child: Text(
                        "No companies found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: controller.filteredCompanies.length,
                      itemBuilder: (context, index) {
                        final company = controller.filteredCompanies[index];
                        final isSelected =
                            controller.selectedCompany.value ==
                            company.companyName;

                        return ListTile(
                          title: Text(
                            company.companyName ?? "Unknown Company",
                            style: context.bodyMediumStyle!.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            "${controller.getProductsCountForCompany(company.id?.toString() ?? "")} products",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            // Use company.id (which is 137) instead of company.companyId (which is "01")
                            // because products have CompanyId: 137 matching company.id
                            controller.selectCompany(
                              company.companyName ?? "Unknown Company",
                              company.id?.toString() ?? "",
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductBottomSheet extends GetView<AllProductsController> {
  final GetAllProductsModel product;
  const ProductBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final TextEditingController qtyController = TextEditingController();
    final TextEditingController bonusController = TextEditingController(
      text: "0",
    );
    final TextEditingController discController = TextEditingController(
      text: "0",
    );
    final TextEditingController priceController = TextEditingController(
      text: product.tradePrice.toString(),
    );

    // Check if product is already in order and pre-fill values
    final existingProduct = controller.getProductFromOrder(product.productId!);
    if (existingProduct != null) {
      qtyController.text = existingProduct.quantity.toString();
      bonusController.text = existingProduct.bonus.toString();
      discController.text = existingProduct.discRatio.toString();
      priceController.text = existingProduct.price.toString();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          heightBox(10),
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          Text(
            "${product.productName} ${product.packing}",
            style: context.bodyLargeStyle!.copyWith(
              color: AppColors.blackTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: "Quantity*",
                  labelColor: AppColors.blackTextColor,
                  controller: qtyController,
                  hintText: "Qty",
                  keyboardType: TextInputType.number,
                  borderColor: AppColors.darkGreyColor,
                  labelfontSize: 14,
                ),
              ),
              widthBox(20),
              Expanded(
                child: CustomTextFormField(
                  controller: bonusController,
                  label: "Bonus",
                  labelColor: AppColors.blackTextColor,
                  hintText: "Bns%",
                  keyboardType: TextInputType.number,
                  borderColor: AppColors.darkGreyColor,
                  labelfontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: "Discount",
                  labelColor: AppColors.blackTextColor,
                  controller: discController,
                  hintText: "Disc%",
                  keyboardType: TextInputType.number,
                  borderColor: AppColors.darkGreyColor,
                  labelfontSize: 14,
                ),
              ),
              widthBox(20),
              Expanded(
                child: CustomTextFormField(
                  controller: priceController,
                  label: "Price",
                  labelColor: AppColors.blackTextColor,
                  hintText: "${product.tradePrice}",
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  borderColor: AppColors.darkGreyColor,
                  labelfontSize: 14,
                ),
              ),
            ],
          ),
          heightBox(20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: "Available Stock: ",
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "${product.currentStock}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: "Trade Price: ",
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "${product.tradePrice}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Remove and Update buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (existingProduct != null) {
                      controller.removeProductFromOrder(product.productId!);
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    existingProduct != null ? "Remove" : "Cancel",
                    style: context.bodySmallStyle!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Validate quantity
                    if (qtyController.text.isEmpty ||
                        int.parse(qtyController.text) <= 0) {
                      AppToasts.showErrorToast(
                        context,
                        'Please enter a valid quantity',
                      );
                      return;
                    }

                    // Check stock availability
                    if (int.parse(qtyController.text) >
                        (product.currentStock ?? 0)) {
                      AppToasts.showErrorToast(
                        context,
                        'Quantity exceeds available stock',
                      );
                      return;
                    }

                    controller.addProductToOrder(
                      OrderProducts(
                        companyOrderId: product.companyId!,
                        productId: product.productId!,
                        productName: product.productName!,
                        quantity: int.parse(qtyController.text),
                        price: double.parse(
                          priceController.text.isEmpty
                              ? product.tradePrice.toString()
                              : priceController.text,
                        ),
                        bonus: int.parse(
                          bonusController.text.isEmpty
                              ? '0'
                              : bonusController.text,
                        ),
                        discRatio: double.parse(
                          discController.text.isEmpty
                              ? '0.0'
                              : discController.text,
                        ),
                      ),
                    );

                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    existingProduct != null ? "Update" : "Add to Order",
                    style: context.bodySmallStyle!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          heightBox(20),
        ],
      ),
    );
  }
}
