// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/modules/widgets/custom_button.dart';

import '../controllers/order_details_on_date_controller.dart';

class OrderDetailsOnDateView extends GetView<OrderDetailsOnDateController> {
  const OrderDetailsOnDateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('IQBAL M/S'),
            heightBox(5),
            Text(
              'Baharwal Nagar - Bahawal Nagar City',
              style: context.displayLargeStyle!.copyWith(color: Colors.white),
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
            Container(
              padding: padding12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: crossAxisStart,
                        children: [
                          Text(
                            "Order Date & Time: ",
                            style: context.bodySmallStyle,
                          ),

                          Text(
                            "04/08/2025, 11:00 AM",
                            style: context.displayLargeStyle!.copyWith(
                              color: AppColors.greyColor,
                              height: 2,
                            ),
                          ),
                        ],
                      ),

                      Spacer(),
                      Text(
                        "Rs.937264",
                        style: context.bodySmallStyle!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  heightBox(5),
                  Row(
                    children: [
                      Text("Device Order Id: ", style: context.bodySmallStyle),
                      Text(
                        "1",
                        style: context.displayLargeStyle!.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "1 Items",
                        style: context.bodySmallStyle!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  heightBox(5),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: crossAxisStart,
                        children: [
                          Text("Sync Date: ", style: context.bodySmallStyle),
                          Text(
                            "04/08/2025, 11:00 AM",
                            style: context.displayLargeStyle!.copyWith(
                              color: AppColors.greyColor,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        height: 30,
                        width: 70,
                        child: CustomButton(
                          onPressed: () {},
                          fontsize: 12,
                          text: "Edit",
                          backgroundColor: AppColors.appPrimaryColor,
                          radius: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            heightBox(10),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Container(
                          padding: defaultPadding,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.appPrimaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: mainAxisSpaceBetween,
                            children: [
                              Text(
                                "1",
                                style: context.bodySmallStyle!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "MEDI PAK PHARMA",
                                style: context.bodySmallStyle!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "1078",
                                style: context.bodySmallStyle!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: defaultPadding,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.borderColor,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Product Name",
                                  style: context.bodySmallStyle,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "Price",
                                    style: context.bodySmallStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "Qty",
                                    style: context.bodySmallStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "BNS",
                                    style: context.bodySmallStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "Disc",
                                    style: context.bodySmallStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: defaultPadding,
                          child: Column(
                            mainAxisAlignment: mainAxisStart,
                            children: List.generate(3, (index) {
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: crossAxisStart,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Panafin 100Ml INF 1s",
                                          style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "89.73",
                                              style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                              ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "1",
                                                style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                              ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "0",
                                                style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                              ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "0",
                                                style: context.displayLargeStyle!
                                              .copyWith(
                                                color: AppColors.greyTextColor,
                                              ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                 index==2?SizedBox.shrink(): Divider()
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
