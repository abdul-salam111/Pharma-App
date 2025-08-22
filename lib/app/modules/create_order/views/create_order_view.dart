// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/modules/widgets/custom_button.dart';
import 'package:pharma_app/app/modules/widgets/custom_searchfield.dart';

import '../controllers/create_order_controller.dart';

class CreateOrderView extends GetView<CreateOrderController> {
  const CreateOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            color: AppColors.appPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Items",
                        style: context.bodySmallStyle!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      heightBox(5),
                      Text(
                        "Order Amount",
                        style: context.bodySmallStyle!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          "${controller.selectedProducts.length}", // Show count of distinct products
                          style: context.bodySmallStyle!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      heightBox(5),
                      Obx(
                        () => Text(
                          controller.totalAmount.value.toStringAsFixed(0),
                          style: context.bodySmallStyle!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // In your CreateOrderView, update the Save button
                  Obx(
                    () => controller.isSaving.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: 80,
                            child: CustomButton(
                              backgroundColor:
                                  AppColors.appLightThemeBackground,
                              text: "Save",
                              fontsize: 14,
                              onPressed: () {
                                controller.getAllOrders();
                              },
                              textColor: AppColors.blackTextColor,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: context.screenWidth / 2,
                height: 50,
                child: CustomButton(
                  radius: 0,
                  text: "Add Products",
                  fontsize: 14,
                  onPressed: () {
                    controller.addMoreProducts();
                  },
                  backgroundColor: Colors.green,
                ),
              ),
              SizedBox(
                width: context.screenWidth / 2,
                height: 50,
                child: CustomButton(
                  radius: 0,
                  text: "Close",
                  fontsize: 14,
                  onPressed: () {
                    controller.closeOrder();
                  },
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              '${controller.selectedCustomer.value!.customerName}',
              style: context.bodyMediumStyle!.copyWith(
                color: AppColors.whiteTextColor,
              ),
            ),
            Text(
              '${controller.selectedSector.value?.sectorName} - ${controller.selectedTown.value?.townName}',
              style: context.displayLargeStyle!.copyWith(
                color: AppColors.whiteTextColor,
              ),
            ),
          ],
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
              hintText: "Search companies...",
              onChanged: (query) {
                controller.filterCompanies();
              },
            ),
            heightBox(10),
            Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.filteredCompanies.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          "No companies found with orders",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final company = controller.filteredCompanies[index];
                          final companyId = company.id.toString();
                          final companyName =
                              company.companyName ?? 'Unknown Company';

                          final totalAmount = controller.getCompanyTotal(
                            companyId,
                          );

                          return InkWell(
                            onTap: () {
                              // Navigate to company products detail or back to all products with filter
                              controller.goToAllProducts(companyId);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          companyName,
                                          style: context.bodyMediumStyle!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Items",
                                        style: context.bodySmallStyle!.copyWith(
                                          color: AppColors.greyTextColor,
                                        ),
                                      ),
                                      Text(
                                        "${controller.getCompanyProducts(companyId).length}",
                                        style: context.bodySmallStyle!.copyWith(
                                          color: AppColors.blackTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  widthBox(20),
                                  Column(
                                    children: [
                                      Text(
                                        "Amount",
                                        style: context.bodySmallStyle!.copyWith(
                                          color: AppColors.greyTextColor,
                                        ),
                                      ),
                                      Text(
                                        totalAmount.toStringAsFixed(0),
                                        style: context.bodySmallStyle!.copyWith(
                                          color: AppColors.blackTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Iconsax.arrow_right_3,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      controller.goToAllProducts(companyId);
                                    },
                                    color: AppColors.appPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.greyColor.withOpacity(0.3),
                          height: 10,
                        ),
                        itemCount: controller.filteredCompanies.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
