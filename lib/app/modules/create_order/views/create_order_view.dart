// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/modules/widgets/custom_button.dart';
import 'package:pharma_app/app/modules/widgets/custom_searchfield.dart';
import 'package:pharma_app/app/routes/app_pages.dart';

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
                mainAxisAlignment: mainAxisSpaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: crossAxisStart,
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
                    crossAxisAlignment: crossAxisCenter,
                    children: [
                      Text(
                        "12",
                        style: context.bodySmallStyle!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      heightBox(5),
                       Text(
                        "34,3545",
                        style: context.bodySmallStyle!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold

                        ),
                      ),
                    ],
                  ),
                     SizedBox(
                width: 80,
                child: CustomButton(
                  backgroundColor: AppColors.appLightThemeBackground,
                  text: "Save",
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
                  onPressed: () {},
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

                  onPressed: () {},
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
              'IQBAL M/S',
              style: context.bodyMediumStyle!.copyWith(
                color: AppColors.whiteTextColor,
              ),
            ),
            Text(
              'Bahawal Nagar - Bahawl Nagar City',
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
              onChanged: (query) {},
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.ALL_PRODUCTS);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: crossAxisStart,
                            children: [
                              Text(
                                "Company $index",
                                style: context.bodyMediumStyle,
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
                              "12",
                              style: context.bodySmallStyle!.copyWith(
                                color: AppColors.blackTextColor,
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
                              "12,564",
                              style: context.bodySmallStyle!.copyWith(
                                color: AppColors.blackTextColor,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),

                          icon: Icon(
                            Iconsax.arrow_right_3,
                            color: AppColors.appPrimaryColor,
                            size: 15,
                          ),
                          onPressed: () {
                            Get.toNamed(Routes.CREATE_ORDER);
                          },
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.greyColor.withOpacity(0.3),
                  height: 10,
                ),
                itemCount: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
