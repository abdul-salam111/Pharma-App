import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/routes/app_pages.dart';
import '../controllers/orders_on_date_controller.dart';

class OrdersOnDateView extends GetView<OrdersOnDateController> {
  const OrdersOnDateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders - 04 Aug 2025'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: 3,
        padding: screenPadding,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Get.toNamed(Routes.ORDER_DETAILS_ON_DATE);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: crossAxisStart,
                      children: [
                        Text(
                          "Order names ",
                          style: context.bodyMediumStyle!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        heightBox(2),
                        Text(
                          "Narowal, abc Pharmacy",
                          style: context.bodySmallStyle!.copyWith(
                            color: AppColors.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Rs. 1000",
                    style: context.bodyMediumStyle!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widthBox(20),
                  Image.asset(
                    "assets/icons/uploadcloud.png",
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 10),
      ),
    );
  }
}
