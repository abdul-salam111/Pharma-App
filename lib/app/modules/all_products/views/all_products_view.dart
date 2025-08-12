// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
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
              Column(
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
                      "${controller.companyTotalItems.value}",
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
                    Get.toNamed(Routes.CREATE_ORDER);
                  },
                  textColor: AppColors.blackTextColor,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(title: const Text('All Companies'), centerTitle: true),
        body: Padding(
          padding: screenPadding,
          child: Column(
            children: [
              heightBox(10),
              CustomSearchField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode, // ← added
                hintText: "Search medicines...",
                onChanged: (query) {
               controller.filterProducts();
                },
              ),

              Obx(
                () => controller.isLoading.value
                    ? Center(child: LoadingIndicator())
                    : Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                       itemCount: controller.filteredProducts.length,
                          itemBuilder: (context, index) {
                          final product = controller.filteredProducts[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: mainAxisSpaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: crossAxisStart,
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
                                          text: "${product.tradePrice}",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.blackTextColor,
                                                fontWeight: FontWeight.normal,
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
                                          text: "",
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
                                          text: "",
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
                                          text: "",
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
                                      constraints: BoxConstraints(),
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
}

class ProductBottomSheet extends StatelessWidget {
  final GetAllProductsModel product;
  const ProductBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final TextEditingController qtyController = TextEditingController();
    final TextEditingController bonusController = TextEditingController();
    final TextEditingController discController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

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
                  label: "Quantity",
                  labelColor: AppColors.blackTextColor,
                  controller: qtyController,
                  hintText: "Qty",

                  keyboardType: TextInputType.phone,
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

                  keyboardType: TextInputType.phone,
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
                  keyboardType: TextInputType.phone,
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
                  keyboardType: TextInputType.phone,
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
                  style: TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "${product.currentStock}",
                      style: TextStyle(
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
                  style: TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "${product.tradePrice}",
                      style: TextStyle(
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Remove",
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Update",
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
